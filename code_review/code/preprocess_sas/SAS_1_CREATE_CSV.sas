options mprint;
*****************************;
* 1. Juntamos clicks de train y test;
*****************************;
data all_clicks;
	set data.train_click_: data.test_click_:
		data.test_qtime_:(rename=(query_time=time));
	Time_2 = time;
	drop time;
	rename Time_2= Time;
	drop time_id;
run;

proc sql;
	create table work.visiable_items as
	select distinct user_id, item_id
	from all_clicks
	where item_id ne . ;
quit;

proc export data=work.visiable_items outfile="&ruta.\user_data\tmp_sas_data\visiable_items_&PHASE..csv";
run;
quit;


* Quitamos items sin features;
/*
proc sql; 
	create table work.all_clicks  as
	select *
	from work.all_clicks
	where item_id in (select item_id from data.item_feat);
quit;
*/
*****************************;
* 2. Quitamos duplicados;
*****************************;
proc sort data=all_clicks nodupkey;
by user_id  time item_id;
run;
quit;
*****************************;
* 3.Quitamos clicks futuros (de los usuarios que tenemos que predecir);
* Así podemos ver el último click informado al de predecir;
*****************************;
data work.predecir;
	set data.test_qtime_:;
run;
proc sql;
	create table work.all_clicks_2 as
	select t1.*, t2.query_time
	from work.all_clicks t1
	left join work.predecir t2
	on t1.user_id = t2.user_id;
quit;


data work.train_y_test_sin_futuro;
	set work.all_clicks_2;
	where query_time = . or query_time>time;
run;


data data.train_y_test_sin_futuro;
	set work.all_clicks_2;
run;

****************************************************************************************************************;
* 4.Asignamos de donde viene el registro (de que phase)
****************************************************************************************************************;

%MACRO REGISTRO_PHASE;

	%DO Cont_phase=0 %TO &phase.;
		proc sql;
			create table work.phase_&Cont_phase. as 
			select  *
			from data.train_click_&Cont_phase.
			union all select *
			from data.test_click_&cont_phase.;
		run;

		proc sort data=train_y_test_sin_futuro; by user_id item_id TIME; run; quit;
		proc sort data=phase_&Cont_phase.; by user_id item_id TIME; run; quit;
		DATA WORK.train_y_test_sin_futuro;
			MERGE  WORK.train_y_test_sin_futuro(in=B) WORK.phase_&Cont_phase.(KEEP=USER_ID ITEM_ID TIME IN=a);
			BY USER_ID ITEM_ID TIME;
			IF B;
			if A then phase_&Cont_phase.=1;
			else phase_&Cont_phase.=0;
		RUN;

		proc sql; drop table work.phase_&Cont_phase.; quit;
	%END;

%MEND REGISTRO_PHASE;

%REGISTRO_PHASE;


****************************************************************************************************************;
* 5. Grado del Item (por phase)
****************************************************************************************************************;
%MACRO GRADO_ITEM;
	%DO cont_phase=0 %TO &phase.;
		proc sql;
			create table work.Phase as 
			select  *
				from data.train_click_&Cont_phase.
			union all select *
				from data.test_click_&cont_phase.
			;
			create table work.ContItem_&cont_phase. as
			select item_id, count(*) as ItemDegree, &cont_phase. as phase
			from work.Phase
			group by item_id;
		quit;
		proc sql; drop table work.Phase; quit;
	%END;

	data work.Grado_Item;
		set work.ContItem_:;
	run;
%MEND;
%GRADO_ITEM;

****************************************************************************************************************;
* 6. Creamos validación *;
****************************************************************************************************************;

* Creamos un indicador descendiente,
1 el último click, 2 el penúltimo click,....;

proc sort data=work.train_y_test_sin_futuro;
by user_id descending time;
run;
quit;

data work.train_y_test_sin_futuro_2;
	retain contador_last 0;
	set train_y_test_sin_futuro;
	by user_id;
	if first.user_id then contador_last = 1;
	else contador_last = contador_last + 1;
run;

* Cogemos los dos últimos registros para validar (de los usuarios de test)
y quitamos el último de la tabla de train (de los usuarios de test) (ya que es el que finalmente validaremos);
* Dividimos en train+test y validacióm;

data work.train_y_test_sin_ultimo_click(drop=contador_last query_time);
	set work.train_y_test_sin_futuro_2;
	IF query_Time = . or (query_time ne . and contador_last>1);
	rename user_id = SessionId
	item_id = ItemId
	;
run;

data work.validacion(drop= query_time);
	set work.train_y_test_sin_futuro_2;
	if contador_last in (1,2) and query_time ne .;
	phase = mod(user_id, 11);
	rename user_id = SessionId
	item_id = ItemId
	;
run;

****************************************************************;
* Añadimos el grado del item en validación ultimo click antes de renombrarlos;
******************************************************************;
proc sort data=work.validacion; by itemId phase; run; quit;
proc sort data=work.Grado_Item; by item_id phase; run; quit;

data work.validacion;
	merge work.validacion(in=A) work.Grado_Item(keep=item_id phase ItemDegree rename=(Item_id = ItemId)) ;
	by ItemId phase;
	IF A;
	IF contador_last ne 1 then itemDegree=.;
run;
proc sort data=work.validacion; by SessionId time; run; quit;
* Calculamos el indicador half;

* Train full;
data work.train_full_sin_futurazo(drop=contador_last query_time);
	set work.train_y_test_sin_futuro_2;
	rename user_id = SessionId
	item_id = ItemId
	;
run;
****************************************************************;
* Indicador de feat del item;
******************************************************************;
proc sql; create table work.items_with_feat as select distinct item_id from data.item_feat; quit;

proc sql;
	create table work.train_y_test_sin_ultimo_click as
	select t1.*, coalesce(case when not missing(t2.item_id) then 1 end,0) as Indicador_Item_Feat
	from work.train_y_test_sin_ultimo_click t1
	left join work.items_with_feat t2
	on t1.itemId = t2.item_id;
quit;

****************************************************************;
* Indicador de feat del user;
******************************************************************;
proc sql; create table work.user_with_feat as select distinct user_id from data.user_feat; quit;

proc sql;
	create table work.train_y_test_sin_ultimo_click as
	select t1.*, coalesce(case when not missing(t2.user_id) then 1 end,0) as Indicador_User_Feat
	from work.train_y_test_sin_ultimo_click t1
	left join work.user_with_feat t2
	on t1.SessionId = t2.user_id;
quit;

*************************************************************;
* 7.Y renombramos el ItemId que no está en train (validación + contador_last = 1;
*****************************************************************************;
proc sql;
	create table work.items_nuevos as
	select distinct ItemId
	from work.validacion 
	where  ItemId not in (select distinct ItemId from work.train_y_test_sin_ultimo_click);
quit;


data work.validacion;
	set work.validacion;
	if itemId=36448  then do;  itemId=60864; item_orig=36448; end;
	if itemId=69902  then do;  itemId=61020; item_orig=69902; end;
	if itemId=99039  then do;  itemId=39038; item_orig=99039; end;
	if itemId=74562  then do;  itemId=45691; item_orig=74562; end;
	if itemId=24473 then do; itemID=52027; item_orig=24473 ; end;
	if itemId=43005 then do; itemID=31175 ; item_orig=43005; end;
	if itemId=55148 then do; itemID=78135; item_orig=55148; end;
	if itemId=60403 then do; itemID=58676; item_orig=60403; end;
	if itemId=79298 then do; itemID=55674; item_orig=79298; end;
	if itemId=86290 then do; itemID=31419; item_orig=86290; end;
	if itemId=92392 then do; itemID=18582; item_orig=92392; end;
	if itemId=103318 then do; itemID=111598; item_orig=103318; end;
	if itemId=17828 then do; itemID=16034; item_orig=17828; end;
run;
data work.train_full_sin_futurazo;
	set work.train_full_sin_futurazo;
	if itemId=36448  then do;  itemId=60864; item_orig=36448; end;
	if itemId=69902  then do;  itemId=61020; item_orig=69902; end;
	if itemId=99039  then do;  itemId=39038; item_orig=99039; end;
	if itemId=74562  then do;  itemId=45691; item_orig=74562; end;
	if itemId=24473 then do; itemID=52027; item_orig=24473 ; end;
	if itemId=43005 then do; itemID=31175 ; item_orig=43005; end;
	if itemId=55148 then do; itemID=78135; item_orig=55148; end;
	if itemId=60403 then do; itemID=58676; item_orig=60403; end;
	if itemId=79298 then do; itemID=55674; item_orig=79298; end;
	if itemId=86290 then do; itemID=31419; item_orig=86290; end;
	if itemId=92392 then do; itemID=18582; item_orig=92392; end;
	if itemId=103318 then do; itemID=111598; item_orig=103318; end;
	if itemId=17828 then do; itemID=16034; item_orig=17828; end;
run;



***********************************************************************;
* Comprobamos que no haya items en validacion que no esten en train ;
***********************************************************************;
proc sql;
	create table work.check_Validacion as
	select itemId
	from work.validacion 
	where itemId not in (select itemID from work.train_y_test_sin_ultimo_click);
quit;


***********************************************************************;
* 8. Exportacion (Para Redes);
***********************************************************************;

proc export data=work.train_y_test_sin_ultimo_click(KEEP=SessionId itemid time) 
outfile="&ruta.\user_data\tmp_sas_data\train_y_test_sin_ultimo_click_phase_&PHASE..csv"
replace dbms=TAB;
run;
quit;

proc export data=work.validacion(KEEP=SessionId itemid time drop=contador_last)  
outfile="&ruta.\user_data\tmp_sas_data\validacion_phase_&PHASE..csv"
replace dbms=TAB;
run;
quit;

data work.validacion_unico_reg;
	set work.validacion;
run;

proc sort data=work.validacion_unico_reg;
by SessionId contador_last;
run;
quit;

data work.validacion_unico_reg(where=(contador_last=2));
	set work.validacion_unico_reg;
	target = lag(ItemId);
run;


proc export data=work.validacion_unico_reg(drop=contador_last) 
outfile="&ruta.\user_data\tmp_sas_data\validacion_unico_registro_phase_&PHASE..csv"
replace dbms=csv;
run;
quit;

***********************************************************************;
* 8. Exportacion (Para Teams);
***********************************************************************;


proc export data=work.train_full_sin_futurazo(rename=(SessionId=user_Id
itemId=item_id))
outfile="&ruta.\user_data\tmp_sas_data\train_full_sin_futurazo_phase_&PHASE..csv"
replace dbms=csv;
run;
quit;


proc export data=work.train_y_test_sin_ultimo_click(rename=(SessionId=user_Id
itemId=item_id)) 
outfile="&ruta.\user_data\tmp_sas_data\train_y_test_sin_ultimo_click_phase_&PHASE..csv"
replace dbms=csv;
run;
quit;



data work.validacion_2;
	set work.validacion(rename=(SessionId=user_Id
itemId=item_id) drop=contador_last);
run;
proc export data=validacion_2  
outfile="&ruta.\user_data\tmp_sas_data\validacion_phase_&PHASE..csv"
replace dbms=csv;
run;
quit;


data work.validacion_unico_reg_2;
	set work.validacion_unico_reg(rename=(SessionId=user_Id
itemId=item_id) drop=contador_last);
run;
proc export data=validacion_unico_reg_2
			outfile="&ruta.\user_data\tmp_sas_data\validacion_unico_registro_phase_&PHASE..csv"
replace dbms=csv;
run;
quit;


data test_qtime;
	set 
		data.test_qtime_:(rename=(query_time=time));
	Time_2 = time;
	drop time;
	rename Time_2= Time;
	drop time_id;
run;

proc export data=test_qtime
			outfile="&ruta.\user_data\tmp_sas_data\tiempos_qtime_&PHASE..csv"
replace dbms=csv;
run;
quit;














*PART3. EXPORT CLICKS FOR MODELS;


data work.all_click;
	set data.train_click_: data.test_click_:;
	drop time_id;
run;


data work.all_test;
	set data.test_click_:;
	phase = mod(user_id, 11);
run;


proc sql;
	create table work.all_click_test as
	select *
	from work.all_click 
	where user_id in (select distinct user_id from work.all_test );
quit;

proc sort data=work.all_click_test nodupkey;
by user_id descending time item_id ;
run;
quit;


%MACRO PEGA_VARIABLE;


%DO cont_phase = 0 %TO 9;

	proc sort data=data.test_click_&cont_phase. out=work.test_click_&cont_phase.;
	by user_id descending time item_id;
	run;
	quit;

	data work.all_click_test;
	merge work.all_click_test work.test_click_&cont_phase.(in=T1);
	by user_id descending time item_id;
	if T1 then phase=&cont_phase.;
	run;
%END;

%MEND;

%PEGA_VARIABLE;


* Quitamos futurazos;
data work.qtimes;
	set data.test_qtime_:;
	drop time_id;
run;

proc sort data=work.qtimes;
by user_id descending query_time;
run;
quit;

data work.all_click_test;
merge work.all_click_test work.qtimes ;
by user_id;
run;


data work.all_click_sin_futurazo;
	set work.all_click_test;
	if time<query_time;
run;

proc sort data=work.all_click_sin_futurazo;
by user_id descending time;
run;
quit;



%MACRO ANADE_TODOS;

%DO phase=0 %TO 9;
	data work.anade_todos_&phase.;
		set work.all_click_sin_futurazo;
		by user_id;
		if phase = . and mod(user_id,11)=&phase.;
	run;


	proc export data=work.anade_todos_&phase.(keep=user_id item_id time) outfile="&ruta.\user_data\tmp_sas_data\anadimos_click_de_otras_fases_&phase..csv" replace;
	PUTNAMES=no;
	run;
	quit;
%END;
%MEND;

%ANADE_TODOS;

data DATA.TABLA_PARA_SESSION;
	set data.train_click_: data.test_click_:
		data.test_qtime_:(rename=(query_time=time));
	Time_2 = time;
	drop time;
	rename Time_2= Time;
	drop time_id;
run;

PROC SORT DATA=DATA.TABLA_PARA_SESSION NODUPKEY;
BY user_id Time item_id;
RUN;
QUIT;


PROC EXPORT DATA=DATA.TABLA_PARA_SESSION 

OUTFILE="&ruta.\user_data\tmp_sas_data\TABLA_PARA_SESSION_FINAL_KDD.CSV" REPLACE;
RUN;
QUIT;





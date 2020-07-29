OPTIONS VALIDVARNAME=V7;
DATA WORK.train_full_sin_futurazo;
LENGTH
               user_Id          $ 5
               item_id          $ 6
               Time               8
               phase_0          $ 1
               phase_1          $ 1
               phase_2          $ 1
               phase_3          $ 1
               phase_4          $ 1
               phase_5            8
               item_orig        $ 5 ;
           FORMAT
               user_Id          $CHAR5.
               item_id          $CHAR6.
               Time             BEST16.
               phase_0          $CHAR1.
               phase_1          $CHAR1.
               phase_2          $CHAR1.
               phase_3          $CHAR1.
               phase_4          $CHAR1.
               phase_5          BEST1.
               item_orig        $CHAR5. ;
           INFORMAT
               user_Id          $CHAR5.
               item_id          $CHAR6.
               Time             BEST16.
               phase_0          $CHAR1.
               phase_1          $CHAR1.
               phase_2          $CHAR1.
               phase_3          $CHAR1.
               phase_4          $CHAR1.
               phase_5          BEST1.
               item_orig        $CHAR5. ;
      INFILE "&ruta.\user_data\tmp_sas_data\TABLA_PARA_SESSION_FINAL_KDD.CSV"
          LRECL=32767
          FIRSTOBS=2
          ENCODING="UTF-8"
          DLM='2c'x
          MISSOVER
          DSD ;
            INPUT
                user_Id          : $CHAR5.
                item_id          : $CHAR6.
                Time             : ?? COMMA16.
                phase_0          : $CHAR1.
                phase_1          : $CHAR1.
                phase_2          : $CHAR1.
                phase_3          : $CHAR1.
                phase_4          : $CHAR1.
                phase_5          : ?? BEST1.
                item_orig        : $CHAR5. ;
  RUN;
/*proc append base=TRAIN_FULL_SIN_FUTURAZO data=WORK.TIEMPOS_QTIME_5;*/
/*run;*/
/**/
/*PROC SQL;*/
/*   CREATE TABLE WORK.ITEM_ID_COUNT AS */
/*   SELECT t1.item_id, */
/*          /* COUNT_of_item_id */*/
/*            (COUNT(t1.item_id)) AS COUNT_of_item_id, */
/*          /* LOG10_COUNT_ITEM_ID */*/
/*            (log10((COUNT(t1.item_id)))) AS LOG10_COUNT_ITEM_ID, */
/*          /* item_id_str */*/
/*            (strip(t1.item_id)) AS item_id_str*/
/*      FROM WORK.TRAIN_FULL_SIN_FUTURAZO t1*/
/*      GROUP BY t1.item_id,*/
/*               (CALCULATED item_id_str)*/
/*      ORDER BY COUNT_of_item_id DESC;*/
/*QUIT;*/
/*proc univariate data=work.ITEM_ID_COUNT;*/
/*	var COUNT_of_item_id;*/
/*	histogram;*/
/*run;*/
/**/
/*proc sgplot data=work.item_id_count;*/
/*	histogram log10_count_item_id;*/
/*run;*/
;

proc sort data=WORK.TRAIN_FULL_SIN_FUTURAZO out= in_sort;
	by user_id time;
run;

data work.train_click_dif;
	set WORK.in_sort;
	by user_id;
/*	retain time_lag1;*/
	dif_time = ifn(FIRST.user_id=1, ., dif(time));
	log_dif_time = ifn(FIRST.user_id=1, ., log10(dif(time)));
/*	time_lag1 = time;*/
run;

*Obtiene histograma de la diferencia entre tiempo con transformación logarítmica;
ODS TRACE ON;
proc sgplot data=work.train_click_dif;
  histogram log_dif_time;
  xaxis values=(-9 -8 -7 -6 -5 -4 -3) Valueshint;
  ods output SGPlot = _SGPlotData;
run;

*Se obtiene una curva suave del histograma para obtener ;
proc sgplot data=work._SGPlotData (where=(BIN_LOG_DIF_TIME____X not = .));
	pbspline x=BIN_LOG_DIF_TIME____X y=BIN_LOG_DIF_TIME____Y;
	ods output SGPlot = _SmootPlotData;
run;


ODS TRACE Off;

/*	PBSPLINE_BIN_LOG_DIF_TIME______Y	BIN_LOG_DIF_TIME____X	BIN_LOG_DIF_TIME____Y*/
/*-9.22	0.038681333	-9.22	0.0425470767*/
*Tabla auxiliar que calcula l;
data work._SGPLOTDATA_DIF1_Y;
	set work._SmootPlotData
		(rename= BIN_LOG_DIF_TIME____X=BIN_X 
		 rename=BIN_LOG_DIF_TIME____Y=BIN_Y
		 rename= PBSPLINE_BIN_LOG_DIF_TIME______X=PBSPLINE_X
		 rename= PBSPLINE_BIN_LOG_DIF_TIME______Y=PBSPLINE_Y
		 );
	l1_x = lag1(PBSPLINE_X);
	d1_y =dif1(PBSPLINE_Y);
run;

*Obtiene los máximos y mínimos locales con un peso mayor a 0.5 porciento;
data work.MAX_Y_MIN;
	set _SGPLOTDATA_DIF1_Y;
	prd_d1_y = d1_y * lag1(d1_y);
	dif_time_local_min = 10**l1__x;
	if lag1(d1_y) < 0 and d1_y > 0 then COD_dy_dx_0 = "MINIMO_LOCAL";
	if lag1(d1_y) > 0 and d1_y < 0 then COD_dy_dx_0 = "MAXIMO_LOCAL";
	if prd_d1_y < 0 and prd_d1_y not = . and PBSPLINE_Y > 0.2;
run;

proc sql ;
	select min(l1_x)
	into :lim_btw_session
	from work.MAX_Y_MIN
	where COD_dy_dx_0 = "MINIMO_LOCAL";
quit;

%put *** lim_btw_sesion = &lim_btw_session. ***;

/*proc datasets lib=work nolist;*/
/*delete _:;*/
/*run;*/

data work._TRAIN_CLICK_SESSION;
	length session_id $12;
	set TRAIN_CLICK_DIF;
	by user_id;
	retain n_session;
	if first.user_id then n_session = 1; 
	else if log_dif_time >= &lim_btw_session then n_session = n_session + 1;
	session_id = cats(user_id, "_",n_session);
run;

proc sort data=_TRAIN_CLICK_SESSION;
	by session_id;
run;

data work.TRAIN_CLICK_SESSION;
	set _TRAIN_CLICK_SESSION;
	by session_id;
	retain pos_item_in_ses;
	if first.session_id then pos_item_in_ses = 1;
	else pos_item_in_ses = 1+pos_item_in_ses;
run;

data work.NEXT_ITEM (keep= item_id item_id_next);
	set TRAIN_CLICK_SESSION (rename=item_id=item_id_next);
	item_id = lag1(item_id_next);
	if dif_time ne .;
run;

proc sql;
	create table work.next_item_count as
	select item_id, item_id_next, count(*) as count_item_id_next
	from work.NEXT_ITEM
	group by item_id, item_id_next
	;
run;

proc sql;
	create table work.item_count as
	select item_id, count(*) as count_item_id
	from work.NEXT_ITEM
	group by item_id
	;
run;

proc sql;
	create table work.prob_next_tem as
	select t1.item_id,
		t1.item_id_next, 
		t1.count_item_id_next, 
		t2.count_item_id, 
		t1.count_item_id_next/t2.count_item_id as p_next
	from work.next_item_count t1
		inner join work.item_count t2 on (t1.item_id = t2.item_id)
	;
quit;


proc export data=work.TRAIN_CLICK_SESSION outfile="&ruta.\user_data\tmp_sas_data\20200605_TABLA_FINAL_KDD_CON_SESSION.csv"
replace;
run;
quit;
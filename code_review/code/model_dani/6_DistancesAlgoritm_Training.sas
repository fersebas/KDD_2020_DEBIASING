%INCLUDE "&path.\code\model_dani\3_RadiusAlgorithm_Training.sas";

%global tablaTrain;
%let tablaTrain=kdd2020.V_Underexpose_all_click_&parametroHistorial;
%global tablaTest;
%let tablaTest=kdd2020.V_Underexpose_test_click_&parametroHistorial;
%global tablaAll;
%let tablaAll=kdd2020.V_Underexpose_all_click_&parametroHistorial;
%global paraBusquedaPorFasesItem;
%let paraBusquedaPorFasesItem=kdd2020.Train_full_sin_futurazo;
%global paraBusquedaPorFasesUser;
%let paraBusquedaPorFasesUser=kdd2020.Validacion_unico_registro;

%macro incorporaRecomendacionesPython
(ficheroEntradaPython=,
numeroRecomendaciones=);

  data work.resultadoPython;
    infile "&path.\user_data\tmp_model_dani\&ficheroEntradaPython..txt" dlm=",";
    input item_id item_id_vecino distancia;
  run;

  data work.resultadoPython;
    set work.resultadoPython;
    if distancia=. then distancia=2;
    if mod(_n_,&numeroRecomendaciones)=1 then 
    orderPython=0;
    orderPython=orderPython+1;
    retain orderPython;
  run;

  data work.paraPythonUsers;
    set work.paraPython(keep=user_id);
    %do repite=1 %to &numeroRecomendaciones;
      output;
    %end;
  run;

  /* Este merge no lleva by */

  data work.resultadoPython;
    length user_id_item_id $50.;
    merge work.resultadoPython(drop=item_id rename=(item_id_vecino=target)) 
    work.paraPythonUsers;
    user_id_item_id=compress(user_id)||"-"||compress(target);
  run;

  /* Quitamos clicks que ya haya hecho el usuario */

  proc sql;
    create table work.resultadoPython as
    select * from work.resultadoPython
    where user_id_item_id not in
    (select user_id_item_id from work.historial_user_id_item_id);
  quit;

  /* Quitados */
  %do contadorPhases=0 %to &phase;

    /* Solo se pueden decir estos items */

    proc sql;
      create table work.itemFase&contadorPhases as
      select distinct item_id
      from &paraBusquedaPorFasesItem
      where phase_&contadorPhases=1;
    quit;

    /* Selecciono los usuarios de la fase */

    proc sql;
      create table work.resultadoPython_Fase&contadorPhases as
      select * from work.resultadoPython
      where user_id in
      (select distinct user_id from &paraBusquedaPorFasesUser
      where phase_&contadorPhases=1);
    quit;

    proc sql;
      create table work.resultadoPython_Fase&contadorPhases as
      select * from work.resultadoPython_Fase&contadorPhases
      where target in
      (select item_id from work.itemFase&contadorPhases);
    quit;

  %end;

  data work.resultadoPython;
    set
    %do contadorPhases=0 %to &phase;
      work.resultadoPython_Fase&contadorPhases  
    %end;
    ;
  run;

  /* Quitado */

  proc sort data=work.resultadoPython nodupkey;
    by user_id target orderPython distancia;
  run;
  quit;

  /* Recalculamos el contador */

  proc sort data=work.resultadoPython;
    by user_id orderPython;
  run;
  quit;

  data work.resultadoPython(drop=orderPython);
    set work.resultadoPython;
    user_id_lag=lag(user_id);
  run;

  data work.resultadoPython;
    set work.resultadoPython;
    if user_id ne user_id_lag then 
    orderPython=0;
    orderPython=orderPython+1;
    retain orderPython;
  run;

%mend incorporaRecomendacionesPython;

/* PYTHON code DistanciesAlgorithm must be previouly invoqued */
/* to generate VALIDACION_FINAL_OUT.txt */

%incorporaRecomendacionesPython(
ficheroEntradaPython=VALIDACION_FINAL_OUT,
numeroRecomendaciones=500);

data kdd2020.VALID_7MODELOS_DISTANCIAS_All95;
  set work.resultadoPython;
  item_id=target;
  contadorDistanciasALL95=orderPython;
  distanciaALL95=distancia;
  keep user_id item_id distanciaALL95 contadorDistanciasALL95;
run;

/* PYTHON code DistanciesAlgorithm must be previouly invoqued */
/* to generate VALIDACION_FINAL_TXT_OUT.txt */

%incorporaRecomendacionesPython(
ficheroEntradaPython=VALIDACION_FINAL_TXT_OUT,
numeroRecomendaciones=500);

data kdd2020.VALID_7MODELOS_DISTANCIAS_TXT95;
  set work.resultadoPython;
  item_id=target;
  contadorDistanciasTXT95=orderPython;
  distanciaTXT95=distancia;
  keep user_id item_id distanciaTXT95 contadorDistanciasTXT95;
run;

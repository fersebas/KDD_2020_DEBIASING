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

%macro construyeTablaParaBusqueda
(historial=,
longitudSecuencia=,
radio=,
radioAnterior=,
radioPosterior=,
soporte=,
timeref=,
variables=,
usaSessionId=,
numeroRecomendaciones=,
ficheroSalidaPython=
);

  /* Construcción de secuencias de train */

  /* Dado un item, mirar lo que pasa después */

  %do contadorRadioMacro=1 %to &radio;

    proc sort data=&tablaTrain
      out=work.salidaTrain;
      by user_id descending time;
    run;
    quit;

    data work.salidaTrain;
      set work.salidaTrain;
      by user_id descending time;
      if first.user_id then contador=0;
      contador=contador+1;
      retain contador;
    run;

    data work.salidaTrain(where=(contador>=%eval(&contadorRadioMacro+1)));
      set work.salidaTrain;
      by user_id descending time;
      target=item_id;
      %do contadorRadio=1 %to &contadorRadioMacro;
        item_id_posterior_&contadorRadio=lag&contadorRadio(item_id);
        session_id_posterior_&contadorRadio=lag&contadorRadio(session_id);
        time_posterior_&contadorRadio=lag&contadorRadio(time);
      %end;
      %do contadorRadio=1 %to &contadorRadioMacro;
        if contador=&contadorRadio then do;
            %do i=&contadorRadio %to &contadorRadioMacro;
              item_id_posterior_&i=.;
              session_id_posterior_&i="";
              time_posterior_&i=.;
            %end;
        end;
      %end;
    run;

    /* Ahora al revés */
    /* Dado un item, mirar lo que pasa antes */
    /* y construir la secuencia de 1 solo elemento */

    proc sort data=work.salidaTrain(drop=contador)
      out=work.salidaTrain;
      by user_id time;
    run;
    quit;

    data work.salidaTrain;
      set work.salidaTrain;
      by user_id time;
      if first.user_id then contador=0;
      contador=contador+1;
      retain contador;
    run;

    data work.salidaTrain(where=(contador>=%eval(&contadorRadioMacro+1)));
      set work.salidaTrain;
      by user_id time;
      %do contadorRadio=1 %to &contadorRadioMacro;
        item_id_anterior_&contadorRadio=lag&contadorRadio(item_id);
        session_id_anterior_&contadorRadio=lag&contadorRadio(session_id);
        time_anterior_&contadorRadio=lag&contadorRadio(time);
      %end;
      %do contadorRadio=1 %to &contadorRadioMacro;
        if contador=&contadorRadio then do;
            %do i=&contadorRadio %to &contadorRadioMacro;
              item_id_anterior_&i=.;
              session_id_anterior_&i="";
              time_anterior_&i=.;
            %end;
        end;
      %end;
    run;

    /* Targets (items) más frecuentes tras frecuencias  */

    proc sql;
      create table frecuencias_anterior_&contadorRadioMacro as
      select item_id_anterior_&contadorRadioMacro,
      target,count(*) as numero
      from work.salidaTrain
      where abs(time-time_anterior_&contadorRadioMacro)<=&timeref
      group by item_id_anterior_&contadorRadioMacro,target
      ;
    quit;

    proc sql;
      create table frecuencias_session_anterior_&contadorRadioMacro as
      select item_id_anterior_&contadorRadioMacro,
      target,count(*) as numeroConSession
      from work.salidaTrain
      where abs(time-time_anterior_&contadorRadioMacro)<=&timeref
      and session_id = session_id_anterior_&contadorRadioMacro
      group by item_id_anterior_&contadorRadioMacro,target
      ;
    quit;

    proc sql;
      create table frecuencias_anterior_&contadorRadioMacro as
      select a.*,b.numeroConSession
      from work.frecuencias_anterior_&contadorRadioMacro a
      left join
      work.frecuencias_session_anterior_&contadorRadioMacro b
      on a.item_id_anterior_&contadorRadioMacro=b.item_id_anterior_&contadorRadioMacro
      and a.target=b.target;
    quit;

    proc sql;
      create table frecuencias_posterior_&contadorRadioMacro as
      select item_id_posterior_&contadorRadioMacro,
      target,count(*) as numero
      from work.salidaTrain
      where abs(time-time_posterior_&contadorRadioMacro)<=&timeref
      group by item_id_posterior_&contadorRadioMacro,target;
    quit;

    proc sql;
      create table frecuencias_session_posterior_&contadorRadioMacro as
      select item_id_posterior_&contadorRadioMacro,
      target,count(*) as numeroConSession
      from work.salidaTrain
      where abs(time-time_posterior_&contadorRadioMacro)<=&timeref
      and session_id = session_id_posterior_&contadorRadioMacro
      group by item_id_posterior_&contadorRadioMacro,target;
    quit;

    proc sql;
      create table frecuencias_posterior_&contadorRadioMacro as
      select a.*,b.numeroConSession
      from work.frecuencias_posterior_&contadorRadioMacro a
      left join
      work.frecuencias_session_posterior_&contadorRadioMacro b
      on a.item_id_posterior_&contadorRadioMacro=b.item_id_posterior_&contadorRadioMacro
      and a.target=b.target;
    quit;

    /* Construcción de secuencias de test */

    proc sort data=&tablaTest
      out=work.salidaTest;
      by user_id time;
    run;
    quit;

    data work.salidaTest;
      set work.salidaTest;
      by user_id time;
      if first.user_id then contador=0;
      contador=contador+1;
      retain contador;
    run;

    data work.salidaTest;
      set work.salidaTest;
      by user_id time;
      %do contadorRadio=1 %to 5;
        item_id_anterior_&contadorRadio=lag&contadorRadio(item_id);
        session_id_anterior_&contadorRadio=lag&contadorRadio(session_id);
      %end;
      %do contadorRadio=1 %to 5;
        if contador=&contadorRadio then do;
            %do i=&contadorRadio %to 5;
              item_id_anterior_&i=.;
              session_id_anterior_&i=.;
            %end;
        end;
      %end;
    run;

    proc sort data=salidaTest;
      by user_id descending time;
    run;
    quit;

    /* Lo último que clickó */

    data work.centroBola(keep=user_id item_id item_id_anterior_: session_id session_id_anterior:);
      set work.salidaTest;
      by user_id descending time;
      if first.user_id;
    run;

    data work.salidaTest;
      set work.salidaTest(drop=item_id_anterior_: session_id_anterior_: contador);
    run;

    %if &usaSessionId=1 %then %do;

      data work.auxiliarTestDataset;
        set work.salidaTest;
        by user_id descending time;
        if first.user_id;
      run;

      proc sql;
        create table work.salidaTest as
        select * from work.salidaTest
        where session_id in
        (select session_id from work.auxiliarTestDataset);
      quit;

    %end;
    
    proc sort data=work.salidaTest;
      by user_id descending time;
    run;
    quit;

    data work.salidaTest(where=(contador<=&longitudSecuencia));
      set work.salidaTest;
      by user_id descending time;
      if first.user_id then contador=0;
      contador=contador+1;
      retain contador;
    run;

    /* Adjuntamos el time de la búsqueda */

    proc sort data=kdd2020.Validacion_phase
      out=work.Validacion_phase(keep=user_id time);
      by user_id time;
    run;
    quit;

    data work.Validacion_phase;
      set work.Validacion_phase;
      by user_id time;
      if last.user_id;
    run;

    data work.salidaTest;
      merge 
      work.salidaTest
      work.Validacion_phase(rename=(time=qtime));
      by user_id;
      difTime=abs(time-qtime);
    run;

    proc contents data=kdd2020.Componentes_features
    out=work.nombresComponentes(where=(index(upcase(NAME),upcase("&variables"))>0));
    run;
    quit;

    data _null_;
      set work.nombresComponentes;
      call symput('prin'||left(_n_),compress(NAME));
      call symput('numeroComponentes',compress(_n_));
    run;

    proc sql;
      create table work.anterior_&contadorRadioMacro as
      select a.user_id,b.target,b.item_id_anterior_&contadorRadioMacro,b.numero,b.numeroConSession
      from work.salidaTest a
      left join 
      work.frecuencias_anterior_&contadorRadioMacro b
      on a.item_id = b.item_id_anterior_&contadorRadioMacro;
    quit;

    /* En caso de empate, se selecciona el item más parecido */

    proc sql;
      create table work.anterior_&contadorRadioMacro as
      select 
      %do contadorComponentes=1 %to &numeroComponentes;
        b.&&prin&contadorComponentes as
        &&prin&contadorComponentes.._item,
      %end;
      a.*
      from work.anterior_&contadorRadioMacro a
      left join
      kdd2020.componentes_features b
      on a.target=b.item_id;
    quit;

    proc sql;
      create table work.anterior_&contadorRadioMacro as
      select 
      %do contadorComponentes=1 %to &numeroComponentes;
        b.&&prin&contadorComponentes as
        &&prin&contadorComponentes.._anterior,
      %end;
      a.*
      from work.anterior_&contadorRadioMacro a
      left join
      kdd2020.componentes_features b
      on a.item_id_anterior_&contadorRadioMacro=b.item_id;
    quit;

    /* Se ordena por número y distancia */
    /* Calculo distancia coseno */

    data work.anterior_&contadorRadioMacro(drop=&variables:);
      set work.anterior_&contadorRadioMacro;
      if target ne . then do;
        numerador=
        %do contadorComponentes=1 %to &numeroComponentes;
          &&prin&contadorComponentes.._item*&&prin&contadorComponentes.._anterior+
        %end;
        0;
        denominador1=sqrt(
        %do contadorComponentes=1 %to &numeroComponentes;
        ((&&prin&contadorComponentes.._item)**2)+
        %end;
        0);
        denominador2=sqrt(
        %do contadorComponentes=1 %to &numeroComponentes;
        ((&&prin&contadorComponentes.._anterior)**2)+
        %end;
        0);
        distanciaCoseno=1-(numerador/(denominador1*denominador2));
      end;
    run;

    proc sql;
      create table work.posterior_&contadorRadioMacro as
      select a.user_id,b.target,b.item_id_posterior_&contadorRadioMacro,b.numero,b.numeroConSession
      from work.salidaTest a
      left join 
      work.frecuencias_posterior_&contadorRadioMacro b
      on a.item_id = b.item_id_posterior_&contadorRadioMacro;
    quit;

    proc sql;
      create table work.posterior_&contadorRadioMacro as
      select 
      %do contadorComponentes=1 %to &numeroComponentes;
        b.&&prin&contadorComponentes as
        &&prin&contadorComponentes.._item,
      %end;
      a.*
      from work.posterior_&contadorRadioMacro a
      left join
      kdd2020.componentes_features b
      on a.target=b.item_id;
    quit;

    proc sql;
      create table work.posterior_&contadorRadioMacro as
      select 
      %do contadorComponentes=1 %to &numeroComponentes;
        b.&&prin&contadorComponentes as
        &&prin&contadorComponentes.._posterior,
      %end;
      a.*
      from work.posterior_&contadorRadioMacro a
      left join
      kdd2020.componentes_features b
      on a.item_id_posterior_&contadorRadioMacro=b.item_id;
    quit;

    /* Se ordena por número y distancia */
    /* Calculo distancia coseno */

    data work.posterior_&contadorRadioMacro(drop=&variables:);
      set work.posterior_&contadorRadioMacro;
      if target ne . then do;
        numerador=
        %do contadorComponentes=1 %to &numeroComponentes;
          &&prin&contadorComponentes.._item*&&prin&contadorComponentes.._posterior+
        %end;
        0;
        denominador1=sqrt(
        %do contadorComponentes=1 %to &numeroComponentes;
        ((&&prin&contadorComponentes.._item)**2)+
        %end;
        0);
        denominador2=sqrt(
        %do contadorComponentes=1 %to &numeroComponentes;
        ((&&prin&contadorComponentes.._posterior)**2)+
        %end;
        0);
        distanciaCoseno=1-(numerador/(denominador1*denominador2));
      end;
    run;

  %end;

  /* Se junta lo anterior y lo posterior */

  data work.anterior_y_posterior;
    set 
    %do contadorRadioAnterior=1 %to &radioAnterior;
      work.anterior_&contadorRadioAnterior
    %end;
    %do contadorRadioPosterior=1 %to &radioPosterior;
      work.posterior_&contadorRadioPosterior
    %end;
    ;
  run;

  proc sql;
    create table work.anterior_y_posterior
    as select user_id,target,sum(numero) as numero,
    sum(numeroConSession) as numeroConSession,
    mean(distanciaCoseno) as distanciaCoseno
    from work.anterior_y_posterior
    group by user_id,target;
  quit;

  data work.anterior_y_posterior;
    set work.anterior_y_posterior;
    if numeroConSession=. then numeroConSession=0;
  run;

  /* Ahora se quitan clicks que ya haya tenido */
  /* el usuario en el pasado */

  data work.anterior_y_posterior;
    length user_id_item_id $50.;
    set work.anterior_y_posterior;
    user_id_item_id=compress(user_id)||"-"||compress(target);
  run;

  data work.historial_user_id_item_id;
    length user_id_item_id $50.;
    set &tablaAll;
    user_id_item_id=compress(user_id)||"-"||compress(item_id);
  run;

  proc sql;
    create table work.anterior_y_posterior as
    select * from work.anterior_y_posterior
    where user_id_item_id not in
    (select user_id_item_id from work.historial_user_id_item_id);
  quit;

  /* Solo se permiten clicks ya hechos en esa misma fase */
    
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
      create table work.anterior_y_posterior_Fase&contadorPhases as
      select * from work.anterior_y_posterior
      where user_id in
      (select distinct user_id from &paraBusquedaPorFasesUser
      where phase_&contadorPhases=1);
    quit;

    /* Selección de items con soporte */

    proc sql;
      create table work.anterior_y_posterior_Fase&contadorPhases as
      select * from work.anterior_y_posterior_Fase&contadorPhases
      where target in
      (select item_id from work.itemFase&contadorPhases);
    quit;

  %end;

  data work.anterior_y_posterior;
    set
    %do contadorPhases=0 %to &phase;
      work.anterior_y_posterior_Fase&contadorPhases  
    %end;
    ;
  run;

  data work.anterior_y_posterior;
    set
    %do contadorPhases=0 %to &phase;
      work.anterior_y_posterior_Fase&contadorPhases  
    %end;
    ;
  run;

  proc sort data=work.anterior_y_posterior nodupkey;
    by user_id target 
    numero 
    numeroConSession
    distanciaCoseno;
  run;
  quit;
  
  /* Quitados */

  data work.anterior_y_posterior;
    set work.anterior_y_posterior;
    if distanciaCoseno=. then
    distanciaCoseno=2;
  run;

  /* Se ordena por número y se toman los más recomendados */

  proc sort data=work.anterior_y_posterior(where=(numero>=&soporte));
    by user_id 
       descending numero 
       descending numeroConSession
       distanciaCoseno;
  run;
  quit;

  data work.anterior_y_posterior(where=(contador<=&numeroRecomendaciones));
    set work.anterior_y_posterior;
    by user_id descending numero descending numeroConSession distanciaCoseno;
    if first.user_id then contador=0;
    contador=contador+1;
    retain contador;
  run;

  /* Recuperamos usuarios que pueden haber sido eliminados */

  proc sql;
    create table work.usuariosEliminados as
    select user_id,item_id as target from work.centroBola
    where user_id not in
    (select user_id from work.anterior_y_posterior);
  quit;

  data work.anterior_y_posterior;
    set work.anterior_y_posterior work.usuariosEliminados;
  run;

  proc sort data=work.anterior_y_posterior nodupkey;
    by user_id contador;
  run;
  quit;

  /* Definición de PESO */

  DATA WORK.ANTERIOR_Y_POSTERIOR;
    SET WORK.ANTERIOR_Y_POSTERIOR;
    PESO=sum(NUMERO,NUMEROCONSESSION,(2-DISTANCIACOSENO),0);
  RUN;

  proc sort data=WORK.ANTERIOR_Y_POSTERIOR;
    by user_id descending PESO;
  run;
  quit;

  data work.anterior_y_posterior(where=(contador<=&numeroRecomendaciones));
    set work.anterior_y_posterior(drop=contador);
    by user_id descending PESO;
    if first.user_id then contador=0;
    contador=contador+1;
    retain contador;
  run;

  /**********************************************/
  /* Del centro de la bola, también sacamos     */
  /* items con características parecidas        */
  /* Le podemos dar peso (número) = 0 para que  */
  /* simplmente sirva para rellenar en lugar de */
  /* lo más clickado o bien peso muy alto, para */
  /* que prime sobre cualquier cosa recomendada */
  /* De esta forma, nos traeremos cosas         */
  /* parecidas a lo clickado y no habrá         */
  /* necesidad de recurrir a los clicks más     */
  /* habituales. La búsqueda se hace en Python  */
  /**********************************************/

  data work.paraPython(keep=orden user_id item_id_auxiliar rename=(item_id_auxiliar=item_id));
    set work.centroBola;
    item_id_auxiliar=item_id;orden=1;output;
    %do contador=1 %to 5;
      /*if session_id = session_id_anterior_&contador then do;*/
        orden=&contador+1;
        item_id_auxiliar=item_id_anterior_&contador;
        output;
      /*end;*/
    %end;
  run;

  proc sql;
    create table work.paraPython as
    select 
    %do contadorComponentes=1 %to &numeroComponentes;
      b.&&prin&contadorComponentes,
    %end;
    a.*
    from work.paraPython a
    left join
    kdd2020.componentes_features b
    on a.item_id=b.item_id;
  quit;

  proc sort data=work.paraPython;
    by user_id orden;
  run;
  quit;

  data work.paraPython;
    set work.paraPython;
    by user_id orden;
    if first.user_id then encontre=0;
    if &prin1=. then do;
    end;
    else do;
      encontre=1;
    end;
  run;

  proc sort data=work.paraPython;
    by user_id descending encontre orden;
  run;
  quit;

  data work.paraPython;
    set work.paraPython;
    by user_id descending encontre orden;
    if first.user_id;
  run;

  data work.paraPython;
    set work.paraPython;
    if &prin1=. then do;
      %do contadorComponentes=1 %to &numeroComponentes;
        &&prin&contadorComponentes=0;
      %end;
    end;
    else do;
      output;
    end;
  run;

  /*******************/
  /* FIN CENTRO BOLA */
  /*******************/

  data _null_;
    file "&path.\user_data\tmp_model_dani\&ficheroSalidaPython._&variables..txt" dlm=",";
    set work.paraPython;
    put item_id 
    %do contadorComponentes=1 %to &numeroComponentes;
      &&prin&contadorComponentes
    %end;
    ; 
  run;

  data _null_;
    set kdd2020.Componentes_features;
    file "&path.\user_data\tmp_model_dani\Underexpose_item_feat_prin_all_train_&variables..txt" dlm=",";
    put item_id
    %do contadorComponentes=1 %to &numeroComponentes;
      &&prin&contadorComponentes
    %end;
    ;
  run;

%mend construyeTablaParaBusqueda;

%construyeTablaParaBusqueda
(historial=&parametroHistorial,
longitudSecuencia=2,
radio=7,
radioAnterior=7,
radioPosterior=7,
soporte=1,
timeref=0.001,
variables=ALL,
usaSessionId=1,
numeroRecomendaciones=500,
ficheroSalidaPython=VALIDACION_FINAL);

data kdd2020.VALID_7MODELOS_ALGDANI_All95;
  set work.anterior_y_posterior;
  item_id=target;
  contadorDaniAll95=contador;
  pesoDaniAll95=PESO;
  keep user_id item_id pesoDaniAll95 contadorDaniAll95;
run;


%construyeTablaParaBusqueda
(historial=&parametroHistorial,
longitudSecuencia=3,
radio=2,
radioAnterior=2,
radioPosterior=2,
soporte=1,
timeref=0.00001,
variables=TXT,
usaSessionId=1,
numeroRecomendaciones=500,
ficheroSalidaPython=VALIDACION_FINAL_TXT);

data kdd2020.VALID_7MODELOS_BESTDANI_All95;
  set work.anterior_y_posterior;
  item_id=target;
  contadorBestDaniAll95=contador;
  pesoBestDaniAll95=PESO;
  keep user_id item_id pesoBestDaniAll95 contadorBestDaniAll95;
run;


/* Invoque PYTHON code: DistanciesAlgorithm with VALIDACION_FINAL_ALL.txt */

/* Invoque PYTHON code: DistanciesAlgorithm with VALIDACION_FINAL_TXT.txt */

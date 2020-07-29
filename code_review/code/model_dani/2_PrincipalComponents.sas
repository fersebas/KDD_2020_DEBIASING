/* PCA generations associated to features */

%macro generaComponentes(
variables=,
prefijoComponentes=,
tablaSalida=
);

  /*****************************************/
  /*****************************************/
  /*****************************************/
  /* Clusters basados en textos e imágenes */
  /*****************************************/
  /*****************************************/
  /*****************************************/

  proc princomp data=kdd2020.Underexpose_item_feat
    outstat=work.estadisticas(where=(_TYPE_="EIGENVAL")) noprint;
    var &variables;
  run;
  quit;

  proc transpose data=work.estadisticas(keep=&variables)
                 out=work.estadisticas_T;
  run;
  quit;

  data work.estadisticas_T;
    set work.estadisticas_T;
    retain acumulado 0;
    acumulado=COl1+acumulado;
  run;

  data _null_;
    set work.estadisticas_T;
    call symput('numeroObservaciones',compress(_n_));
  run;

  data work.estadisticas_T;
    set work.estadisticas_T;
    acumulado=acumulado/&numeroObservaciones;
  run;

  data _null_;
    set work.estadisticas_T;
    if acumulado>=0.95 then do;
      call symput('numeroComponentes',compress(_n_));
      stop;
    end;
  run;

  proc princomp data=kdd2020.Underexpose_item_feat
    out=work.componentesPrincipales(keep=item_id prin:) n=&numeroComponentes noprint;
    var &variables;
  run;
  quit;

  data &tablaSalida;
    set work.componentesPrincipales;
    rename
    %do contadorComponentes=1 %to &numeroComponentes;
      prin&contadorComponentes
      =&prefijoComponentes._&contadorComponentes
    %end;
    ;
  run;

  proc sort data=&tablaSalida;
    by item_id;
  run;
  quit;

%mend generaComponentes;

%generaComponentes(
variables=txt_vec:,
prefijoComponentes=txt,
tablaSalida=work.componentesTexto
);

%generaComponentes(
variables=img_vec:,
prefijoComponentes=img,
tablaSalida=work.componentesImagen
);

%generaComponentes(
variables=txt_vec: img_vec:,
prefijoComponentes=all,
tablaSalida=work.componentesAll
);

data kdd2020.componentes_features;
  merge
  work.componentesTexto 
  work.componentesImagen
  work.componentesAll;
  by item_id;
run;



%macro generaComponentes90(
variables=,
prefijoComponentes=,
tablaSalida=
);

  /*****************************************/
  /*****************************************/
  /*****************************************/
  /* Clusters basados en textos e imágenes */
  /*****************************************/
  /*****************************************/
  /*****************************************/

  proc princomp data=kdd2020.Underexpose_item_feat
    outstat=work.estadisticas(where=(_TYPE_="EIGENVAL")) noprint;
    var &variables;
  run;
  quit;

  proc transpose data=work.estadisticas(keep=&variables)
                 out=work.estadisticas_T;
  run;
  quit;

  data work.estadisticas_T;
    set work.estadisticas_T;
    retain acumulado 0;
    acumulado=COl1+acumulado;
  run;

  data _null_;
    set work.estadisticas_T;
    call symput('numeroObservaciones',compress(_n_));
  run;

  data work.estadisticas_T;
    set work.estadisticas_T;
    acumulado=acumulado/&numeroObservaciones;
  run;

  data _null_;
    set work.estadisticas_T;
    if acumulado>=0.90 then do;
      call symput('numeroComponentes',compress(_n_));
      stop;
    end;
  run;

  proc princomp data=kdd2020.Underexpose_item_feat
    out=work.componentesPrincipales(keep=item_id prin:) n=&numeroComponentes noprint;
    var &variables;
  run;
  quit;

  data &tablaSalida;
    set work.componentesPrincipales;
    rename
    %do contadorComponentes=1 %to &numeroComponentes;
      prin&contadorComponentes
      =&prefijoComponentes._&contadorComponentes
    %end;
    ;
  run;

  proc sort data=&tablaSalida;
    by item_id;
  run;
  quit;

%mend generaComponentes90;


%generaComponentes90(
variables=txt_vec: img_vec:,
prefijoComponentes=all,
tablaSalida=work.ver
);

proc export data=work.ver outfile="&path./user_data/pca_for_baseline.csv" dbms=csv replace;
putnames=No;
run;
quit;


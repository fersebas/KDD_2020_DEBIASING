/* Table for boosting */

proc sort data=kdd2020.TEST_7MODELOS_BESTDANI_All95 
  out=WORK.TEST_7MODELOS_BESTDANI_All95 nodupkey;
  by user_id item_id;
run;
quit;
proc sort data=kdd2020.TEST_7MODELOS_ALGDANI_All95 
  out=work.TEST_7MODELOS_ALGDANI_All95 nodupkey;
  by user_id item_id;
run;
quit;
proc sort data=kdd2020.TEST_7MODELOS_DISTANCIAS_All95 nodupkey
  out=work.TEST_7MODELOS_DISTANCIAS_All95;
  by user_id item_id;
run;
quit;
proc sort data=kdd2020.TEST_7MODELOS_DISTANCIAS_TXT95
  out=TEST_7MODELOS_DISTANCIAS_TXT95 nodupkey;
  by user_id item_id;
run;
quit;
proc sort data=kdd2020.VALID_7MODELOS_BESTDANI_All95 
  out=WORK.VALID_7MODELOS_BESTDANI_All95 nodupkey;
  by user_id item_id;
run;
quit;
proc sort data=kdd2020.VALID_7MODELOS_ALGDANI_All95 
  out=work.VALID_7MODELOS_ALGDANI_All95 nodupkey;
  by user_id item_id;
run;
quit;
proc sort data=kdd2020.VALID_7MODELOS_DISTANCIAS_All95 nodupkey
  out=work.VALID_7MODELOS_DISTANCIAS_All95;
  by user_id item_id;
run;
quit;
proc sort data=kdd2020.VALID_7MODELOS_DISTANCIAS_TXT95
  out=VALID_7MODELOS_DISTANCIAS_TXT95 nodupkey;
  by user_id item_id;
run;
quit;

/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      06JUN20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.user_CF_Score_500    ;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path.\user_data\tablas_boosting\user_CF_Score_500.csv" delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=2 ;
   informat user_id best32. ;
   informat item_id best32. ;
   informat userCFSim best32. ;
   informat contadorFinalUserCF best32. ;
   format user_id best12. ;
   format item_id best12. ;
   format userCFSim best12. ;
   format contadorFinalUserCF best12. ;
input
            user_id
            item_id
            userCFSim
            contadorFinalUserCF
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

proc sort data=kdd2020.user_CF_Score_500 nodupkey;
by user_id item_id;
run;
quit;

/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      06JUN20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.user_CF_Train_500    ;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path.\user_data\tablas_boosting\user_CF_Train_500.csv" delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=2 ;
   informat user_id best32. ;
   informat item_id best32. ;
   informat userCFSim best32. ;
   informat contadorFinalUserCF best32. ;
   format user_id best12. ;
   format item_id best12. ;
   format userCFSim best12. ;
   format contadorFinalUserCF best12. ;
input
            user_id
            item_id
            userCFSim
            contadorFinalUserCF
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

proc sort data=kdd2020.user_CF_Train_500 nodupkey;
by user_id item_id;
run;
quit;

/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      06JUN20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.VMSKNN_Score_500    ;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path.\user_data\tablas_boosting\VMSKNN_Score_500.csv" delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=2 ;
   informat user_id best32. ;
   informat item_id best32. ;
   informat sim_VMSKNN best32. ;
   informat contadorFinalVMSKNN_Sim best32. ;
   format user_id best12. ;
   format item_id best12. ;
   format sim_VMSKNN best12. ;
   format contadorFinalVMSKNN_Sim best12. ;
input
            user_id
            item_id
            sim_VMSKNN
            contadorFinalVMSKNN_Sim
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

proc sort data=kdd2020.VMSKNN_Score_500 nodupkey;
by user_id item_id;
run;
quit;

/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      06JUN20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.VMSKNN_Train_500    ;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path.\user_data\tablas_boosting\VMSKNN_Train_500.csv" delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=2 ;
   informat user_id best32. ;
   informat item_id best32. ;
   informat sim_VMSKNN best32. ;
   informat contadorFinalVMSKNN_Sim best32. ;
   format user_id best12. ;
   format item_id best12. ;
   format sim_VMSKNN best12. ;
   format contadorFinalVMSKNN_Sim best12. ;
input
            user_id
            item_id
            sim_VMSKNN
            contadorFinalVMSKNN_Sim
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

proc sort data=kdd2020.VMSKNN_Train_500 nodupkey;
by user_id item_id;
run;
quit;

/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      06JUN20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.paraBoostingFer_TEST_500    ;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path.\user_data\tablas_boosting\paraBoostingFer_TEST_500.csv" delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=2 ;
   informat user_id best32. ;
   informat item_id best32. ;
   informat peso_baseline best32. ;
   informat cij best32. ;
   informat wij best32. ;
   informat rank best32. ;
   informat contadorFinalFer best32. ;
   format user_id best12. ;
   format item_id best12. ;
   format peso_baseline best12. ;
   format cij best12. ;
   format wij best12. ;
   format rank best12. ;
   format contadorFinalFer best12. ;
input
            user_id
            item_id
            peso_baseline
            cij
            wij
            rank
            contadorFinalFer
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

proc sort data=kdd2020.paraBoostingFer_TEST_500 nodupkey;
by user_id item_id;
run;
quit;

/**********************************************************************
*   PRODUCT:   SAS
*   VERSION:   9.4
*   CREATOR:   External File Interface
*   DATE:      06JUN20
*   DESC:      Generated SAS Datastep Code
*   TEMPLATE SOURCE:  (None Specified.)
***********************************************************************/
data kdd2020.paraBoostingFer_TRAIN_500    ;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "&path.\user_data\tablas_boosting\paraBoostingFer_TRAIN_500.csv" delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=2 ;
   informat user_id best32. ;
   informat item_id best32. ;
   informat peso_baseline best32. ;
   informat cij best32. ;
   informat wij best32. ;
   informat rank best32. ;
   informat contadorFinalFer best32. ;
   format user_id best12. ;
   format item_id best12. ;
   format peso_baseline best12. ;
   format cij best12. ;
   format wij best12. ;
   format rank best12. ;
   format contadorFinalFer best12. ;
input
            user_id
            item_id
            peso_baseline
            cij
            wij
            rank
            contadorFinalFer
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

proc sort data=kdd2020.paraBoostingFer_TRAIN_500 nodupkey;
by user_id item_id;
run;
quit;

/* Generación TABLÓN TRAIN */

data kdd2020.TRAIN_7MODELOS_500;
  merge
  kdd2020.Paraboostingfer_train_500(where=(contadorFinalFer<=500))
  VALID_7MODELOS_ALGDANI_All95(where=(contadorDaniAll95<=500))
  VALID_7MODELOS_BESTDANI_All95(where=(contadorBestDaniAll95<=500))
  VALID_7MODELOS_DISTANCIAS_All95(where=(contadorDistanciasAll95<=500))
  VALID_7MODELOS_DISTANCIAS_TXT95(where=(contadorDistanciasTXT95<=500))
  kdd2020.Vmsknn_train_500(where=(contadorFinalVMSKNN_Sim<=500))
  kdd2020.User_cf_train_500(where=(contadorFinalUserCF<=500));
  by user_id item_id;
run;

proc sort data=kdd2020.Tabla_validacion_phase9;
  by user_id item_id;
run;
quit;

data kdd2020.TRAIN_7MODELOS_500;
merge 
  kdd2020.TRAIN_7MODELOS_500(in=A) 
  kdd2020.Tabla_validacion_phase9(in=B);
  by user_id item_id;
  IF B then target=1;
  else target=0;
  IF A;
run;

data kdd2020.SCORE_7MODELOS_500;
  merge
  kdd2020.Paraboostingfer_test_500(where=(contadorFinalFer<=500))
  TEST_7MODELOS_ALGDANI_All95(where=(contadorDaniAll95<=500))
  TEST_7MODELOS_BESTDANI_All95(where=(contadorBestDaniAll95<=500))
  TEST_7MODELOS_DISTANCIAS_All95(where=(contadorDistanciasAll95<=500))
  TEST_7MODELOS_DISTANCIAS_TXT95(where=(contadorDistanciasTXT95<=500))
  kdd2020.Vmsknn_score_500(where=(contadorFinalVMSKNN_Sim<=500))
  kdd2020.User_cf_score_500(where=(contadorFinalUserCF<=500));
  by user_id item_id;
run;

/* User information */

proc sort data=kdd2020.Underexpose_user_feat
out=work.Underexpose_user_feat nodupkey;
by user_id;
run;
quit;

proc sql;
  create table
  kdd2020.TRAIN_7MODELOS_500
  as select a.*,b.user_age_level,b.user_gender,b.user_city_level
  from
  kdd2020.TRAIN_7MODELOS_500 a
  left join
  work.Underexpose_user_feat b
  on a.user_id=b.user_id;
quit;

proc sql;
  create table
  kdd2020.SCORE_7MODELOS_500
  as select a.*,b.user_age_level,b.user_gender,b.user_city_level
  from
  kdd2020.SCORE_7MODELOS_500 a
  left join
  work.Underexpose_user_feat b
  on a.user_id=b.user_id;
quit;

data kdd2020.TRAIN_7MODELOS_500;
  set kdd2020.TRAIN_7MODELOS_500;
  drop time time_id;
run;

/* TIMES */

proc sort data=kdd2020.Underexpose_all_click_0_9
out=work.Underexpose_all_click_0_9;
  by user_id time;
run;
quit;

proc sort data=kdd2020.Underexpose_test_qtime_0_9
out=work.Underexpose_test_qtime_0_9;
  by user_id time;
run;
quit;

data work.todo_0_9;
  set work.Underexpose_all_click_0_9
      work.Underexpose_test_qtime_0_9;
  by user_id time;
run;

data work.todo_0_9;
  set work.todo_0_9;
  lag_time=lag(time);
run;

data work.todo_0_9;
  set work.todo_0_9;
  by user_id time;
  if first.user_id then lag_time=.;
run;

data work.todo_0_9;
  set work.todo_0_9;
  diff_time_anterior=time-lag_time;
run;

proc sort data=work.todo_0_9;
  by user_id descending time;
run;
quit;

data work.todo_0_9;
  set work.todo_0_9;
  f_time=lag(time);
run;

data work.todo_0_9;
  set work.todo_0_9;
  by user_id descending time;
  if first.user_id then f_time=.;
run;

data work.todo_0_9;
  set work.todo_0_9;
  diff_time_posterior=time-f_time;
run;

data work.todo_0_9_2(where=(contadorFinal=2))
  work.todo_0_9_3(where=(contadorFinal=3));
  set work.todo_0_9;
  by user_id descending time;
  if first.user_id then contadorFinal=0;
  contadorFinal=contadorFinal+1;
  retain contadorFinal;
run;

proc sql;
  create table kdd2020.Train_7modelos_500 as
  select a.*,b.diff_time_anterior,b.diff_time_posterior,b.time from 
  kdd2020.Train_7modelos_500 a 
  left join work.todo_0_9_3 b
  on a.user_id=b.user_id;
quit;

proc sql;
  create table kdd2020.score_7modelos_500 as
  select a.*,b.diff_time_anterior,b.diff_time_posterior,b.time from 
  kdd2020.score_7modelos_500 a 
  left join work.todo_0_9_2 b
  on a.user_id=b.user_id;
quit;

data work.paraUnivariate;
  set 
  kdd2020.Underexpose_all_click_0_9(keep=user_id time)
  kdd2020.Underexpose_test_qtime_0_9(keep=user_id time);
run;

proc sort data=work.paraUnivariate nodupkey;
  by user_id time;
run;
quit;

proc univariate data=work.paraUnivariate;
  var time;
  output out=percentiles pctlpts=(0 to 100 by 10) pctlpre=percentil;
run;
quit;

data kdd2020.Train_7modelos_500(drop=time);
  set kdd2020.Train_7modelos_500;
  if time=. then timeCat=.;
  else if time<=0.9838305874 then timeCat=1;
  else if time<=0.9838937853 then timeCat=2;
  else if time<=0.9839496927 then timeCat=3;
  else if time<=0.984005383 then timeCat=4;
  else if time<=0.9840620639 then timeCat=5;
  else if time<=0.9841122883 then timeCat=6;
  else if time<=0.9841724661 then timeCat=7;
  else if time<=0.9842462135 then timeCat=8;
  else if time<=0.9843153458 then timeCat=9;
  else timeCat=10;
run;

data kdd2020.score_7modelos_500(drop=time);
  set kdd2020.score_7modelos_500;
  if time=. then timeCat=.;
  else if time<=0.9838305874 then timeCat=1;
  else if time<=0.9838937853 then timeCat=2;
  else if time<=0.9839496927 then timeCat=3;
  else if time<=0.984005383 then timeCat=4;
  else if time<=0.9840620639 then timeCat=5;
  else if time<=0.9841122883 then timeCat=6;
  else if time<=0.9841724661 then timeCat=7;
  else if time<=0.9842462135 then timeCat=8;
  else if time<=0.9843153458 then timeCat=9;
  else timeCat=10;
run;

proc freq data=kdd2020.Train_7modelos_500;
  tables target;
run;
quit;

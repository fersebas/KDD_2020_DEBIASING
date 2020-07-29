%LET ruta=F:\code_review;
%let PHASE = 9;
*******************************************;
*******************************************;

* Check that all is reproducible;
X "del /q &ruta.\user_data\tablas_boosting\*";
X "del /q &ruta.\user_data\tmp_data\*";
X "del /q &ruta.\user_data\tmp_model_dani\*";
X "del /q &ruta.\user_data\tmp_sas_data\*";


libname DATA "&ruta.\user_data\tmp_sas_data";
* Excute python code;
* create vaildation data;
X "conda activate base & cd &ruta.\code\preprocess_python & F: & python 0_debias_track_answer_validation.py";
* Execute sas code;
* IMPORT DATASETS TO SAS (FER);
%INCLUDE "&RUTA.\code\preprocess_sas\SAS_0_IMPORT_PHASES.sas"; 
* create csv (FER);
%INCLUDE "&RUTA.\code\preprocess_sas\SAS_1_CREATE_CSV.sas";
 * create csv to session_id (Joaquín);
%INCLUDE "&RUTA.\code\preprocess_sas\SAS_2_CREATE_SESSION_ID.sas";

**********************************************************************************;
%let PHASE = 9;
* Dani models;
%INCLUDE "&ruta.\code\model_dani\0_Libnames.sas";
%INCLUDE "&ruta.\code\model_dani\1_DatasetsGeneration.sas";
%INCLUDE "&ruta.\code\model_dani\2_PrincipalComponents.sas";
%INCLUDE "&ruta.\code\model_dani\3_RadiusAlgorithm_Training.sas";
%INCLUDE "&ruta.\code\model_dani\4_RadiusAlgorithm_Test.sas";

****** seguimos aqui;

X "conda activate base & cd &ruta.\code\model_dani & F: & python 5_DistanciesAlgorithm.py";

%PUT &ruta.\code\model_dani;

%PUT cd &ruta.\code\preprocess_python & F: & python 5_DistanciesAlgorithm.py;

%INCLUDE "&ruta.\code\model_dani\6_DistancesAlgoritm_Training.sas";
%INCLUDE "&ruta.\code\model_dani\7_DistancesAlgoritm_Test.sas";

X "conda activate base & cd &ruta.\code\model_python & F: & python 1_MODEL_BASELINE.py"; Explota
X "conda activate base & cd &ruta.\code\model_python & F: & python 2_MODEL_USERCF.py";
X "conda activate base & cd &ruta.\code\model_python & F: & python 3_MODELO_VMSKNN.py";

%INCLUDE "&ruta.\code\model_dani\8_tableForBoosting.sas";

X "conda activate base & cd &ruta.\code\model_boosting & F: & python 4_FINAL_MODEL_XGBOOST_LIGHTGBM_CATBOOST.py";




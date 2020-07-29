#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
import numpy as np
import catboost as cat
from catboost import Pool, cv
import lightgbm as lgb
import xgboost as xgb
from catboost import CatBoostClassifier, Pool
from sklearn.model_selection import KFold


# # Parámetros

# In[2]:


train_path = '../../user_data/tablas_boosting/'
test_path  = train_path
porcentaje_bajomuestreo = 35
features = ['peso_baseline', 'cij', 'wij', 'rank',
   'contadorFinalFer', 'contadorDaniAll95', 'pesoDaniAll95',
   'contadorBestDaniAll95', 'pesoBestDaniAll95', 'contadorDistanciasALL95',
   'distanciaALL95', 'contadorDistanciasTXT95', 'distanciaTXT95',
   'sim_VMSKNN', 'contadorFinalVMSKNN_Sim', 'userCFSim',
   'contadorFinalUserCF',  'user_age_level', 'user_gender',
   'user_city_level',  'diff_time_posterior', 'phase', 'diff_time_anterior', "timeCat"]
cat_features = ["phase","user_age_level","user_gender","user_city_level", "timeCat"]
filtro_fases = ["7","8","9"]


# # Tabla Half

# In[4]:


df_half_total = pd.DataFrame()
for c in range(9 + 1):
    # Cargamos los clicks de la fase
    click_train = pd.read_csv("../../data/underexpose_train" + '/underexpose_train_click-{}.csv'.format(c),
                              header=None, names=['user_id', 'item_id', 'time']).sort_values(["user_id","time"]) 

    click_test = pd.read_csv("../../data/underexpose_test" + '/underexpose_test_click-{}/underexpose_test_click-{}.csv'.format(c,c),
                             header=None, names=['user_id', 'item_id', 'time']).sort_values(["user_id","time"])

    click_phase = click_train.append(click_train)



    median = int(click_phase.item_id.nunique()/2)


    listado_half = click_phase["item_id"].value_counts()[-median:].index

    df_half = pd.DataFrame(listado_half, columns=["item_id"])

    df_half["half"] = 1
    df_half["phase"] = str(c)
    
    df_half_total = df_half_total.append(df_half)


# # Bajomuestreo

# In[5]:


def downsample(df, percent=10):
    np.random.seed(2020)
    data1 = df[df['target'] != 0]
    data0 = df[df['target'] == 0]
    index = np.random.randint(len(data0), size = percent * len(data1))
    lower_data0 = data0.iloc[list(index)]
    
    return(pd.concat([lower_data0, data1]))


# # Score

# In[6]:


def carga_ficheros(fname):
    answer_fname = "../../data/debias_track_answer.csv"
    submit_fname = fname
    
    answers = [{} for _ in range(10)]
    with open(answer_fname, 'r') as fin:
        for line in fin:
            line = [int(x) for x in line.split(',')]
            phase_id, user_id, item_id, item_degree = line
            assert user_id % 11 == phase_id
            # exactly one test case for each user_id
            answers[phase_id][user_id] = (item_id, item_degree)
    
    predictions = {}
    contador = 1
    with open(submit_fname, 'r') as fin:
        for line in fin:
            line = line.strip()
            if line == '':
                continue
            line = line.split(',')
            user_id = int(line[0])
            if user_id in predictions:
                print(user_id)
                print('submitted duplicate user_ids')
            item_ids = [int(i) for i in line[1:]]
#             print("num_line", contador)
#             for i in line[1:]:
#                 print(i)
            if len(item_ids) != 50:
                 print('each row need have 50 items')
            if len(set(item_ids)) != 50:
                print('each row need have 50 DISTINCT items')
            predictions[user_id] = item_ids
            contador += 1
    return answers, predictions


# the higher scores, the better performance
def evaluate_each_phase(predictions, answers):
    list_item_degress = []
    for user_id in answers:
        item_id, item_degree = answers[user_id]
        list_item_degress.append(item_degree)
    list_item_degress.sort()
    median_item_degree = list_item_degress[len(list_item_degress) // 2]

    num_cases_full = 0.0
    ndcg_50_full = 0.0
    ndcg_50_half = 0.0
    num_cases_half = 0.0
    hitrate_50_full = 0.0
    hitrate_50_half = 0.0
    for user_id in answers:
        item_id, item_degree = answers[user_id]
        rank = 0
        while rank < 50 and predictions[user_id][rank] != item_id:
            rank += 1
        num_cases_full += 1.0
        if rank < 50:
            ndcg_50_full += 1.0 / np.log2(rank + 2.0)
            hitrate_50_full += 1.0
        if item_degree <= median_item_degree:
            num_cases_half += 1.0
            if rank < 50:
                ndcg_50_half += 1.0 / np.log2(rank + 2.0)
                hitrate_50_half += 1.0
    ndcg_50_full /= num_cases_full
    hitrate_50_full /= num_cases_full
    ndcg_50_half /= num_cases_half
    hitrate_50_half /= num_cases_half
    return np.array([hitrate_50_full, ndcg_50_full,
                     hitrate_50_half, ndcg_50_half], dtype=np.float32)

def calcula_score(train_df_fases, col_pred):

    formato_kdd_train = train_df_fases.sort_values(["user_id", col_pred], ascending=[True,False])
    formato_kdd_train = formato_kdd_train.groupby("user_id", as_index=False).nth(list(range(50))).reset_index(drop=True)
    formato_kdd_train = formato_kdd_train.groupby('user_id')['item_id'].apply(lambda x: ','.join([str(i) for i in x])).str.split(',', expand=True).reset_index()

    for i in formato_kdd_train.columns:
        #get mask of NaNs
        m = formato_kdd_train[i].isnull()
        #count rows with NaNs
        l = m.sum()
        #create array with size l
        s = np.random.choice(np.random.randint(200000,6000000000000, size=(l)), size=l)
        #set NaNs values
        formato_kdd_train.loc[m, i] = s

    formato_kdd_train.to_csv("predicciones_validacion.csv", index=False, header=None)

    answers, predictions = carga_ficheros("predicciones_validacion.csv")

    scores = np.zeros(4, dtype=np.float32)
    for c in filtro_fases:
        c = int(c)
        scores += evaluate_each_phase(predictions, answers[c])

    return scores


# # Funciones Boostings

# In[7]:


def catboosting_kfoldvalidation(data, features, cat_features,it_cb=50, lr_cb=0.03, depth_cb=16):

    

        
    train_set = data.copy().reset_index(drop=True)
    
    train_label = train_set['target']
    train_set = pd.DataFrame(train_set[features])
    
    cbt_model = cat.CatBoostClassifier(iterations=it_cb, learning_rate=lr_cb,
                                   depth=depth_cb,
                                   #verbose=True,
                                   thread_count = 12,
                                   random_seed = 2020,
                                   cat_features=cat_features,
                                   eval_metric = "Logloss", 
                                   verbose = 100,
                                   min_data_in_leaf = 5000
                                   )
    #cbt_model
    kf = KFold(n_splits= 5, shuffle=True) 

    listado_modelos = []
    listado_res = []

    df_test_final = pd.DataFrame()
    
    for train_index, test_index in kf.split(train_set):     # indices de las tablas de entrenamiento y validación
        train = train_set.iloc[train_index,:]               # Define, en cada iteración, train y valid
        test = train_set.iloc[test_index,:]

        labels = train_label.iloc[train_index]              # Variable objetivo de train 
        test_labels = train_label.iloc[test_index]          # Variable objetivo de validad 


        eval_dataset = Pool(test, test_labels, 
                        cat_features=cat_features)

        cbt_model.fit(train, np.ravel(labels), use_best_model=True, 
                  plot=True,
                  eval_set=eval_dataset,
                  early_stopping_rounds=10)
    
        listado_modelos.append(cbt_model)
        pred = cbt_model.predict_proba(test)
        
        importance = dict(zip(features, cbt_model.feature_importances_))

        print(sorted(importance.items(), key=lambda x:x[1], reverse=True))
        listado_res.append([pred])
        
        df_test_final = df_test_final.append(test)

    return  listado_modelos


# # Ejecución train/valid

# In[10]:


train_df = pd.read_csv(train_path + "/train_7modelos_500.csv")


# In[11]:


train_df["phase"] = train_df["user_id"].apply(lambda x: x % 11)
train_df["user_age_level"] = train_df["user_age_level"].astype(str)
train_df["user_gender"] = train_df["user_gender"].astype(str)
train_df["user_city_level"] = train_df["user_city_level"].astype(str)
train_df["phase"] = train_df["phase"].astype(str)
train_df_orig = train_df.copy()


# In[12]:


train_df_fases =  train_df_orig[train_df_orig["phase"].isin(filtro_fases)].reset_index(drop=True)


# # catboost

# In[13]:


train_bajo_catboost = downsample(train_df, porcentaje_bajomuestreo)
listado_modelos_catboost = catboosting_kfoldvalidation(train_bajo_catboost, features, cat_features, 
                                                              it_cb=3000, lr_cb=0.03, depth_cb=6)


# In[14]:


train_df_fases["pred"] = 0
for model in listado_modelos_catboost: 
    train_df_fases["pred"] += model.predict_proba(train_df_fases[features])[:,1]    # Sumamos predicciones de los 5 modelos    
train_df_fases["pred"] /= 5   # Hacemos el promedio   
scores = calcula_score(train_df_fases, "pred")
print(scores)


# # ligtbm

# In[15]:


train_set = train_df.copy().reset_index(drop=True)

train_df_fases_lgb =  train_set[train_set["phase"].isin(filtro_fases)].reset_index(drop=True)

for f in cat_features:
    train_set[f], indexer = pd.factorize(train_set[f])
    train_df_fases_lgb[f] = indexer.get_indexer(train_df_fases_lgb[f])
    
    
train_bajo_lgb = downsample(train_set, porcentaje_bajomuestreo)


# In[16]:


params={'learning_rate': 0.01,
        'objective':'binary',
        'metric':'logloss',
        'num_leaves': 31,
        'verbose': 1,
        'bagging_fraction': 0.9,
        'feature_fraction': 0.9,
        "random_state":42,
        'max_depth': 5,
        "bagging_seed" : 42,
        "verbosity" : -1,
        "bagging_frequency" : 5,
        'lambda_l2': 0.5,
        'lambda_l1': 0.5,
        'min_child_samples': 36
       }


# In[17]:


train_label = train_bajo_lgb['target']
train_set = pd.DataFrame(train_bajo_lgb[features])

lgb_model  = lgb.LGBMClassifier(**params,n_estimators=5000)

#cbt_model\nkf = KFold(n_splits= 5, shuffle=True) \n\nlistado_modelos_lgb = []

for train_index, test_index in kf.split(train_set):     # indices de las tablas de entrenamiento y validación
    train = train_set.iloc[train_index,:]               # Define, en cada iteración, train y valid
	test = train_set.iloc[test_index,:]\n\n    labels = train_label.iloc[train_index]              # Variable objetivo de train 
    test_labels = train_label.iloc[test_index]          # Variable objetivo de validad 


    lgb_model.fit(train, labels,
	eval_set=[ (train, labels), (test, test_labels)],
	early_stopping_rounds=10,
	verbose=100,
	eval_metric='logloss')
    
	
	feat_imp = pd.Series(lgb_model.feature_importances_, index=train_set.columns)
	print(feat_imp)
	listado_modelos_lgb.append(lgb_model)


# In[18]:


train_df_fases_lgb["pred"] = 0
for model in listado_modelos_lgb: 
    train_df_fases_lgb["pred"] += model.predict_proba(train_df_fases_lgb[features])[:,1]    # Sumamos predicciones de los 5 modelos    
train_df_fases_lgb["pred"] /= 5   # Hacemos el promedio   
scores = calcula_score(train_df_fases_lgb, "pred")
print(scores)


# # xgboost

# In[19]:


train_set = train_df.copy().reset_index(drop=True)

train_df_fases_xgb =  train_set[train_set["phase"].isin(filtro_fases)].reset_index(drop=True)

for f in cat_features:
    train_set[f], indexer = pd.factorize(train_set[f])
    train_df_fases_xgb[f] = indexer.get_indexer(train_df_fases_xgb[f])
    
    
train_bajo_xgb = downsample(train_set, porcentaje_bajomuestreo)


# In[20]:


xgb_pars = {'min_child_weight': 36, 'eta': 0.01, 'colsample_bytree': 0.9, 'max_depth': 5,
            'subsample': 0.9, 'lambda': 0.5, 'nthread': -1, 'booster' : 'gbtree',  'gamma' : 0.5,
            'eval_metric': 'logloss', 'objective': 'binary:logistic', 'max_depth':6, 'seed' : 42 } 


# In[21]:



train_label = train_bajo_xgb['target']
train_set = pd.DataFrame(train_bajo_xgb[features])

#cbt_model
kf = KFold(n_splits= 5, shuffle=True) 

listado_modelos_xgb = []

for train_index, test_index in kf.split(train_set):     # indices de las tablas de entrenamiento y validación
    train = train_set.iloc[train_index,:]               # Define, en cada iteración, train y valid
    test = train_set.iloc[test_index,:]

    labels = train_label.iloc[train_index]              # Variable objetivo de train 
    test_labels = train_label.iloc[test_index]          # Variable objetivo de validad 


    dtrain = xgb.DMatrix(train, label=labels)
    dtest = xgb.DMatrix(test, label=test_labels)

    watchlist = [(dtrain, 'train'), (dtest, 'valid')]

    xgb_model = xgb.train(xgb_pars, dtrain, 3000, watchlist,  early_stopping_rounds=10,
                      maximize=False, verbose_eval=100)
    

    listado_modelos_xgb.append(xgb_model)


# In[22]:


dtrain_fases = xgb.DMatrix(train_df_fases_xgb[features])

train_df_fases_xgb["pred"] = 0
i = 0
for model in listado_modelos_xgb:
    print(i)
    train_df_fases_xgb["pred"] += model.predict(dtrain_fases)    # Sumamos predicciones de los 5 modelos    
train_df_fases_xgb["pred"] /= 5   # Hacemos el promedio   
scores = calcula_score(train_df_fases_xgb, "pred")
print(scores)


# # los 3 modelos en la tabla train

# In[23]:


tr_cat = train_df_fases[["user_id","item_id","pred","phase"]].rename(columns={"pred":"pred_cat"})


# In[24]:


tr_lgb = train_df_fases_lgb[["user_id","item_id","pred"]].rename(columns={"pred":"pred_lgb"})


# In[25]:


tr_xgb =  train_df_fases_xgb[["user_id","item_id","pred"]].rename(columns={"pred":"pred_xgb"})


# In[26]:


tr_xgb[["user_id","item_id"]].shape == tr_lgb[["user_id","item_id"]].shape == tr_cat[["user_id","item_id"]].shape


# In[27]:


tr = pd.merge(tr_cat, tr_lgb, on=["user_id","item_id"]).merge(tr_xgb, on=["user_id","item_id"])


# In[28]:


# tr["phase"] = tr["phase"].astype(str)


# In[29]:


tr = pd.merge(tr, df_half_total, how="left", on =["phase","item_id"])


# In[30]:


tr.shape


# In[31]:


tr


# In[32]:


calcula_score(tr, "pred_cat")


# In[33]:


calcula_score(tr, "pred_lgb")


# In[34]:


calcula_score(tr, "pred_xgb")


# In[35]:


tr["pred"] = (0.2*tr["pred_cat"] + 0.6*tr["pred_lgb"] + 0.2*tr["pred_xgb"])


# In[36]:


calcula_score(tr, "pred")


# In[37]:


def maximiza_ncdg_full(x=[1,1,1]):
    tr["pred"] = (x[0]*tr["pred_cat"] + x[1]*tr["pred_lgb"] + x[2]*tr["pred_xgb"])
    scores = calcula_score(tr, "pred")
    print(x)
    print(scores)
    return -round(scores[2],4)


# In[38]:


from scipy.optimize import minimize


# In[39]:


minimize(maximiza_ncdg_full, [1,1,1], method="COBYLA")


# In[40]:


tr["pred"] = (0.39385602*tr["pred_cat"] + 2.79535494*tr["pred_lgb"] + 1.00005*tr["pred_xgb"])/(0.39385602+2.79535494+1.00005)


# In[41]:


calcula_score(tr, "pred")


# In[42]:


tr["pred2"] = np.where(tr["half"]==1, tr["pred"]*1.75, tr["pred"])


# In[43]:


tr


# In[44]:


calcula_score(tr, "pred2")


# # vamos a score

# In[45]:


data_score = pd.read_csv(test_path + "/score_7modelos_500.csv")

data_score["phase"] = data_score["user_id"].apply(lambda x: x % 11)
data_score["user_age_level"] = data_score["user_age_level"].astype(str)
data_score["user_gender"] = data_score["user_gender"].astype(str)
data_score["user_city_level"] = data_score["user_city_level"].astype(str)
data_score["phase"] = data_score["phase"].astype(str)


# # catboost

# In[46]:


data_score_cat = data_score.copy()


# In[47]:


data_score_cat["pred"] = 0
for model in listado_modelos_catboost: 
    data_score_cat["pred"] += model.predict_proba(data_score_cat[features])[:,1]    # Sumamos predicciones de los 5 modelos    
data_score_cat["pred"] /= 5   # Hacemos el promedio   


# # lightgbm

# In[48]:


train_set


# In[49]:


data_score_lgb = data_score.copy()


# In[50]:


train_set = train_df.copy().reset_index(drop=True)
for f in cat_features:
    _ , indexer = pd.factorize(train_set[f])
    data_score_lgb[f] = indexer.get_indexer(data_score_lgb[f])
    


# In[51]:


data_score_lgb["pred"] = 0
for model in listado_modelos_lgb: 
    data_score_lgb["pred"] += model.predict_proba(data_score_lgb[features])[:,1]    # Sumamos predicciones de los 5 modelos    
data_score_lgb["pred"] /= 5   # Hacemos el promedio  


# # xgboost

# In[52]:


data_score_xgb = data_score.copy()


# In[53]:


train_set = train_df.copy().reset_index(drop=True)
for f in cat_features:
    _ , indexer = pd.factorize(train_set[f])
    data_score_xgb[f] = indexer.get_indexer(data_score_xgb[f])


# In[54]:


data_score_xgb_d = xgb.DMatrix(data_score_xgb[features])

data_score_xgb["pred"] = 0
i = 0
for model in listado_modelos_xgb:
    print(i)
    data_score_xgb["pred"] += model.predict(data_score_xgb_d)    # Sumamos predicciones de los 5 modelos  http://10.10.14.21:8888/notebooks/KDD_2020/datos/code_review/code/4_FINAL_MODEL_XGBOOST_LIGHTGBM_CATBOOST.ipynb#  
data_score_xgb["pred"] /= 5   # Hacemos el promedio   


# # Juntamos los 3

# In[55]:


sc_cat = data_score_cat[["user_id","item_id","pred","phase"]].rename(columns={"pred":"pred_cat"})

sc_lgb = data_score_lgb[["user_id","item_id","pred"]].rename(columns={"pred":"pred_lgb"})

sc_xgb =  data_score_xgb[["user_id","item_id","pred"]].rename(columns={"pred":"pred_xgb"})

print(sc_xgb[["user_id","item_id"]].shape == sc_lgb[["user_id","item_id"]].shape == sc_cat[["user_id","item_id"]].shape)

sc = pd.merge(sc_cat, sc_lgb, on=["user_id","item_id"]).merge(sc_xgb, on=["user_id","item_id"])


# In[56]:


sc["pred"] = (0.39385602*sc["pred_cat"] + 2.79535494*sc["pred_lgb"] + 1.00005*sc["pred_xgb"])/(0.39385602+2.79535494+1.00005)


# In[57]:


sc = pd.merge(sc, df_half_total, how="left", on =["phase","item_id"])


# In[58]:


sc["pred2"] = np.where(sc["half"]==1, sc["pred"]*1.75, sc["pred"])


# In[59]:


model_scoring = sc.sort_values(["user_id","pred2"], ascending=[True,False])     # Ordenación 
model_scoring = model_scoring.groupby("user_id", as_index=False).nth(list(range(50))).reset_index(drop=True) # Filtraos 50
subida_kdd = model_scoring.groupby('user_id')['item_id'].apply(lambda x: ','.join([str(i) for i in x])).str.split(',', expand=True).reset_index()


# In[60]:


# subida_kdd.to_csv("la_ultima_subida.csv", index=False, header=None)


# In[61]:


subida_kdd[subida_kdd["user_id"]==1]


# In[62]:


subida_kdd.to_csv("../../prediction_result/THE_LAST_ONE_11_06_2020.csv", index=False, header=None)






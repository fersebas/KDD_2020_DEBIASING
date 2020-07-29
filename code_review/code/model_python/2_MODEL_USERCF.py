#!/usr/bin/env python
# coding: utf-8

# Import libraries

# In[1]:


NUM_RECOM = 500


# In[2]:


import sys
import pandas as pd  
import numpy as np
from tqdm import tqdm  
from collections import defaultdict  
import math  
pd.set_option('display.max_rows', 500)
pd.set_option('display.max_columns', 1000)
pd.set_option('display.width', 1000)


# Función userSimilarityBest \
# usuarios similares

# In[3]:


def UserSimilarityBest(df, user_col, item_col, time_col, use_iif=True, var1=0.5, var2=0.0022, var3=0.5):
    user_item_ = df.groupby("user_id")[["item_id", "time"]].agg(set).reset_index()
    tmp = [dict(zip(i, j)) for i, j in zip(user_item_[item_col], user_item_[time_col])]
    user_item_dict = dict(zip(user_item_[user_col], tmp))

    item_eval_by_users = dict()
    for u, items in user_item_dict.items():
        for i in items.keys():
            item_eval_by_users.setdefault(i, set())
            item_eval_by_users[i].add(u)
    
    count = dict()
    user_eval_item_count = dict()
    for i, users in item_eval_by_users.items():
        for u in users:
            user_eval_item_count.setdefault(u, 0)
            user_eval_item_count[u] += 1
            count.setdefault(u, {})
            for v in users:
                count[u].setdefault(v, 0)
                if u == v:
                    continue
                if use_iif:
                    count[u][v] += 1/(1+0.5*abs(user_item_dict[u][i]-user_item_dict[v][i])/(var2))                                *1/math.log(1+len(users))
                else:
                    count[u][v] += 1/math.log(1+len(users))
    
    userSim = dict()
    for u, related_users in count.items():
        userSim.setdefault(u, {})
        for v, cuv in related_users.items():
            if u == v:
                continue
            userSim[u].setdefault(v, 0.0)
            userSim[u][v] = cuv/((user_eval_item_count[u]*user_eval_item_count[v])**var3)
    return userSim, user_item_dict


# Función recommender

# In[4]:


def UB_recommend(userSim, user_item_dict, user_id, k=500, nitems=50, var4=0.8, var5=0.0022):
    rank = dict()
    interacted_items = user_item_dict[user_id]
    for v, wuv in sorted(userSim[user_id].items(), key=lambda x: x[1], reverse=True)[0:k]:
        for i, rv in user_item_dict[v].items():
            if i in interacted_items:
                continue
            rank.setdefault(i, 0)
            rank[i] += wuv*1/(1+var4*(abs(1-rv/var5)))
    return dict(sorted(rank.items(), key=lambda x: x[1], reverse=True)[0:nitems])


# Función predict

# In[5]:



def get_predict(df, pred_col, top_fill):
    top_fill = [int(t) for t in top_fill.split(',')]
    scores = [-1*i for i in range(1, len(top_fill)+1)]
    ids = list(df['user_id'].unique())
    fill_df = pd.DataFrame(ids*len(top_fill), columns=['user_id'])
    fill_df.sort_values('user_id', inplace=True)
    fill_df['item_id'] = top_fill*len(ids)
    fill_df[pred_col] = scores*len(ids)
    df = df.append(fill_df)
    df.sort_values(pred_col, ascending=False, inplace=True)
    df = df.drop_duplicates(subset=['user_id', 'item_id'], keep='first')
    df['rank'] = df.groupby('user_id')[pred_col].rank(method='first', ascending=False)
    df = df[df['rank'] <= 50]
    df = df.groupby('user_id')['item_id'].apply(lambda x: ','.join([str(i) for i in x])).str.split(',',
                                                                                                   expand=True).reset_index()
    return df


# In[6]:


def position(cols):
    real = cols[0]
    items = np.array(cols[1]).astype(int)
    pos_aux = np.where(items == real)[0]
    if len(pos_aux)==0:
        pos = 99999
    else:
        pos = int(pos_aux[0])
    return pos


# In[11]:


now_phase = 9
train_path = '../../data/underexpose_train'  
test_path = '../../data/underexpose_test' 


# In[12]:


# tabla con todos los clicks del usuario
whole_click = pd.DataFrame()
for c in range(now_phase + 1):
    # Cargamos los clicks de la fase
    click_train = pd.read_csv(train_path + '/underexpose_train_click-{}.csv'.format(c),
                              header=None, names=['user_id', 'item_id', 'time']).sort_values(["user_id","time"]) 

    click_test = pd.read_csv(test_path + '/underexpose_test_click-{}/underexpose_test_click-{}.csv'.format(c,c),
                             header=None, names=['user_id', 'item_id', 'time']).sort_values(["user_id","time"])
    
    todo = click_train.append(click_test)
    whole_click = whole_click.append(todo)


# In[13]:


whole_click = whole_click[["user_id","item_id"]].drop_duplicates().reset_index(drop=True)


# # Ejecutamos el modelo usando validación

# In[14]:


from sklearn.metrics.pairwise import cosine_similarity


# In[16]:


ncdg_total = 0
hr_total = 0


recom_vali = pd.DataFrame()
for c in range(now_phase + 1):
    print("phase "+ str(c))
    print("-----------------------------------------------------------")
    # Cargamos los clicks de la fase
    click_train = pd.read_csv(train_path + '/underexpose_train_click-{}.csv'.format(c),
                              header=None, names=['user_id', 'item_id', 'time']).sort_values(["user_id","time"]) 

    click_test_1 = pd.read_csv(test_path + '/underexpose_test_click-{}/underexpose_test_click-{}.csv'.format(c,c),
                             header=None, names=['user_id', 'item_id', 'time']).sort_values(["user_id","time"])
    
    click_test = click_test_1.sort_values(["user_id","time"]).reset_index(drop=True)

    # Extraemos validacion sobre los clicks de test
    click_valid =  click_test.groupby("user_id").tail(1)
    # Lo quitamos de test
    click_test = click_test.drop(click_valid.index).reset_index(drop=True)
    click_valid.reset_index(drop=True,inplace=True)


    # tambien quitamos el item_id de los whole_click
    rem = pd.merge(whole_click, click_valid, how="left",on=["user_id","item_id"])
    whole_click_valid = rem[rem["time"].isna()].reset_index(drop=True)
    
    # Juntamos clicks de train y test 
    all_click = click_train.append(click_test)  
    # nos aseguramos que no haya duplicados y ordenamos por time
    # de tal manera que cuando se filtre por user esté filtrado por usuario y time
    all_click = all_click.drop_duplicates(subset=['user_id','item_id','time'], keep='last')
    all_click = all_click.sort_values('time')
    # Creamos el dicionario de similitudes entre usuarios
    item_sim_list, user_item = UserSimilarityBest(all_click, 'user_id', 'item_id', 'time')
 
    recom_item_valid = []  

    # añadimos al array de recomendacios, el usuario, el item y el peso 
    for i in tqdm(click_test['user_id'].unique()): 
            rank_item = UB_recommend(item_sim_list, user_item, i, 20000, NUM_RECOM)
             # introducimos similitud de features 

#             items_similares= pd.DataFrame(rank_item, columns=["item_id","sim"])

#             arrays = pd.merge(items_similares, items_feat, how="left", on="item_id").iloc[:,2:].to_numpy()
#             similitudes = cosine_similarity(items_feat[items_feat["item_id"]==user_item[i][-1]].iloc[:,1:].to_numpy(),
#                                   arrays).flatten().tolist()


#             similitudes = [var7*x for x in similitudes]

#             items_similares["sim"] += similitudes

#             rank_item_2 = list(items_similares.sort_values("sim", ascending=False).itertuples(index=False, name=None))

            # anadimos eliminar clicks futuros que sepamos que ha hecho click el usuario
            all_interacted_items = whole_click_valid[whole_click_valid["user_id"]==i].item_id.values.tolist()
            all_interacted_items = all_interacted_items[::-1]
            for j in rank_item.items(): 
                if j[0] not in all_interacted_items:
                    recom_item_valid.append([i, j[0], j[1]]) 
            
    recom_vali = recom_vali.append(pd.DataFrame(recom_item_valid))
    recom_df = pd.DataFrame(recom_item_valid, columns=['user_id', 'item_id', 'sim']) 

    # los 50 más probables por ocurrencia
    top50_click = all_click['item_id'].value_counts().index[:50].values  
    top50_click = ','.join([str(i) for i in top50_click]) 

    # el resultado final de la fase 0  
    result = get_predict(recom_df, 'sim', top50_click)  

    # le pegamos el target y calculamos el ncdg y hitrate full  (con tener la posición que ocupa el target en la matriz 
    #de recomendaciones es suficiente)
    result = pd.merge(result, click_valid.rename(columns={"item_id":"target"}), how="left",
                                on=["user_id"])
    
#     save_result_valid.append(result)
    result["listado"] = result.iloc[:,1:51].values.tolist()
    result["position"] = result[["target","listado"]].apply(lambda row: position(row), axis=1)
    hr = len(result[result["position"]<=50])/len(result)
    ncdg = np.sum(1/np.log2(result[result["position"]<=50].position +2))/len(result)
    
#     usuarios_acertamos.append(result[result["position"]<50].user_id)

    hr_total += hr
    ncdg_total +=ncdg
    print( "HR:", hr)
    print( "NCDG:", ncdg)
    print("-----------------------------------------------------------")
    print( "Total HR:", hr_total)
    print( "Total NCDG:", ncdg_total)


# In[17]:


recom_vali.columns = ["user_id","item_id","userCFSim"]

recom_vali["contadorFinalUserCF"] = 1

recom_vali['contadorFinalUserCF'] = recom_vali.groupby('user_id')['contadorFinalUserCF'].transform(pd.Series.cumsum)

recom_vali.to_csv("../../user_data/tablas_boosting/user_CF_Train_"+str(NUM_RECOM)+".csv", index=False)


# # EJECUTAMOS CON TODOS LOS DATOS

# In[21]:


ncdg_total = 0
hr_total = 0
result_score_total = []


recom_vali = pd.DataFrame()
for c in range(now_phase + 1):
    print("phase "+ str(c))
    print("-----------------------------------------------------------")
    # Cargamos los clicks de la fase
    click_train = pd.read_csv(train_path + '/underexpose_train_click-{}.csv'.format(c),
                              header=None, names=['user_id', 'item_id', 'time']).sort_values(["user_id","time"]) 

    click_test_1 = pd.read_csv(test_path + '/underexpose_test_click-{}/underexpose_test_click-{}.csv'.format(c,c),
                             header=None, names=['user_id', 'item_id', 'time']).sort_values(["user_id","time"])
    
    click_test_2 = pd.read_csv('../../user_data/tmp_sas_data/anadimos_click_de_otras_fases_{}.csv'.format(c),
                             header=None, names=['user_id', 'item_id', 'time']).sort_values(["user_id","time"])
    

    click_test = pd.concat([click_test_1, click_test_2]).sort_values(["user_id","time"]).reset_index(drop=True)

    # Juntamos clicks de train y test 
    all_click = click_train.append(click_test)  
    # nos aseguramos que no haya duplicados y ordenamos por time
    # de tal manera que cuando se filtre por user esté filtrado por usuario y time
    all_click = all_click.drop_duplicates(subset=['user_id','item_id','time'], keep='last')
    all_click = all_click.sort_values('time')
    # Creamos el dicionario de similitudes entre usuarios
    item_sim_list, user_item = UserSimilarityBest(all_click, 'user_id', 'item_id', 'time')
 
    recom_item_valid = []  

    # añadimos al array de recomendacios, el usuario, el item y el peso 
    for i in tqdm(click_test['user_id'].unique()): 
            rank_item = UB_recommend(item_sim_list, user_item, i, 500, 50)
             # introducimos similitud de features 

#             items_similares= pd.DataFrame(rank_item, columns=["item_id","sim"])

#             arrays = pd.merge(items_similares, items_feat, how="left", on="item_id").iloc[:,2:].to_numpy()
#             similitudes = cosine_similarity(items_feat[items_feat["item_id"]==user_item[i][-1]].iloc[:,1:].to_numpy(),
#                                   arrays).flatten().tolist()


#             similitudes = [var7*x for x in similitudes]

#             items_similares["sim"] += similitudes

#             rank_item_2 = list(items_similares.sort_values("sim", ascending=False).itertuples(index=False, name=None))

            # anadimos eliminar clicks futuros que sepamos que ha hecho click el usuario
            all_interacted_items = whole_click_valid[whole_click_valid["user_id"]==i].item_id.values.tolist()
            all_interacted_items = all_interacted_items[::-1]
            for j in rank_item.items(): 
                if j[0] not in all_interacted_items:
                    recom_item_valid.append([i, j[0], j[1]]) 
            
    recom_vali = recom_vali.append(pd.DataFrame(recom_item_valid))
    recom_df = pd.DataFrame(recom_item_valid, columns=['user_id', 'item_id', 'sim']) 

    # los 50 más probables por ocurrencia
    top50_click = all_click['item_id'].value_counts().index[:50].values  
    top50_click = ','.join([str(i) for i in top50_click]) 

    # el resultado final de la fase 0  
    result = get_predict(recom_df, 'sim', top50_click)  
    result_score_total.append(result)


# In[22]:


recom_vali.columns = ["user_id","item_id","userCFSim"]

recom_vali["contadorFinalUserCF"] = 1

recom_vali['contadorFinalUserCF'] = recom_vali.groupby('user_id')['contadorFinalUserCF'].transform(pd.Series.cumsum)

recom_vali.to_csv("../../user_data/tablas_boosting/user_CF_Score_"+str(NUM_RECOM)+".csv", index=False)


# In[ ]:





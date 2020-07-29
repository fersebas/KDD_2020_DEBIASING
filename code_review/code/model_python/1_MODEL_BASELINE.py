#!/usr/bin/env python
# coding: utf-8

# In[1]:


import sys
import pandas as pd  
import numpy as np
from tqdm import tqdm  
from collections import defaultdict  
from sklearn.metrics.pairwise import cosine_similarity
import math  
pd.set_option('display.max_rows', 500)
pd.set_option('display.max_columns', 1000)
pd.set_option('display.width', 1000)


# In[2]:


now_phase = 9
train_path = '../../data/underexpose_train'  
test_path = '../../data/underexpose_test'


# In[3]:


def tablon_phase(phase, validacion=False):
    # 1. Parametros por defecto
    item_col = "item_id"
    user_col = "user_id"
    # variables por defecto
    var1 =  1.0109264417572992
    var2 = 0.9296688725091558
    var3 =  9842.763618225044
    var4 =  1.0588265403995152
    var5 = 0.2450845045546785
    var6 = 0.8008277395077197

    # 2. Cargamos los datos de la fase
    c = phase
    print("phase "+ str(c))

    # tabla de train clicks
    click_train = pd.read_csv(train_path + '/underexpose_train_click-{}.csv'.format(c),
                              header=None, names=['user_id', 'item_id', 'time']).sort_values(["user_id","time"]) 

    # tabla de test clicks
    click_test_1 = pd.read_csv(test_path + '/underexpose_test_click-{}/underexpose_test_click-{}.csv'.format(c,c),
                             header=None, names=['user_id', 'item_id', 'time']).sort_values(["user_id","time"])

    click_test = click_test_1.sort_values(["user_id","time"]).reset_index(drop=True)
    
    # tabla con todos los clicks del usuario
    whole_click = pd.DataFrame()
    for i in range(9 + 1):
        # Cargamos los clicks de la fase
        cl_train = pd.read_csv(train_path + '/underexpose_train_click-{}.csv'.format(i),
                                header=None, names=['user_id', 'item_id', 'time']).sort_values(["user_id","time"]) 

        cl_test = pd.read_csv(test_path + '/underexpose_test_click-{}/underexpose_test_click-{}.csv'.format(i,i),
                                header=None, names=['user_id', 'item_id', 'time']).sort_values(["user_id","time"])

        todo = cl_train.append(cl_test)
        whole_click = whole_click.append(todo)

        whole_click = whole_click[["user_id","item_id"]].drop_duplicates().reset_index(drop=True)
        
    # items features
    items_feat = pd.read_csv("../../user_data/pca_for_baseline.csv", header=None).rename(columns={0: "item_id"})
    faltan = set(whole_click.item_id.unique()) - set(items_feat.item_id.unique())
    faltan_df = pd.DataFrame(faltan, columns=["item_id"])
    items_feat = pd.concat([items_feat, faltan_df], axis=0).fillna(0)
    
    
    if validacion:
        # Extraemos validacion sobre los clicks de test
        click_valid =  click_test.groupby("user_id").tail(1)
        # Lo quitamos de test
        click_test = click_test.drop(click_valid.index).reset_index(drop=True)
        click_valid.reset_index(drop=True,inplace=True)

        # tambien quitamos el item_id de los whole_click
        rem = pd.merge(whole_click, click_valid, how="left",on=["user_id","item_id"])
        whole_click = rem[rem["time"].isna()].reset_index(drop=True)

         
    # unimos train y test
    all_click = click_train.append(click_test)  
    # nos aseguramos que no haya duplicados y ordenamos por time
    # de tal manera que cuando se filtre por user esté filtrado por usuario y time
    all_click = all_click.drop_duplicates(subset=['user_id','item_id','time'],keep='last')
    all_click = all_click.sort_values('time')
    
    
    # Funcion 1
    df = all_click.copy()
    user_item_ = df.groupby(user_col)[item_col].agg(list).reset_index()
    user_item_dict = dict(zip(user_item_[user_col], user_item_[item_col]))

    user_time_ = df.groupby(user_col)['time'].agg(list).reset_index() # Time Factor
    user_time_dict = dict(zip(user_time_[user_col], user_time_['time']))

    sim_item = {}  
    item_cnt = defaultdict(int)  # Number of time product

    ar_conc = []

    for user, items in tqdm(user_item_dict.items()):  
        for loc1, item in enumerate(items):  
            item_cnt[item] += 1  
            sim_item.setdefault(item, {})  
            for loc2, relate_item in enumerate(items):  
                if item == relate_item:  
                    continue  
                t1 = user_time_dict[user][loc1] 
                t2 = user_time_dict[user][loc2]
                sim_item[item].setdefault(relate_item, 0)  
                ar_conc.append( [user, item, relate_item, loc1, loc2, t1, t2, len(items)])

    sim_item_corr = sim_item.copy() 
    co_conc = []
    for i, related_items in tqdm(sim_item.items()):  
        for j, cij in related_items.items():  
            co_conc.append([i, j, item_cnt[i],  item_cnt[j] ])
    
    # 
    # Lo primero guardamos el resultado de la primera funciín que mira la concurrencia
    df_sim_item =     pd.DataFrame(ar_conc, columns=["user_id","item_id","item_similar_id","loc1","loc2","t1","t2", "num_items_similar"])

    df_co_conc = pd.DataFrame(co_conc, columns=["item_id","item_similar_id","count_item_id","count_item_similar_id"])

    df_1 = pd.merge(df_sim_item, df_co_conc, on=["item_id","item_similar_id"])


    df_1["loc1_menor_loc2"] = np.where(df_1["loc1"]-df_1["loc2"]>0, 1, 0)

    # nos aseguramos que esté ordenado por user y time (y el primero el último click)
    click_test = click_test.sort_values(["user_id","time"], ascending=[True,False])

    user_test = click_test[["user_id","item_id"]]

    # posición 0 al último click
    user_test["value"] = 1
    user_test["loc"] = user_test.groupby('user_id')["value"].apply(lambda x: x.cumsum())-1


    # Cruzamos y nos quedamos donde el click esté hecho por el usuario que estamos evaluando (test)
    df_2 = pd.merge(user_test, df_1, how="left", on=["item_id"])

    df_3 = df_2[df_2["user_id_x"] != df_2["user_id_y"]]
    
    
    # definimos las varaibles cij, wij, y rank. Esto define la primera función.

    df_3["cij"] = np.where(df_3["loc1_menor_loc2"]==1, 
    (var1*(var2**(df_3["loc1"]-df_3["loc2"]-1)) * (1 - (df_3["t1"] - df_3["t2"])*var3)/(np.log(df_3["num_items_similar"]+1))),
    (var4*(var2**(df_3["loc2"]-df_3["loc1"]-1)) * (1 - (df_3["t2"] - df_3["t1"])*var3)/(np.log(df_3["num_items_similar"]+1))))

    df_3["wij"] = df_3["cij"]/ ((df_3["count_item_id"] * df_3["count_item_similar_id"]) ** var5)


    df_3["rank"] = df_3["wij"] * (var6**df_3["loc"]) 

    check_final = df_3.groupby(["user_id_x",  "item_similar_id"])["rank"].agg("sum")
    
    df_3 = df_3.reset_index(drop=True)

    
    ult_cl_df = df_2[df_2["loc"]==0]
    ult_cl = ult_cl_df[["item_id"]].drop_duplicates()

    sim_cl = df_2[["item_similar_id"]].drop_duplicates().rename(columns={"item_similar_id":"item_id"})

    array_1 = pd.merge(ult_cl, items_feat, how="inner", on="item_id").iloc[:,1:].to_numpy()
    array_2 = pd.merge(sim_cl,items_feat, how="inner", on="item_id").iloc[:,1:].to_numpy()
    cos_sim = cosine_similarity(array_1, array_2)

    index_aux = pd.MultiIndex.from_product([ult_cl.item_id, sim_cl.item_id], names = ["item_id", "item_similar_id"])
    tabla_cos_sim = pd.DataFrame(index = index_aux).reset_index()

    tabla_cos_sim["cossim_last_click"] = cos_sim.flatten()

    tabla_cos_sim = pd.merge(ult_cl_df[["user_id_x","item_id"]].drop_duplicates(), tabla_cos_sim, on="item_id", how="left")

    #Lo unimos
    df_4 =     pd.merge(df_3, tabla_cos_sim[["user_id_x","item_similar_id","cossim_last_click"]], on=["user_id_x","item_similar_id"], how="left")

    # se divide la similitud por el nº de items_similares
    #df_3["num_rows_par_item"] = df_3.groupby(["user_id_x","item_id","item_similar_id"]).size()

    df_num_rows = df_4.groupby(["user_id_x","item_similar_id"]).size().reset_index().rename(columns={0:"num_rows_par_sim"})

    df_5 = pd.merge(df_4, df_num_rows, how="left", on=["user_id_x","item_similar_id"])

    df_5["final_rank"] = df_5["rank"] + 0.2*df_5["cossim_last_click"]/df_5["num_rows_par_sim"]

    #Eliminamos los clicks que ha hecho el usuario

    whole_click["ya_clickado"] = 1
    
    

    df = pd.merge(df_5, whole_click, how="left", left_on=["user_id_x","item_similar_id"], right_on=["user_id","item_id"])
   
    
#     click_test_df = click_test.sort_values(["user_id","time"]).groupby("user_id").tail(1)

#     click_test_df["ind_validacion"]=1

#     df = pd.merge(df, click_test_df.rename(columns={"user_id":"user_id_y",
#                                                                "item_id":"item_similar_id",
#                                                                "time" : "t2"}), how="left",
#                              on=["user_id_y","item_similar_id","t2"])
    
    df = df[df["ya_clickado"]!=1].drop(['user_id', 'item_id_y', 'ya_clickado'], axis=1)
    #df_trainvalid = df[(df["ya_clickado"]!=1) | (df["ind_validacion"]==1)]
    #df = reduce_mem_usage(df)
    
    if validacion:
        return df, click_valid
    else:
        return df


# In[4]:


def df_para_kdd(phase):
    para_lb = df_0[["user_id_x","item_similar_id","final_rank"]].groupby(["user_id_x","item_similar_id"], as_index=False).sum()
    rec = []
    for u  in tqdm(df_0.user_id_x.unique()):
        rec.append(para_lb[para_lb["user_id_x"]==u].sort_values("final_rank",ascending=False)[0:50])

    df_rec = pd.concat([x for x in rec]).reset_index(drop=True)

    recom_50 = df_rec.groupby('user_id_x')['item_similar_id'].apply(lambda x: list(x)[0:50]).reset_index()

    df_para_lb = pd.concat([recom_50[["user_id_x"]], pd.DataFrame.from_records(recom_50["item_similar_id"])], axis=1).reset_index(drop=True).fillna(0).astype(int)
    return df_para_lb


# In[5]:


# fill user to 50 items  
def get_predict(df, pred_col, top_fill):  
    top_fill = [int(t) for t in top_fill.split(',')]  
    scores = [-1 * i for i in range(1, len(top_fill) + 1)]  
    ids = list(df['user_id_x'].unique())  
    fill_df = pd.DataFrame(ids * len(top_fill), columns=['user_id_x'])  
    fill_df.sort_values('user_id_x', inplace=True)  
    fill_df['item_similar_id'] = top_fill * len(ids)  
    fill_df[pred_col] = scores * len(ids)  
    df = df.append(fill_df)  
    df.sort_values(pred_col, ascending=False, inplace=True)  
    df = df.drop_duplicates(subset=['user_id_x', 'item_similar_id'], keep='first')  
    df['rank'] = df.groupby('user_id_x')[pred_col].rank(method='first', ascending=False)  
    df = df[df['rank'] <= 50]  
    df = df.groupby('user_id_x')['item_similar_id'].apply(lambda x: ','.join([str(i) for i in x])).str.split(',', expand=True).reset_index()  
    return df  


# In[6]:


def position(cols):
    real = cols[0]
    #print(cols[1])
    items = np.array(cols[1]).astype(int)
    pos_aux = np.where(items == real)[0]
    if len(pos_aux)==0:
        pos = 99999
    else:
        pos = int(pos_aux[0])
    return pos


# # EJECUTAMOS TODAS LAS FASES  Y GUARDAMOS

# In[7]:


for c in range(now_phase + 1):
    df_score = tablon_phase(c, False)
    df_valid, _ = tablon_phase(c, True)
    
    df_score.to_csv("../../user_data/tmp_data/df_score"+str(c)+".csv", index=False)
    df_valid.to_csv("../../user_data/tmp_data/df_valid"+str(c)+".csv", index=False)
    


# In[8]:


model_fer = pd.DataFrame()
k = 500
for c in range(now_phase + 1):
    data = pd.read_csv("../../user_data/tmp_data/df_valid"+str(c)+".csv")
    data =  data[["user_id_x","item_similar_id","final_rank", "cij", "wij", "rank"]].groupby(["user_id_x","item_similar_id"], as_index=False).sum()
    data = data.sort_values(["user_id_x", "final_rank"], ascending=[True,False])
    data = data.groupby('user_id_x', as_index=False).nth(list(range(k))).reset_index(drop=True)
    data["contadorFinalFer"] = 1

    data['contadorFinalFer'] = data.groupby('user_id_x')['contadorFinalFer'].transform(pd.Series.cumsum)
    model_fer = model_fer.append(data)
model_fer = model_fer.rename(columns={"user_id_x":"user_id", "item_similar_id":"item_id", "final_rank":"peso_baseline"})

model_fer.to_csv("../../user_data/tablas_boosting/paraBoostingFer_TRAIN_"+str(k)+".csv", index=False)


# In[11]:


model_fer = pd.DataFrame()
k = 500
for c in range(now_phase + 1):
    data = pd.read_csv("../../user_data/tmp_data/df_score"+str(c)+".csv")
    data =  data[["user_id_x","item_similar_id","final_rank", "cij", "wij", "rank"]].groupby(["user_id_x","item_similar_id"], as_index=False).sum()
    data = data.sort_values(["user_id_x", "final_rank"], ascending=[True,False])
    data = data.groupby('user_id_x', as_index=False).nth(list(range(k))).reset_index(drop=True)
    data["contadorFinalFer"] = 1

    data['contadorFinalFer'] = data.groupby('user_id_x')['contadorFinalFer'].transform(pd.Series.cumsum)
    model_fer = model_fer.append(data)
model_fer = model_fer.rename(columns={"user_id_x":"user_id", "item_similar_id":"item_id", "final_rank":"peso_baseline"})

model_fer.to_csv("../../user_data/tablas_boosting/paraBoostingFer_TEST_"+str(k)+".csv", index=False)


# In[ ]:





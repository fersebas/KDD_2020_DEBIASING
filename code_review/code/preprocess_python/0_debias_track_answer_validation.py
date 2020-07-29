#! C:\Users\Fer\Anaconda3\python.exe
# coding: utf-8

# In[1]:


from __future__ import division
import pandas as pd
from collections import defaultdict
import numpy as np


# In[2]:


phase = 9
folder = '../../data'
train_path = '/underexpose_train/'  
test_path = '/underexpose_test/'  


# In[3]:



for phase_id in range(phase+1):
    print(phase_id)
    TestHist = pd.read_csv(folder + test_path + '/underexpose_test_click-%d/underexpose_test_click-%d.csv'
                           % (phase_id, phase_id),
                           header=None)
    TestHist.columns = ['user_id','item_id','time']
    TestHist = TestHist.sort_values(['user_id','time']).reset_index(drop = True)
    Test_with_answer = TestHist.drop_duplicates(subset=["user_id"], keep="last")
    Test_with_answer.to_csv(folder+"/underexpose_test_qtime_with_answer-%d.csv" % phase_id, index=False, header=False)
    TestHist = TestHist.drop(Test_with_answer.index)
    TestHist.to_csv(folder+"/underexpose_test_qtime_train-%d.csv" % phase_id, index=False, header=False)
    


# In[9]:


def _create_answer_file_for_evaluation(phase, answer_fname=folder+'/debias_track_answer.csv'):
    train = folder + train_path + '/underexpose_train_click-%d.csv'
    test = folder + test_path + '/underexpose_test_click-%d/underexpose_test_click-%d.csv'

    # underexpose_test_qtime-T.csv contains only <user_id, time>
    # underexpose_test_qtime_with_answer-T.csv contains <user_id, item_id, time>
    answer = folder + '/underexpose_test_qtime_with_answer-%d.csv'  # not released

    item_deg = defaultdict(lambda: 0)
    with open(answer_fname, 'w') as fout:
        for phase_id in range(phase+1):
            with open(train % phase_id) as fin:
                for line in fin:
                    user_id, item_id, timestamp = line.split(',')
                    user_id, item_id, timestamp = (
                        int(user_id), int(item_id), float(timestamp))
                    item_deg[item_id] += 1
            with open(test % (phase_id,phase_id)) as fin:
                for line in fin:
                    user_id, item_id, timestamp = line.split(',')
                    user_id, item_id, timestamp = (
                        int(user_id), int(item_id), float(timestamp))
                    item_deg[item_id] += 1
            with open(answer % phase_id) as fin:
                for line in fin:
                    user_id, item_id, timestamp = line.split(',')
                    user_id, item_id, timestamp = (
                        int(user_id), int(item_id), float(timestamp))
                    assert user_id % 11 == phase_id
                    print(phase_id, user_id, item_id, item_deg[item_id],
                          sep=',', file=fout)


# In[10]:


_create_answer_file_for_evaluation(phase)


# In[11]:


debias = pd.read_csv(folder + "/debias_track_answer.csv", header=None, names=["phase","user_id","item_id","item_degree"])


# In[12]:


list_by_phase = debias.groupby('phase')['item_degree'].apply(list).reset_index(name='degrees')
validacion = pd.DataFrame()
for c in range(phase+1):
    
    debias_phase = debias[debias["phase"]==c]
    list_item_degress = list_by_phase["degrees"][c]
    list_item_degress.sort()

    median_item_degree = list_item_degress[len(list_item_degress) // 2]

    debias_phase["es_half"] = np.where(debias_phase["item_degree"]<=median_item_degree, 2, 1)
    
    validacion = validacion.append(debias_phase)


# In[13]:


validacion.to_csv("../../user_data/tablas_boosting/tabla_validacion_phase_9.csv", index=False)


# In[ ]:





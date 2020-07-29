#!/usr/bin/env python
# coding: utf-8

# In[1]:


import numpy as np
from IPython.display import clear_output

def calculate_distances(row,matrix):
    distances = (row-matrix) 
    distances *= distances
    distances = np.sum(distances,axis=1)
    return distances

def calculate_distances_cos(row,matrix,norma_matrix):
    square_row = row * row
    sum_norma_row = np.sum(square_row)
    norma_row = np.sqrt(sum_norma_row)
    
    divisor = norma_row * norma_matrix
    numerador = np.sum(row * matrix,axis=1)
    
    distances = 1 - numerador / divisor
    #distances[divisor == 0] = 2
    
    return distances

def distance(matrix_a,matrix_b,N):
    """Devuelve para cada id_matrix_a los 50 id_matrix_b más próximos ordenados."""
    id_b = matrix_b[:,0].astype(np.int)
    data_b = matrix_b[:,1:]
    
    square_matrix_b = data_b * data_b
    sum_norma_matrix_b = np.sum(square_matrix_b,axis=1)
    norma_matrix_b = np.sqrt(sum_norma_matrix_b)
    
    output_id = []
    output_distance = []
    output_data = []
    cont = 0
    
    for row_a in matrix_a:
        
        clear_output(wait=True)
        print(cont,"/",matrix_a.shape[0], flush=True)
        cont += 1
        
        row_id = int(row_a[0])
        row_data = row_a[1:]
        
        distances = calculate_distances_cos(row_data,data_b,norma_matrix_b)
        # distances = calculate_distances(row_data,data_b)
        
        sorted_indexes = np.argsort(distances).tolist()[0:N]
        sorted_distances = np.sort(distances).tolist()[0:N]
        
        ref = [row_id]*N
        
        output_id.append(ref)
        index_in_b = id_b[sorted_indexes]
        output_data.append(index_in_b)
        output_distance.append(sorted_distances)
        
    output = np.array([output_id,output_data,output_distance]).reshape(3,N*matrix_a.shape[0])
        
    return output


# In[20]:


print("Cargando datos B", flush=True)
matrix_b = np.genfromtxt("..\\..\\user_data\\tmp_model_dani\\Underexpose_item_feat_prin_all_train_all.txt", delimiter=',')

print("Cargando datos A", flush=True)
matrix_a = np.genfromtxt('..\\..\\user_data\\tmp_model_dani\\VALIDACION_FINAL_all.txt', delimiter=',')


print("Calculando distancias", flush=True)
d=distance(matrix_a, matrix_b, 500)
np.savetxt('..\\..\\user_data\\tmp_model_dani\\VALIDACION_FINAL_OUT.txt', d.transpose(), delimiter=',', fmt="%d,%d,%f8")



print("Cargando datos B", flush=True)
matrix_b = np.genfromtxt("..\\..\\user_data\\tmp_model_dani\\Underexpose_item_feat_prin_all_train_TXT.txt", delimiter=',')

print("Cargando datos A", flush=True)
matrix_a = np.genfromtxt('..\\..\\user_data\\tmp_model_dani\\VALIDACION_FINAL_TXT_TXT.txt', delimiter=',')
print("Calculando distancias", flush=True)
d=distance(matrix_a,matrix_b,500)
np.savetxt('..\\..\\user_data\\tmp_model_dani\\VALIDACION_FINAL_TXT_OUT.txt', d.transpose(), delimiter=',', fmt="%d,%d,%f8")



print("Cargando datos B", flush=True)
matrix_b = np.genfromtxt("..\\..\\user_data\\tmp_model_dani\\Underexpose_item_feat_prin_all_test_ALL.txt", delimiter=',')

print("Cargando datos A", flush=True)
matrix_a = np.genfromtxt('..\\..\\user_data\\tmp_model_dani\\TEST_FINAL_ALL.txt', delimiter=',')
print("Calculando distancias", flush=True)
d=distance(matrix_a,matrix_b,500)
np.savetxt('..\\..\\user_data\\tmp_model_dani\\TEST_FINAL_OUT.txt', d.transpose(), delimiter=',', fmt="%d,%d,%f8")

print("Cargando datos B", flush=True)
matrix_b = np.genfromtxt("..\\..\\user_data\\tmp_model_dani\\Underexpose_item_feat_prin_all_test_TXT.txt", delimiter=',')

print("Cargando datos A", flush=True)
matrix_a = np.genfromtxt('..\\..\\user_data\\tmp_model_dani\TEST_FINAL_TXT_TXT.txt', delimiter=',')
print("Calculando distancias", flush=True)
d=distance(matrix_a,matrix_b,500)
np.savetxt("..\\..\\user_data\\tmp_model_dani\\TEST_FINAL_TXT_OUT.txt", d.transpose(), delimiter=',', fmt="%d,%d,%f8")


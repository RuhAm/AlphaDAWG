#!/usr/bin/env python
# coding: utf-8

# In[1]:

####
import pandas as pd
import random
import sys


from keras import models
from keras import layers
import pandas as pd
import numpy as np
from keras import regularizers
from sklearn.model_selection import KFold
import random

from sklearn.preprocessing import StandardScaler

import matplotlib.pyplot as plt


# In[2]:
import argparse

# Set up argument parser
parser = argparse.ArgumentParser(description="Keras wavelet software")
parser.add_argument('--train', type=int, help='Number of training observations')
parser.add_argument('--test', type=int, help='Number of test observations')
parser.add_argument('--alignment', type=int, help='alignment flag')

# Parse arguments
args = parser.parse_args()


# Number of train and test observations (adjust these values as needed)

train_observations = args.train

test_observations = args.test
align = args.alignment

if align == 0:
    align_val = "no_align"
elif align == 1:
    align_val = "align"
else:
    raise ValueError("Invalid value for alignment. Please provide 0 for no alignment or 1 for alignment.")



def log_odd(p) :
    return np.log10(p/(1-p))

def moving_average(x, w):
    return np.convolve(x, np.ones(w), 'valid') / w


# In[3]:




kfold = KFold(5, shuffle = True, random_state=1)

lambdas = [1e-6, 1e-5, 1e-4,1e-3,1e-2,1e-1, 1,1e1]
gammas = [0, 0.1, 0.3, 0.5, 0.7, 0.9, 1]
 


# In[6]:


C_N=pd.read_csv("../Data/Curvelets/Curvelets_neut_"+align_val+"_resized_.csv", header=None)
C_S=pd.read_csv("../Data/Curvelets/Curvelets_sweep_"+align_val+"_resized_.csv", header=None)


DF = pd.read_csv("../Data/Wavelets/W_combined_neut_"+align_val+".csv", header=None)
DF1 = pd.read_csv("../Data/Wavelets/W_combined_sweep_"+align_val+".csv", header=None)
num_rows = DF.shape[0]


# Ensure the number of observations does not exceed the available data
train_observations = min(train_observations, num_rows)
test_observations = min(test_observations, num_rows - train_observations)

# Seed for both train and test (same seed can be used)
random.seed(123)

# Randomly sample indices for training
Train = random.sample(range(num_rows), train_observations)

# Create a test set by sampling from the remaining indices
remaining_indices = [i for i in range(num_rows) if i not in Train]
Test = random.sample(remaining_indices, test_observations)

# Display the train and test indices
print("Train Indices:", Train)
print("Test Indices:", Test)

a = np.zeros(train_observations)
b = np.ones(train_observations)
y = np.concatenate([a,b])
# In[7]:


C_N


# In[11]:


C_n = C_N.iloc[Train]
C_s = C_S.iloc[Train]
dfs_C = pd.concat([C_n, C_s])
dfs_C = np.asarray(dfs_C)


# In[12]:


dfs_C = pd.concat([C_n, C_s])
dfs_C = np.asarray(dfs_C)


# In[13]:




# In[14]:


#np.shape(DF)


# In[15]:





N = DF.iloc[Train]
N1 = np.asarray(N)
S = DF1.iloc[Train]
S1 = np.asarray(S)
dfs_W = pd.concat([N, S])
dfs_W = np.asarray(dfs_W)


# In[16]:


# dfs_C.shape


# In[17]:


N = DF.iloc[Test]
N1 = np.asarray(N)
S = DF1.iloc[Test]
S1 = np.asarray(S)
dfs_W_ = pd.concat([N, S])


dfs_W_ = np.asarray(dfs_W_)


# In[16]:


# dfs_C.shape


# In[17]:


#N = DF.iloc[Test]
dfs_W_=pd.read_csv("../Data/VCF/W_combined_vcf.csv", header=None)
print(dfs_W_.shape)




#N1 = np.asarray(N)
#S = DF1.iloc[Test]
#S1 = np.asarray(S)
#dfs_W_ = pd.concat([N, S])


#dfs_W_ = np.asarray(dfs_W_)


# In[18]:


dfs_W_.shape


# In[19]:


#C_n = C_N.iloc[Test]
#EMP_crv

#C_s = C_S.iloc[Test]
dfs_C_ = pd.read_csv("../Data/VCF/EMP_Curvelets_.csv", header=None)


dfs_C_ = np.asarray(dfs_C_)


# In[20]:


dfs_C_.shape


# In[21]:


dfx1_ = pd.concat([pd.DataFrame(dfs_W_), pd.DataFrame(dfs_C_)],axis=1)
dfx=np.array(dfx1_)
dfs = pd.concat([pd.DataFrame(dfs_W), pd.DataFrame(dfs_C)],axis=1)
dfs=np.array(dfs)


# In[22]:


dfs_W.shape


# In[23]:


dfs.shape


# In[25]:


g_loss = []
for g in gammas:
    l_loss = []
    for l in lambdas:
        for train, test in kfold.split(dfs):
            model = models.Sequential()
            model.add(layers.Dense(8, kernel_regularizer=regularizers.l1_l2(l1=(1-g)*l, l2=g*l), activation='ReLU', input_shape=(np.shape(dfs)[1],)))
            model.add(layers.Dense(1, kernel_regularizer=regularizers.l1_l2(l1=(1-g)*l, l2=g*l),activation='ReLU'))
            model.compile(optimizer='adam', loss='binary_crossentropy', metrics=['accuracy'])
    
            history = model.fit(dfs, y, epochs=5, batch_size=100, validation_data=(dfs[test], y[test]),  verbose = 1)
            #print("DONE")
        history_dict = history.history
            #val_loss_ = history_dict['val_loss']
        valoss = np.mean(history_dict['val_loss'])
        l_loss.append(valoss)
    g_loss.append(l_loss)
        #print(g)
    #level_loss.append(g_loss)


# In[26]:


g_loss_array = np.array(g_loss)

# Find the indices of the minimum validation loss
min_loss_idx = np.unravel_index(np.argmin(g_loss_array), g_loss_array.shape)

# Extract the corresponding gamma and lambda
best_gamma = gammas[min_loss_idx[0]]
best_lambda = lambdas[min_loss_idx[1]]


# In[31]:


gamma =  best_gamma


# In[32]:


lamda =  best_lambda


# In[33]:


lamda


# In[34]:


gamma


# In[35]:


std_scale = StandardScaler().fit(dfs)#[:,r[0]])
X_train_std = std_scale.transform(dfs)#[:,r[0]])
#X_test_std_emp1 = std_scale.transform(emp_adj_med_mad)
X_test_std_sim  = std_scale.transform(dfx)#[:,r[0]])


# In[37]:


model = models.Sequential()
model.add(layers.Dense(8, kernel_regularizer=regularizers.l1_l2(l1=(1-gamma)*lamda, l2=gamma*lamda), activation='ReLU', input_shape=(np.shape(dfs)[1],)))
model.add(layers.Dense(1, kernel_regularizer=regularizers.l1_l2(l1=(1-gamma)*lamda, l2=gamma*lamda),activation='ReLU'))

model.compile(optimizer='adam', loss='binary_crossentropy', metrics=['accuracy'])


# In[38]:


model.fit(X_train_std, y, epochs=100, batch_size=100)








#results = model.evaluate(X_test_std_sim, y1)


# In[41]:


l = model.predict(X_test_std_sim, verbose=1)
p = np.where(l > 0.5, 1, 0)

U, C = np.unique(p, return_counts=True)


# In[87]:





# In[88]:


np.savetxt("../Data/VCF/prob_vcf.csv", l, fmt='%.18e', delimiter=' ', newline='\n', header='', footer='', comments='# ', encoding=None)


# In[89]:



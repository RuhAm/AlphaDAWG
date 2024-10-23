#!/usr/bin/env python
# coding: utf-8

# In[6]:

#from tensorflow.keras.models import Sequential
#from tensorflow.keras.layers import Dense
#import tensorflow as tf

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
from sklearn.calibration import calibration_curve
from matplotlib import pyplot
from sklearn.calibration import CalibratedClassifierCV
from keras.wrappers.scikit_learn import KerasClassifier
import matplotlib.pyplot as plt
from sklearn.preprocessing import StandardScaler


# In[7]:

# In[7]:
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


# In[8]:


def moving_average(x, w):
    return np.convolve(x, np.ones(w), 'valid') / w


# In[9]:


# Load data



# Get the number of rows in the dataset
DF = pd.read_csv("../Data/Curvelets/Curvelets_neut_"+align_val+"_resized_.csv", header=None)
DF1 = pd.read_csv("../Data/Curvelets/Curvelets_sweep_"+align_val+"_resized_.csv", header=None)
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








####


# In[12]:



a = np.zeros(train_observations)
b = np.ones(train_observations)
y = np.concatenate([a,b])


# In[11]:


kfold = KFold(5, shuffle = True, random_state=1)

lambdas = [1e-6, 1e-5, 1e-4,1e-3,1e-2,1e-1, 1,1e1]
gammas = [0, 0.1, 0.3, 0.5, 0.7, 0.9, 1]


DF


# In[13]:


N = DF.iloc[Train]
N1 = np.asarray(N)
S = DF1.iloc[Train]
S1 = np.asarray(S)
dfs_ = pd.concat([N, S])


dfs = np.asarray(dfs_)


# In[14]:


DFS=dfs


# In[15]:


N_ = DF.iloc[Test]
S_ = DF1.iloc[Test]
dfx = pd.concat([N_, S_])


# In[16]:


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


# In[21]:


g_loss_array = np.array(g_loss)

# Find the indices of the minimum validation loss
min_loss_idx = np.unravel_index(np.argmin(g_loss_array), g_loss_array.shape)

# Extract the corresponding gamma and lambda
best_gamma = gammas[min_loss_idx[0]]
best_lambda = lambdas[min_loss_idx[1]]


# In[22]:


lamda=best_lambda


# In[23]:


gamma=best_gamma


# In[ ]:





# In[24]:


std_scale = StandardScaler().fit(dfs)#[:,r[0]])
X_train_std = std_scale.transform(dfs)#[:,r[0]])
# X_test_std_emp1 = std_scale.transform(emp_adj_med_mad)
X_test_std_sim  = std_scale.transform(dfx)
#X_test_std_emp2 = std_scale.transform(emp_adj_med_mad)


# In[25]:


np.shape(X_train_std)


# In[26]:


model = models.Sequential()
model.add(layers.Dense(8, kernel_regularizer=regularizers.l1_l2(l1=(1-gamma)*lamda, l2=gamma*lamda), activation='ReLU', input_shape=(np.shape(dfs)[1],)))
#model.add(layers.Dense(8, kernel_regularizer=regularizers.l1_l2(l1=(1-gamma)*lamda, l2=gamma*lamda),activation='sigmoid'))
model.add(layers.Dense(1, kernel_regularizer=regularizers.l1_l2(l1=(1-gamma)*lamda, l2=gamma*lamda),activation='ReLU'))

model.compile(optimizer='adam', loss='binary_crossentropy', metrics=['accuracy'])


# In[27]:


X_train_std


# In[28]:


model.fit(X_train_std, y, epochs=100, batch_size=100, verbose=1)


# In[29]:


X_test_std_sim.shape


# In[30]:


a1 = np.zeros(test_observations)
b1 = np.ones(test_observations)
y1 = np.concatenate([a1,b1])

results = model.evaluate(X_test_std_sim, y1)


# In[31]:


l = model.predict(X_test_std_sim, verbose=1)
p = np.where(l > 0.5, 1, 0)

U, C = np.unique(p, return_counts=True)


# In[36]:


np.savetxt("../Data/Results/Nonlim_Pred_Crv_"+str(align_val)+".csv", p, fmt='%.18e', delimiter=' ', newline='\n', header='', footer='', comments='# ', encoding=None)


# In[37]:


np.savetxt("../Data/Results/Nonlim_Prob_Crv_"+str(align_val)+".csv", l, fmt='%.18e', delimiter=' ', newline='\n', header='', footer='', comments='# ', encoding=None)


# In[38]:


from sklearn.metrics import confusion_matrix


# In[39]:


c1=confusion_matrix(y1, p)


# In[40]:


print(c1)


# In[41]:


np.savetxt("../Data/Results/Nonlim_cm_crv_"+str(align_val)+".csv", c1, delimiter=' ', newline='\n', header='', footer='', comments='# ', encoding=None)


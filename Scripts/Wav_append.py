#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
import numpy as np

import sys

outdir = sys.argv[1]
observations= sys.argv[2]


df=pd.read_csv("../Data/Wavelets/W_neut_align_0.csv",index_col=0)
#df


# In[8]:


d=np.asarray(df)
d=np.transpose(d)
d


# In[9]:


np.shape(d)


# In[10]:


np.savetxt("../Data/Wavelets/W_combined_neut_align.csv",d, delimiter=",")
with open('../Data/Wavelets/W_combined_neut_align.csv', 'ab') as f:
    for i in range(1,int(observations)-1):
        df=pd.read_csv("../Data/Wavelets/W_neut_align_"+str(i+1)+".csv",index_col=0)
        d=np.asarray(df)
        d=np.transpose(d)
        np.savetxt(f, d, delimiter=",")


# In[12]:


df.shape


# In[ ]:


df=pd.read_csv("../Data/Wavelets/W_sweep_align_0.csv",index_col=0)


# In[ ]:


d=np.asarray(df)
d=np.transpose(d)
d


# In[ ]:


np.savetxt("../Data/Wavelets/W_combined_sweep_align.csv",d, delimiter=",")
with open('../Data/Wavelets/W_combined_sweep_align.csv', 'ab') as f:
    for i in range(1,int(observations)-1):
        df=pd.read_csv("../Data/Wavelets/W_sweep_align_"+str(i+1)+".csv",index_col=0)
        d=np.asarray(df)
        d=np.transpose(d)
        np.savetxt(f, d, delimiter=",")


#Without alignment processing

#Sweep

df=pd.read_csv("../Data/Wavelets/W_sweep_parse_resized_0.csv",index_col=0)
d=np.asarray(df)
d=np.transpose(d)

np.savetxt("../Data/Wavelets/W_combined_sweep_parse.csv",d, delimiter=",")
with open('../Data/Wavelets/W_combined_sweep_parse.csv', 'ab') as f:
    for i in range(1,int(observations)-1):
        df=pd.read_csv("../Data/Wavelets/W_sweep_parse_resized_"+str(i)+".csv",index_col=0)
        d=np.asarray(df)
        d=np.transpose(d)
        np.savetxt(f, d, delimiter=",")

#Neutral

df=pd.read_csv("../Data/Wavelets/W_neut_parse_resized_0.csv",index_col=0)
d=np.asarray(df)
d=np.transpose(d)

np.savetxt("../Data/Wavelets/W_combined_neut_parse.csv",d, delimiter=",")
with open('../Data/Wavelets/W_combined_neut_parse.csv', 'ab') as f:
    for i in range(1,int(observations)-1):
        df=pd.read_csv("../Data/Wavelets/W_neut_parse_resized_"+str(i)+".csv",index_col=0)
        d=np.asarray(df)
        d=np.transpose(d)
        np.savetxt(f, d, delimiter=",")




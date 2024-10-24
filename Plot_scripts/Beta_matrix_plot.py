#!/usr/bin/env python
# coding: utf-8

# In[13]:


import pandas as pd


# In[14]:


import matplotlib as mpl
import matplotlib.pyplot as plt
import numpy as np


# In[15]:


P=pd.read_csv("beta_matrix_filename", index_col=0) #you will need to put the filename and directory of beta matrix


# In[16]:


class MidpointNormalize(mpl.colors.Normalize):
    """Normalise the colorbar."""
    def __init__(self, vmin=None, vmax=None, midpoint=None, clip=False):
        self.midpoint = midpoint
        mpl.colors.Normalize.__init__(self, vmin, vmax, clip)

    def __call__(self, value, clip=None):
        x, y = [self.vmin, self.midpoint, self.vmax], [0, 0.5, 1]
        return np.ma.masked_array(np.interp(value, x, y), np.isnan(value))


# In[17]:


# elev_min=-0.04
# elev_max=0.010
mid_val=0
plt.figure(figsize=(10, 10))
plt.imshow(P.T, cmap='RdBu',norm=MidpointNormalize(midpoint=mid_val))
plt.tick_params(labelsize=18)

cbar = plt.colorbar()
for t in cbar.ax.get_yticklabels():
     t.set_fontsize(18)


plt.xlabel('SNP',fontsize=18)
plt.ylabel('Haplotype',fontsize=18)


# In[ ]:





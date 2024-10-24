#!/usr/bin/env python
# coding: utf-8

# In[2]:


from matplotlib.colors import LinearSegmentedColormap

def grayscale_cmap(cmap):
    """Return a grayscale version of the given colormap"""
    cmap = plt.cm.get_cmap(cmap)
    colors = cmap(np.arange(cmap.N))
    
    # convert RGBA to perceived grayscale luminance
    # cf. http://alienryderflex.com/hsp.html
    RGB_weight = [0.299, 0.587, 0.114]
    luminance = np.sqrt(np.dot(colors[:, :3] ** 2, RGB_weight))
    colors[:, :3] = luminance[:, np.newaxis]
        
    return LinearSegmentedColormap.from_list(cmap.name + "_gray", colors, cmap.N)


# In[5]:


import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import seaborn as sb


from math import pi
from matplotlib.colors import ListedColormap

s=float(91.4) #Sweep_detected_as_sweep
n=float(94.0) #Neutral_detected_as_newtral


cm =  [[100-s, s], [n, 100-n]]

#Here 91.4


df_cm = pd.DataFrame(cm)

cmap = sb.cubehelix_palette(start=(5/6)*pi, rot=0.1, light=1, dark=0.25, n_colors=10)

gs_kw = dict(left=0, right=1, top=1, bottom=0)

fig, ax = plt.subplots(nrows=1, ncols=1, figsize=(8, 8), gridspec_kw=gs_kw)

ax = sb.heatmap(data=df_cm, vmin=0.0, vmax=100.0,linewidths=1, linecolor='black', annot=True, annot_kws={"size": 34}, fmt='.1f', ax=ax, square=True, cbar=False,
                cmap=grayscale_cmap(ListedColormap(cmap)), xticklabels=False, yticklabels=False)

for _, spine in ax.spines.items():
    spine.set_visible(True)
    spine.set_linewidth(2)

#plt.savefig( 'Directory/confusion.pdf', format='pdf')


# In[ ]:





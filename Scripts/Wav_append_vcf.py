

import pandas as pd
import numpy as np

import sys

outdir = sys.argv[1]
observations= sys.argv[2]


df=pd.read_csv("../Data/VCF/W_output_vcf_0.csv",index_col=0)


d=np.asarray(df)
d=np.transpose(d)
d




np.shape(d)





np.savetxt("../Data/VCF/W_combined_vcf.csv",d, delimiter=",")
with open('../Data/VCF/W_combined_vcf.csv', 'ab') as f:
    for i in range(1,int(observations)-int(1)):
        df=pd.read_csv("../Data/VCF/W_output_vcf_"+str(i)+".csv",index_col=0)
        d=np.asarray(df)
        d=np.transpose(d)
        np.savetxt(f, d, delimiter=",")





df.shape


print("Wavelet transformed vcf observations are now combined")




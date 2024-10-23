#!/usr/bin/env Rscript
library(caret)


library(waveslim)
library(gtools)
args <- commandArgs(trailingOnly = TRUE)
outdir <- args[1]
observations <- as.integer(args[2])


Level=1
for (i in 0:(observations-1))
{ 
    M <- read.csv(paste0(outdir,"/VCF/output_",i,".csv"), header = TRUE, row.names = NULL)
    wS<-dwt.2d(as.matrix(M), Level)
    d<-unlist(wS)
    write.csv(d, file = paste0(outdir,"/VCF/W_output_vcf_",i,".csv"))
}


print("Alignment proceessed vcf observations are now wavelet transformed.")



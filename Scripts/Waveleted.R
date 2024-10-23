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
    M <- read.csv(paste0(outdir,"/sweep_align_",i,".csv"), header = TRUE, row.names = NULL)
    wS<-dwt.2d(as.matrix(M), Level)
    d<-unlist(wS)
    write.csv(d, file = paste0(outdir,"/Wavelets/W_sweep_align_",i,".csv"))
    print(paste("Wavelet transformed sweep observation (alignment processed):", i))
}

Level=1
for (i in 0:(observations-1))
{ 
    M <- read.csv(paste0(outdir,"/neut_align_",i,".csv"), header = TRUE, row.names = NULL)
    wS<-dwt.2d(as.matrix(M), Level)
    d<-unlist(wS)
    write.csv(d, file = paste0(outdir,"/Wavelets/W_neut_align_",i,".csv"))
    print(paste("Wavelet transformed neutral observation (alignment processed):", i))
}

print("Alignment proceessed Sweep and Neutral observations are now wavelet transformed.")

#No alignment

for (i in 0:(observations-1))
{ 
    M <- read.csv(paste0(outdir,"/neut_parse_resized_",i,".csv"), header = TRUE, row.names = NULL)
    wS<-dwt.2d(as.matrix(M), Level)
    d<-unlist(wS)
    write.csv(d, file = paste0(outdir,"/Wavelets/W_neut_parse_resized_",i,".csv"))
    print(paste("Wavelet transformed neutral observation (locally sorted):", i))
}

for (i in 0:(observations-1))
{ 
    M <- read.csv(paste0(outdir,"/sweep_parse_resized_",i,".csv"), header = TRUE, row.names = NULL)
    wS<-dwt.2d(as.matrix(M), Level)
    d<-unlist(wS)
    write.csv(d, file = paste0(outdir,"/Wavelets/W_sweep_parse_resized_",i,".csv"))
    print(paste("Wavelet transformed sweep observation (locally sorted)", i))
}

print("Locally sorted Sweep and Neutral observations are now wavelet transformed.")

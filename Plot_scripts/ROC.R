library(caret)
library(ggplot2)
library(plotly)
library(dplyr)
library(ggpubr)
library(ROCR)

#You will need to put the probabilites from your own path

Y<-data.frame(class = as.factor( c( rep("Sweep", 1000), rep("Neutral", 1000) ) ) )
df <- read.csv(paste0("Filename_and_directory_for_readling_wavelet_probabilities"),header = FALSE)#, row.names = 1)
probs <- as.matrix(df)

probs <- as.numeric(probs)
probs_W <- data.frame( Sweep = c(probs),Neutral = 1-c(probs)  )
neutral_probs_W <-probs_W[Y$class == "Neutral", ]
sweep_probs_W <-probs_W[Y$class == "Sweep", ]

df <- read.csv(paste0("Filename_and_directory_for_readling_curvelet_probabilities"), header = FALSE)#,row.names = 1)#, row.names = 1)#, row.names = 1)
probs <- as.matrix(df)
probs_C <- data.frame( Sweep = c(probs),Neutral = 1-c(probs)  )
neutral_probs_C <-probs_C[Y$class == "Neutral", ]
sweep_probs_C <-probs_C[Y$class == "Sweep", ]



df <- read.csv(paste0("Filename_and_directory_for_readling_wavelet_curvelet_probabilities"), header = FALSE)#,row.names = 1)
probs <- as.matrix(df)
probs <- unlist(df)
probs <- as.numeric(probs)
probs_CW <- data.frame( Sweep = c(probs),Neutral = 1-c(probs)  )
neutral_probs_CW <-probs_CW[Y$class == "Neutral", ]
sweep_probs_CW <-probs_CW[Y$class == "Sweep", ]


thresholds = seq(0, 1,by= 0.001)

fpr <- seq(0, 1, by = 0.001)
tpr_W <- seq(0, 1, by = 0.001)
tpr_C <- seq(0, 1, by = 0.001)
tpr_CW <- seq(0, 1, by = 0.001)

for( i in 2:(length(fpr)-1) ) {
  tpr_W[i] = mean( sweep_probs_W$Sweep >= quantile(neutral_probs_W$Sweep, 1 - fpr[i]) )
  
  
  tpr_C[i] = mean( sweep_probs_C$Sweep >= quantile(neutral_probs_C$Sweep, 1 - fpr[i]) )
  
  
  tpr_CW[i] = mean( sweep_probs_CW$Sweep >= quantile(neutral_probs_CW$Sweep, 1 - fpr[i]) )
  
  
 
  
  
}

rocs <- tibble(class = c( rep("Wavelet", length(fpr)), 
                          rep("Curvelet",length(fpr)),
                          rep("WC",length(fpr))),
               fpr = c(fpr,fpr,fpr),
               tpr = c(tpr_W, tpr_C,tpr_CW))
color_list <- c(
  Wavelet = rgb(166/255, 97/255, 26/255),
  Curvelet = rgb(223/255, 194/255, 125/255),
  WC = rgb(128/255, 205/255, 193/255))
linetype_list <- c(Wavelet = "dotdash", Curvelet = "dashed", WC = "dotted")#, ImaGene = "solid")

order_list <- c("Wavelet", "Curvelet", "WC")


roc_plot <- ggplot(data = rocs) +
  geom_line(mapping = aes(x = fpr, y = tpr, color = class, linetype = class), size = 2) +
  xlab("False positive rate") +
  ylab("True positive rate") +
  scale_color_manual(values = color_list, breaks = order_list) +
  scale_linetype_manual(values = linetype_list, breaks = order_list) +
  theme_bw() +
  theme(aspect.ratio = 1,
        legend.position = c(0.5, 0.45),
        legend.title = element_blank(),
        legend.key.width = unit(2, 'cm'),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.text=element_text(size=26),
        axis.title = element_text(size = 26),
        text = element_text(size = 26))

roc_plot <- roc_plot + guides(linetype = guide_legend(override.aes = list(size = 2)))


#pdf(file = "ROC.pdf")
print(roc_plot)
dev.off()

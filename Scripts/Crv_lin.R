

library(abind)
library(glmnet)
library(caret)
library(waveslim)
#library(MLmetrics)
#library(plotly)
library(dplyr)


# Parse command-line arguments manually

args <- commandArgs(trailingOnly = TRUE)

# Initialize default values for arguments
train_observations <- 80
test_observations <- 10
align <- 0

# Loop through arguments and assign based on flags
for (i in seq(1, length(args), by = 2)) {
  flag <- args[i]
  value <- as.integer(args[i + 1])
  
  if (flag == "--train") {
    train_observations <- value
  } else if (flag == "--test") {
    test_observations <- value
  } else if (flag == "--alignment") {
    align <- value
  } else {
    stop(paste("Unknown flag:", flag))
  }
}

# Print the parsed values for debugging
cat("Training with", train_observations, "train observations and", test_observations, "test observations.\n")
cat("Alignment processing:", align, "\n")

# Continue with the rest of your script logic...
if (align == 0) {
  align_val <- "parse"
} else if (align == 1) {
  align_val <- "align"
} else {
  stop("Invalid value for alignment. Please provide 0 for no alignment or 1 for alignment.")
}

# Load data and proceed with your existing code...
print("start")
#S <- read.csv(paste0("../Data/Curvelets/Curvelets_sweep_",align_val,"_resized_.csv"), header = FALSE)#, row.names = NULL)
S <- read.csv(paste0("../Data/Curvelets/Curvelets_sweep_", align_val, "_resized_.csv"), header = FALSE)#, row.names=1)

dim(S)
N <- read.csv(paste0("../Data/Curvelets/Curvelets_neut_",align_val,"_resized_.csv"), header = FALSE)#,row.names=1)#, row.names = NULL)

dim(N)

# Continue the rest of your processing logic...


# S <- read.csv(paste0("../Data/Curvelets_sweep_",outdir,".csv"), header = TRUE, row.names = 1)
# N <- read.csv(paste0("../Data/Curvelets_neut_",outdir,".csv"), header = TRUE, row.names = 1)

#Curvelets_sweep_
#Curvelets_neut_

smp_size_train <- train_observations
smp_size_test <- test_observations

set.seed(123)

train_ind <- sample(seq_len(nrow(N)), size = smp_size_train)
test_ind <- sample(seq_len(nrow(N)), size = smp_size_test)

N_train <- N[train_ind,, ]
N_test <- N[test_ind,, ]

#dim(N_train)
#dim(N_test)

S_train <- S[train_ind,, ]
S_test <- S[test_ind,, ]

# dim(S_train)
# dim(S_test)


add<-abind(N_train, S_train, along = 1)
ad<-abind(N_test, S_test, along = 1)


y<-c(rep(0,train_observations), rep(1,train_observations)) 

y1<-c(rep(0,test_observations), rep(1,test_observations))  

#alphas = c(0, 0.1, 0.9, 1)
alphasx <- list(0, 0.1, 0.9, 1)

deviances_cp <- c()
lambdas_cp <- c()

  for(aIndex in 1:length(alphasx)) {
    cvfit <- cv.glmnet(add, y, family = "binomial", alpha = alphasx[aIndex], nfolds = 5, type.measure = "deviance")
	  deviances_cp[aIndex] = min(cvfit$cvm)
	  lambdas_cp[aIndex] = cvfit$lambda.min

  }



a <- alphasx[ which(deviances_cp == min(deviances_cp), arr.ind = TRUE)]
Min_lambda <- lambdas_cp[which(deviances_cp == min(deviances_cp), arr.ind = TRUE)]






#Trainin final model start here


wtData<-add
#dim(wtData)
wtDat<-as.matrix(ad)
#dim(wtDat)

trainMean <- apply(wtData,2,mean)
trainSd <- apply(wtData,2,sd)


wtData1 <- sweep(sweep(wtData, 2L, trainMean), 2, trainSd, "/")
#dim(wtData1)


wtDat1 <- sweep(sweep(wtDat, 2L, trainMean), 2, trainSd, "/")
#dim(wtDat1)


#dim(wtData1)
#dim(wtDat1)
fit <- glmnet(wtData1, y, alpha = a, family = "binomial", standardize = FALSE)
Pred<-predict(fit, newx = wtDat1, type = "class", s = Min_lambda)
dim(Pred)

Prob<- predict(fit, newx = wtDat1, type = "response", s = Min_lambda)
dim(Prob)

dim(y1)
#xtab <- table(c(Pred), c(y1))
#print(xtab)
#x23 = confusionMatrix(xtab)
#print(x23)

Pred <- factor(Pred,levels = c(0, 1))
y1 <- factor(y1,levels = c(0, 1))
xtab <- table(Pred, y1)
x23 = confusionMatrix(xtab)
print(x23)

df2 <- as.data.frame(as.matrix(Prob))
df3 <- as.data.frame(as.matrix(Pred))
write.csv(df2, file = paste0('../Data/Results/Lin_Prob_CRV_', align_val, '.csv'))
write.csv(df3, file = paste0('../Data/Results/Lin_Pred_CRV_', align_val, '.csv'))
write.csv(xtab, file = paste0('../Data/Results/Lin_CM_CRV_', align_val, '.csv'))

#xtab <- table(c(Pred), c(y1))
#print(xtab)
#x23 = confusionMatrix(xtab)

#write.csv(df3, file = paste0('../Data/Results/Pred W', align_val, '.csv'))
#write.csv(xtab, file = paste0('../Data/Results/CM W', align_val, '.csv'))




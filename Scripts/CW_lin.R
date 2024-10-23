

library(abind)
library(glmnet)
library(caret)
library(waveslim)
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

S <- read.csv(paste0("../Data/Wavelets/W_combined_sweep_", align_val, ".csv"), header = FALSE)#, row.names = 1)
N <- read.csv(paste0("../Data/Wavelets/W_combined_neut_", align_val, ".csv"), header = FALSE)#, row.names = 1)


dim(S)
dim(N)

Add <- read.csv(paste0("../Data/Curvelets/Curvelets_neut_",align_val,"_resized_.csv"), header = FALSE)#,# row.names = 1)

Ad <-read.csv(paste0("../Data/Curvelets/Curvelets_sweep_",align_val,"_resized_.csv"), header = FALSE)#, row.names = 1)
dim(Add)
dim(Ad)



smp_size_train <- train_observations
smp_size_test <- test_observations

set.seed(123)


train_ind <- sample(seq_len(nrow(N)), size = smp_size_train)
test_ind <- sample(seq_len(nrow(N)), size = smp_size_test)

N_trW <- N[train_ind,, ]
N_tstW <- N[test_ind,, ]


S_trW <- S[train_ind,, ]
S_tstW <- S[test_ind,, ]


add<-abind(N_trW, S_trW, along = 1)
ad<-abind(N_tstW, S_tstW, along = 1)


N_trC <- Add[train_ind,, ]
N_tstC <- Add[test_ind,, ]


S_trC <- Ad[train_ind,, ]
S_tstC <- Ad[test_ind,, ]


addC<-abind(N_trC, S_trC, along = 1)
adC<-abind(N_tstC, S_tstC, along = 1)



y<-c(rep(0,nrow(N_trW)), rep(1,nrow(S_trW)))

y1<-c(rep(0,nrow(N_tstW)), rep(1,nrow(S_tstW)))
length(y1)





alphas = c(0, 0.1, 0.9, 1)
cwData<-abind(add, addC,along = 2)
dim(cwData)
deviances_cp <- c()
lambdas_cp <- c()

  for(aIndex in 1:length(alphas)) {
    cvfit <- cv.glmnet(cwData, y, family = "binomial", alpha = alphas[aIndex], nfolds = 5, type.measure = "deviance")
	  deviances_cp[aIndex] = min(cvfit$cvm)
	  lambdas_cp[aIndex] = cvfit$lambda.min
  }



a <- alphas[ which(deviances_cp == min(deviances_cp), arr.ind = TRUE)]
Min_lambda <- lambdas_cp[which(deviances_cp == min(deviances_cp), arr.ind = TRUE)]




####

cwDat<-abind(ad, adC,along = 2)
dim(cwDat)

trainMean <- apply(cwData,2,mean)
trainSd <- apply(cwData,2,sd)

#length(trainSd)

wtData1 <- sweep(sweep(cwData, 2L, trainMean), 2, trainSd, "/")
wtDat1 <- sweep(sweep(cwDat, 2L, trainMean), 2, trainSd, "/")

fit <- glmnet(as.matrix(wtData1), y, alpha = a, family = "binomial", standardize = FALSE)
Pred<-predict(fit, newx = as.matrix(wtDat1), type = "class", s = Min_lambda)
Prob<- predict(fit, newx = as.matrix(wtDat1), type = "response", s = Min_lambda)
Pred <- factor(Pred,levels = c(0, 1))
y1 <- factor(y1,levels = c(0, 1))
xtab <- table(Pred, y1)
x23 = confusionMatrix(xtab)

print(x23)
df2 <- as.data.frame(as.matrix(Prob))
df3 <- as.data.frame(as.matrix(Pred))
write.csv(df2, file = paste0('../Data/Results/Prob CW_', align_val, '.csv'))
write.csv(df3, file = paste0('../Data/Results/Pred CW_', align_val, '.csv'))
write.csv(xtab, file = paste0('../Data/Results/CM CW_', align_val, '.csv'))


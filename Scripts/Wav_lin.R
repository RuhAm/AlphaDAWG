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
align <- FALSE  # Default to false (no alignment)

# Loop through arguments and assign based on flags
for (i in seq(1, length(args), by = 2)) {
  flag <- args[i]
  value <- args[i + 1]
  
  if (flag == "--train") {
    train_observations <- as.integer(value)
  } else if (flag == "--test") {
    test_observations <- as.integer(value)
  } else if (flag == "--alignment") {
    if (tolower(value) == "true") {
      align <- TRUE
    } else if (tolower(value) == "false") {
      align <- FALSE
    } else {
      stop("Invalid value for --alignment. Please use 'true' or 'false'.")
    }
  } else {
    stop(paste("Unknown flag:", flag))
  }
}

# Print the parsed values for debugging
cat("Training with", train_observations, "train observations and", test_observations, "test observations.\n")
cat("Alignment processing:", align, "\n")

# Continue with the rest of your script logic...
align_val <- ifelse(align, "align", "parse")

# Load data and proceed with your existing code...
S <- read.csv(paste0("../Data/Wavelets/W_combined_sweep_", align_val, ".csv"), header = FALSE)
N <- read.csv(paste0("../Data/Wavelets/W_combined_neut_", align_val, ".csv"), header = FALSE)

# Continue with your model logic here...


smp_size_train <- train_observations
smp_size_test <- test_observations

set.seed(123)

train_ind <- sample(seq_len(nrow(N)), size = smp_size_train)
test_ind <- sample(seq_len(nrow(N)), size = smp_size_test)

N_train <- N[train_ind,, ]
N_test <- N[test_ind,, ]



S_train <- S[train_ind,, ]
S_test <- S[test_ind,, ]




add<-abind(N_train, S_train, along = 1)
ad<-abind(N_test, S_test, along = 1)


y<-c(rep(0,train_observations), rep(1,train_observations)) 

y1<-c(rep(0,test_observations), rep(1,test_observations))  


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

wtDat<-as.matrix(ad)
trainMean <- apply(wtData,2,mean)
trainSd <- apply(wtData,2,sd)
wtData1 <- sweep(sweep(wtData, 2L, trainMean), 2, trainSd, "/")
wtDat1 <- sweep(sweep(wtDat, 2L, trainMean), 2, trainSd, "/")



dim(wtData1)
dim(wtDat1)


fit <- glmnet(wtData1, y, alpha = a, family = "binomial", standardize = FALSE)
Pred<-predict(fit, newx = wtDat1, type = "class", s = Min_lambda)
dim(Pred)

Prob<- predict(fit, newx = wtDat1, type = "response", s = Min_lambda)
dim(Prob)

dim(y1)


Pred <- factor(Pred,levels = c(0, 1))
y1 <- factor(y1,levels = c(0, 1))
xtab <- table(Pred, y1)
x23 = confusionMatrix(xtab)
print(x23)

df2 <- as.data.frame(as.matrix(Prob))
df3 <- as.data.frame(as.matrix(Pred))
write.csv(df2, file = paste0('../Data/Results/Lin_Prob_W_', align_val, '.csv'))
write.csv(df3, file = paste0('../Data/Results/Lin_Pred_W_', align_val, '.csv'))
write.csv(xtab, file = paste0('../Data/Results/Lin_CM_W_', align_val, '.csv'))

xtab <- table(c(Pred), c(y1))
x23 = confusionMatrix(xtab)
write.csv(xtab, file = paste0('../Data/Results/CM W', align_val, '.csv'))




#!/usr/bin/env python
# coding: utf-8

import argparse
import pandas as pd
import random
import numpy as np
from keras import models, layers, regularizers
from sklearn.model_selection import KFold
from sklearn.preprocessing import StandardScaler

# Set up argument parser
parser = argparse.ArgumentParser(description="Keras wavelet-curvelet combined model for empirical data")
parser.add_argument('--train', type=int, required=True, help='Number of training observations')
parser.add_argument('--test', type=int, required=True, help='Number of test observations')
parser.add_argument('--alignment', type=str, choices=['true', 'false'], required=True, help='Alignment flag (true/false)')

# Parse arguments
args = parser.parse_args()

# Number of train and test observations
train_observations = args.train
test_observations = args.test
alignment = args.alignment.lower() == 'true'  # Convert 'true'/'false' to Boolean

# Set align_val based on alignment flag
align_val = "align" if alignment else "no_align"

def log_odd(p):
    return np.log10(p / (1 - p))

def moving_average(x, w):
    return np.convolve(x, np.ones(w), 'valid') / w

# Hyperparameter setup
kfold = KFold(5, shuffle=True, random_state=1)
lambdas = [1e-6, 1e-5, 1e-4, 1e-3, 1e-2, 1e-1, 1, 1e1]
gammas = [0, 0.1, 0.3, 0.5, 0.7, 0.9, 1]

# Load data
C_N = pd.read_csv(f"../Data/Curvelets/Curvelets_neut_{align_val}_resized_.csv", header=None)
C_S = pd.read_csv(f"../Data/Curvelets/Curvelets_sweep_{align_val}_resized_.csv", header=None)
DF = pd.read_csv(f"../Data/Wavelets/W_combined_neut_{align_val}.csv", header=None)
DF1 = pd.read_csv(f"../Data/Wavelets/W_combined_sweep_{align_val}.csv", header=None)
num_rows = DF.shape[0]

# Ensure the number of observations does not exceed available data
train_observations = min(train_observations, num_rows)
test_observations = min(test_observations, num_rows - train_observations)

# Seed for both train and test
random.seed(123)
Train = random.sample(range(num_rows), train_observations)
remaining_indices = [i for i in range(num_rows) if i not in Train]
Test = random.sample(remaining_indices, test_observations)

# Prepare labels for training
y = np.concatenate([np.zeros(train_observations), np.ones(train_observations)])

# Set up data for training and testing
C_n, C_s = C_N.iloc[Train], C_S.iloc[Train]
dfs_C = np.asarray(pd.concat([C_n, C_s]))
N, S = DF.iloc[Train], DF1.iloc[Train]
dfs_W = np.asarray(pd.concat([N, S]))
dfs = np.array(pd.concat([pd.DataFrame(dfs_W), pd.DataFrame(dfs_C)], axis=1))

# Test data
dfs_W_ = pd.read_csv("../Data/VCF/W_combined_vcf.csv", header=None)
dfs_C_ = pd.read_csv("../Data/VCF/EMP_Curvelets_.csv", header=None)
dfx = np.array(pd.concat([pd.DataFrame(dfs_W_), pd.DataFrame(dfs_C_)], axis=1))

# Hyperparameter search with k-fold cross-validation
g_loss = []
for g in gammas:
    l_loss = []
    for l in lambdas:
        for train, test in kfold.split(dfs):
            model = models.Sequential([
                layers.Dense(8, kernel_regularizer=regularizers.l1_l2(l1=(1-g)*l, l2=g*l), activation='ReLU', input_shape=(dfs.shape[1],)),
                layers.Dense(1, kernel_regularizer=regularizers.l1_l2(l1=(1-g)*l, l2=g*l), activation='ReLU')
            ])
            model.compile(optimizer='adam', loss='binary_crossentropy', metrics=['accuracy'])
            history = model.fit(dfs, y, epochs=5, batch_size=100, validation_data=(dfs[test], y[test]), verbose=1)
        l_loss.append(np.mean(history.history['val_loss']))
    g_loss.append(l_loss)

# Identify best gamma and lambda
g_loss_array = np.array(g_loss)
min_loss_idx = np.unravel_index(np.argmin(g_loss_array), g_loss_array.shape)
best_gamma, best_lambda = gammas[min_loss_idx[0]], lambdas[min_loss_idx[1]]

# Scale data
std_scale = StandardScaler().fit(dfs)
X_train_std = std_scale.transform(dfs)
X_test_std_sim = std_scale.transform(dfx)

# Define final model with selected hyperparameters
model = models.Sequential([
    layers.Dense(8, kernel_regularizer=regularizers.l1_l2(l1=(1-best_gamma)*best_lambda, l2=best_gamma*best_lambda), activation='ReLU', input_shape=(dfs.shape[1],)),
    layers.Dense(1, kernel_regularizer=regularizers.l1_l2(l1=(1-best_gamma)*best_lambda, l2=best_gamma*best_lambda), activation='ReLU')
])
model.compile(optimizer='adam', loss='binary_crossentropy', metrics=['accuracy'])
model.fit(X_train_std, y, epochs=100, batch_size=100)

# Predict and save results
l = model.predict(X_test_std_sim, verbose=1)
np.savetxt("../Data/VCF/prob_vcf.csv", l, fmt='%.18e', delimiter=' ', newline='\n', header='', footer='', comments='# ', encoding=None)

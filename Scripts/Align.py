import pandas as pd
import numpy as np
from skimage.transform import resize
import sys

window = 10 #change window size to 100 when running with 1.1 Mb
stride = 1 #change stride to 10 when running with 1.1 Mb
observations = sys.argv[1]

# Alignment processing sweep
for i in range(int(observations)):
    try:
        df = pd.read_csv(f"../Data/sweep_parse_{i}.csv", index_col=0)
        df = np.asmatrix(df)
        s = np.shape(df)
        sortd = np.zeros(s)
        K = []
        
        # Main loop for processing
        for k in range(0, s[1] - window + 1, stride):
            A = np.array(df[:, k:k + window])
            df[:, k:k + window] = 0
            indexlist = np.argsort(np.linalg.norm(A, axis=1, ord=1))
            sortedA = A[indexlist]
            D = np.pad(sortedA, ((0, 0), (k, s[1] - window - k)), 'constant')
            sortd = sortd + D
            K.append(k)

        # Handle case where k hasn't been defined
        if K:  # Only proceed if K has values
            u = list(range(K[-1] + stride, s[1], stride))  # Use the last value of K
            K = K + u

            g = 1
            for j in K:
                if j + stride < window:
                    sortd[:, j:j + stride] *= (1 / g)
                    g = g + 1
                elif window <= j + stride <= s[1] - window:
                    sortd[:, j:j + stride] *= (1 / g)
                elif s[1] - window <= j + stride <= s[1]:
                    sortd[:, j:j + stride] *= (1 / g)
                    g = g - 1

            if s[1] >= 190:
                sortd = np.delete(sortd, [list(range(92)) + list(range(s[1] - 92, s[1]))], 1)
            #else:
                #print('NA')

            # Resize and save
            d = resize(sortd, (64, 64))
            pd.DataFrame(d).to_csv(f"../Data/sweep_align_resized_{i}.csv")
        else:
            print("No valid segments to process for sweep.")

    except Exception as e:
        print(f"Error processing sweep {i}: {e}")
        continue

print("Sweep observations are now alignment processed and resized.")

# Alignment processing neut
for i in range(int(observations)):
    try:
        df = pd.read_csv(f"../Data/neut_parse_{i}.csv", index_col=0)
        df = np.asmatrix(df)
        s = np.shape(df)
        sortd = np.zeros(s)
        K = []

        # Main loop for processing
        for k in range(0, s[1] - window + 1, stride):
            A = np.array(df[:, k:k + window])
            df[:, k:k + window] = 0
            indexlist = np.argsort(np.linalg.norm(A, axis=1, ord=1))
            sortedA = A[indexlist]
            D = np.pad(sortedA, ((0, 0), (k, s[1] - window - k)), 'constant')
            sortd = sortd + D
            K.append(k)

        # Handle case where k hasn't been defined
        if K:  # Only proceed if K has values
            u = list(range(K[-1] + stride, s[1], stride))  # Use the last value of K
            K = K + u

            g = 1
            for j in K:
                if j + stride < window:
                    sortd[:, j:j + stride] *= (1 / g)
                    g = g + 1
                elif window <= j + stride <= s[1] - window:
                    sortd[:, j:j + stride] *= (1 / g)
                elif s[1] - window <= j + stride <= s[1]:
                    sortd[:, j:j + stride] *= (1 / g)
                    g = g - 1

            if s[1] >= 190:
                sortd = np.delete(sortd, [list(range(92)) + list(range(s[1] - 92, s[1]))], 1)
            #else:
                #print('NA')

            # Resize and save
            d = resize(sortd, (64, 64))
            pd.DataFrame(d).to_csv(f"../Data/neut_align_resized_{i}.csv")
        else:
            print("No valid segments to process for neut.")

    except Exception as e:
        print(f"Error processing neut {i}: {e}")
        continue

print("Neutral observations are now alignment processed and resized.")

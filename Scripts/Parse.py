import pandas as pd
import numpy as np
from scipy import stats
from skimage.transform import resize
import sys

def process_csv(file_prefix, i):
    try:
        df = pd.read_csv(f"../Data/{file_prefix}_{i}.csv", header=None)
        Array_df = np.array(df)
        
        # Calculate the mode for each column
        mode_full = stats.mode(Array_df, axis=0)
        Mode_sliced = mode_full.mode[0]  # Get the mode of each column

        # Ensure Mode_sliced is treated as an array
        if isinstance(Mode_sliced, np.float64):
            Mode_sliced = np.array([Mode_sliced])  # Convert to array if it's a single value

        # Update the DataFrame based on mode values
        for j in range(len(Mode_sliced)):
            if Mode_sliced[j] in (1, 2):
                Array_df[:, j] = np.where(Array_df[:, j] == 1, 3, Array_df[:, j])
                Array_df[:, j] = np.where(Array_df[:, j] == 2, 4, Array_df[:, j])
                Array_df[:, j] = np.where(Array_df[:, j] == 0, 1, Array_df[:, j])
                Array_df[:, j] = np.where(Array_df[:, j] == 3, 0, Array_df[:, j])
                Array_df[:, j] = np.where(Array_df[:, j] == 4, 0, Array_df[:, j])

        # Sort based on L1 norm
        indexlist = np.argsort(np.linalg.norm(Array_df, axis=1, ord=1))
        sym_sortedA = Array_df[indexlist]

        # Save sorted data
        pd.DataFrame(sym_sortedA).to_csv(f"../Data/{file_prefix}_parse_{i}.csv")#, index=False)

        # Resize and save
        d = resize(sym_sortedA, (64, 64))#, anti_aliasing=True)
        pd.DataFrame(d).to_csv(f"../Data/{file_prefix}_parse_resized_{i}.csv")#, index=False)

        print(f'Saving locally sorted and resized {file_prefix} observations Iteration: {i}')
    except Exception as e:
        print(f"Error processing {file_prefix}_{i}: {e}")

def main():
    observations = int(sys.argv[1])
    
    for i in range(observations):
        process_csv("sweep", i)
        process_csv("neut", i)

if __name__ == "__main__":
    main()

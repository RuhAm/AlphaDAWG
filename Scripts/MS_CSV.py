import os
import numpy as np
import random
import math
import sys

outdir = sys.argv[1]
observations = sys.argv[2]

def addIndividuals(np_array):
    indexes = range(np_array.shape[0])
    list_array_added = []

    for j in indexes:
        if (j % 2) != 0:
            array_temp = np_array[j, :] + np_array[j-1, :]
            list_array_added.append(array_temp)

    np_array_added = np.array(list_array_added)
    return np_array_added

def saveToCSV_Sweep(i):
    filename_ms = f'{outdir}/sweep_{i}.ms'
    #filename_ms = f'{outdir}/output_{i}.ms'

    filename_csv = f'{outdir}/sweep_{i}.csv'

    file = open(filename_ms, 'r')
    Lines = file.readlines()

    genetic = False
    list_info = []

    # Strips the newline character
    for line in Lines:
        if 'positions:' in line:
            genetic = True
        elif '//' in line:
            genetic = False
        elif genetic == True:
            info = list(line[:-1])
            if info != []:
                info_np = np.array(info, dtype=int)
                list_info.append(info_np)

    np_array = np.array(list_info)

    # np_array_added = addIndividuals(np_array)
    np.savetxt(filename_csv, np_array, delimiter=",")

def saveToCSV_Neut(i):
    filename_ms = f'{outdir}/neut_{i}.ms'
    #filename_ms = f'{outdir}/output_{i}.ms'

    filename_csv = f'{outdir}/neut_{i}.csv'

    file = open(filename_ms, 'r')
    Lines = file.readlines()

    genetic = False
    list_info = []

    # Strips the newline character
    for line in Lines:
        if 'positions:' in line:
            genetic = True
        elif '//' in line:
            genetic = False
        elif genetic == True:
            info = list(line[:-1])
            if info != []:
                info_np = np.array(info, dtype=int)
                list_info.append(info_np)

    np_array = np.array(list_info)

    # np_array_added = addIndividuals(np_array)
    np.savetxt(filename_csv, np_array, delimiter=",")

def main():
    maxIterations = observations

    # Iterate through numReplicates and call function to run discoal
    #for i in range(int(maxIterations)):
        #print('Running Discoal Iteration: ', i)
        # alpha, f = rundiscoal(i)

    # Iterate through files saved by discoal and convert to .csv files
    for i in range(int(maxIterations)):
        print('Saving Sweep CSV Iteration:', i)
        saveToCSV_Sweep(i)

    for i in range(int(maxIterations)):
        print('Saving Neutral CSV Iteration:', i)
        saveToCSV_Neut(i)

if __name__ == "__main__":
    main()

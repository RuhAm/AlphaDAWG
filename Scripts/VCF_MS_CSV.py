import os
import numpy as np
import random
import math
import argparse
import pandas as pd
import sys
#from scipy import stats

#parser = argparse.ArgumentParser(description= 'Preprocess .vcf files')
#parser.add_argument('Num_', type=int, help= 'number of files to process')

#args = parser.parse_args()

#num_ = args.Num_

num_ = sys.argv[1]
num_ = int(num_)
#num_ = sys.argv[2]

def addIndividuals(np_array):

    indexes = range(np_array.shape[0])
    list_array_added = []

    for j in indexes:
        if ((j % 2) != 0):
            array_temp = np_array[j,:] + np_array[j-1,:]
            list_array_added.append(array_temp)

    

    np_array_added = np.array(list_array_added)

    return np_array_added



def saveToCSV(i):
    filename_ms = f"../Data/VCF/output_{i}.ms"
    filename_csv = f"../Data/VCF/output_{i}.csv"

    file = open(filename_ms, 'r')
    Lines = file.readlines()
    count = 0
    genetic = False

    list_info = []

    # Strips the newline character
    for line in Lines:
        if ('positions:' in line):
            genetic = True

        elif ('//' in line):
            genetic = False

        elif (genetic == True):
            info = list(line[:-1])
            if (info != []):
                info_np = np.array(info, dtype=int)
                list_info.append(info_np)

    np_array = np.array(list_info)
    np.savetxt(filename_csv, np_array, delimiter=",")


def main():
    


    for i in range(num_):
        print('Saving CSV Iteration: ', i)
        saveToCSV(i)


if __name__ == "__main__":
    main()


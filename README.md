# α-DAWG

Introduction
============

α-DAWG is a framework to distinguish signs of selective sweep
from genomic data. We use α-molecule transformation, such as
wavelets, curvelets or a combination of both to extract information from
the data to facilitate classification using machine learning. This
software package can be used for applying α-DAWG to classify any
genetic regions into sweep or neutral (i.e, regions showing signs of
selective sweep and region without them). We will show how to work with empirical data in the `.vcf` format and generate prediction of empirical samples. Users can generate any number of samples of both neutral and sweep classes based on their experimental need. 





Downloads and requirements
==========================

First clone the repo using the following command

        git clone https://github.com/RuhAm/AlphaDAWG

We will need `Python3`, `R` and `MATLAB` installed for different parts of the
project.

For `Python` dependencies, please install the following packages in a `conda` virtual
environment. Instructions for creating this virtual environment and installing the packages are available in the `conda_setup.txt` file inside  the `./AlphaDAWG/Scripts` folder. 

For `R`, the required packages can be installed by running the `install_packages.R` script in the terminal.

`cd ./AlphaDAWG/Scripts`


    Rscript install_packages.R

Also, users will need to install [Discoal](https://github.com/kr-colab/discoal) for utilzing our data generation pipeline.

Please note that, for using this software on windows you will need [WSL](https://learn.microsoft.com/en-us/windows/wsl/install) and [MinGW](https://www.mingw-w64.org/) installed in your system as [Discoal](https://github.com/kr-colab/discoal) is run using the make command.




For `MATLAB`, we will use the
[Curvelab](https://curvelet.org/download.php) package for curvelet
transform.

All relevant dependencies will be installed after these steps above. 

In this software, we have utilized Bash scripting to streamline all the steps, including data generation, preprocessing, model training and testing, and empirical application.





Data Simulation
===========================================
After downloading and extracting [Discoal](https://github.com/kr-colab/discoal) in our `./AlphaDAWG` folder, we will need to install discoal. 

Please note that the default discoal functionality restricts us to generates sites only as high as 220020 but in our case we will need to change it to 1100000 or higher by going to the `discoal.h` file and changing `MAXSITES` to 1100000 or higher.

Now we have to use the following command to install discoal from the `./AlphaDAWG/discoal-master` directory.

        make discoal


Users can generate (under CEU demographic model) sweep and neutral replicates using our Data Generation shell script `generate_replicates.sh`. This shell function has two arguments- <replicate_type> and <number_of_replicates>. <replicate_type> takes in [sweep|neutral] as input and <number_of_replicates> takes any integer as an input.





Now we need to copy the discoal executable and paste it to the `./AlphaDAWG/Scripts/` folder

Now we will work with the data generation pipeline.

First, we need to change our working directory to the folder

        cd ./AlphaDAWG/Scripts

 The following command is optional and needed to make each of the bash script executatable if you are not the super user of your system. 
 
        chmod +x generate_replicates.sh


Now we have made `generate_replicates.sh` executable.

Then running the following command will output 100 sweep observations in `./AlphaDAWG/Data/` folder in the following format the files
are names as `sweep_0.ms`, `sweep_1.ms`... and so on.

        ./generate_replicates.sh sweep 100
        
Then running the following command will output 100 neutral observations in `./AlphaDAWG/Data/` folder in the following format the files
are names as `neut_0.ms`, `neut_1.ms`... and so on.

        ./generate_replicates.sh neutral 100

100 samples for each class are now stored in the given in the `./AlphaDAWG/Data/` folder which will need to be preprocessed.


Also, please note that, `./AlphaDAWG/AlphaDAWG_simulation_scripts/` folder we provide scripts used in our study to generate constant size (Constant_1 and Constant_2) and  fluctuating size demographic data (CEU_1 and CEU_2), which users can use to generate their own training data. Users just have to follow the naming convention for the .ms files for utilizing our pipeline. For example: sweep file names will be `sweep_0.ms`, `sweep_1.ms`... and so on. Neutral file names will be `neut_0.ms`, `neut_1.ms`... and so on.




Data Preprocessing
===========================================
**Wavelet transformation**

Users can preprocess the sweep and neutral .ms files using global sorting and alignment processing using our Data Preprocessing shell script `preprocessing_pipeline.sh`. This shell function has two arguments <output_directory> and <observations>. We will need to provide the Data directory `../Data`  <observations> will takes any integer as an input.


     
Then running the following command will output 100 sweep and neutral observations that are locally sorted and alignment processed in `./AlphaDAWG/Data/` folder.

Please make sure the .sh file execultable using 

        chmod +x preprocessing_pipeline.sh

Now let's run the pipeline,

        ./preprocessing_pipeline.sh ../Data 100




Locally sorted observations will be in the following format: `sweep_parse_resized_0.csv`, `sweep_parse_resized_1.csv`... and so on and alignment proceessed sweep observations will be saved in the following format: `sweep_align_resized_0.csv`, `sweep_align_resized_1.csv`... and so on. 


It will also output 100 neutral observations that are locally sorted and alignment processed in the following format: `neut_parse_resized_0.csv`, `neut_parse_resized_1.csv`... and so on, and `sweep_align_resized_0.csv`, `sweep_align_resized_1.csv`, respectively. 

Furthermore, we will also have the wavelet transformed and combined files for all these observations in the following format in the `./Data/Wavelets` folder with the following filenames: 

`W_combined_sweep_parse.csv`, `W_combined_neut_parse.csv`, `W_combined_sweep_parse.csv`, `W_combined_neut_align.csv`, and `W_combined_sweep_align.csv`. 
        
Now we are done with data preprocessing and wavelet transformation. 

**Curvelet transformation**

Now we have to perform curvelet transformation on the same samples.


For curvelet transform we use the Curvelab package in `MATLAB` that we downloaded. Please copy the `fdct_wrapping_matlab` folder in the 
`./AlphaDAWG/Scripts` folder. We will also need to copy the included
`Transform_Curvelet.m` and `EMP_Transform_Curvelet.m` files from the `./AlphaDAWG/Scripts` folder to the `./AlphaDAWG/Scripts/fdct_wrapping_matlab` folder.


Now, we have to open MATLAB from terminal. For this we will need to provide the full path to your MATLAB installation directory. For example, if you are using macOS type,

        /Applications/MATLAB_R20XX.app/bin/matlab  -nodesktop

If you are using windows you will have to type,
        
       C:\Program Files\MATLAB\R20XX\bin\matlab.exe -nodesktop

If you are using linux the the command would be

      /usr/local/MATLAB/R20XX/bin/matlab -nodesktop
      
You have to change the directory according to your installation folder (replace R20XX with your version that is installed in your machine).


Now we have opened MATLAB. Now change the working directory of MATLAB to `./fdct_wrapping_matlab` by
    
        cd ./fdct_wrapping_matlab


Now the following command should perform the curvelet transform, where 0 stands for neutral observations and 1 stands for sweep observations.

        Transform_Curvelet(<number of samples>, <0|1>, <0|1>)
        

The output will be collected in a matrix, stored in `./Data/Curvelets` folder. For
example running

        Transform_Curvelet(100, 1, 1) 

will transform 100 sweep samples that are both locally sorted  and alignment processed and will output two matrices of size `100 x 10521`. Each `64 x 64` matrix yields a total of 10521 curvelet coefficients in the `./AlphaDAWG/Data/Curvelets` folder, the combined curvelets will be available and will have the following filenames: `Curvelets_sweep_parse_resized_.csv`, `Curvelets_neut_parse_resized_.csv`, `Curvelets_sweep_align_resized_.csv`, `Curvelets_neut_parse_resized_.csv`

Similarly, for transofrming 100 neutral samples that are both locally sorted  and alignment processed use the following command

        Transform_Curvelet(100, 0, 0) 

Don't forget to exit MATLAB with

        exit

Now we will have to change the working directory to the Scripts folder again.
        
        cd ..





Linear Model training and testing
===========================================
This script allows users to train three nonlinear α-DAWG models for detecting positive natural selection: α-DAWG[W], α-DAWG[C], and α-DAWG[W-C]. The user can specify which linear model to run, the number of training observations, number of testing observations, and whether to apply alignment processing or use or not.

## How to Run

        ./lin_models.sh {train_wavelet|train_curvelet|train_wavelet-curvelet} --train <train_size> --test <test_size> --alignment <true/false>


- `{train_wavelet|train_curvelet|train_wavelet-curvelet}` Specifies the model to train:
   - `<train_wavelet>` Runs the Wavelet model
   - `<train_curvelet>` Runs the Curvelet model
   - `<train_wavelet-curvelet>` Runs the combined Wavelet-Curvelet model

{train_wavelet|train_curvelet|train_wavelet-curvelet}: Specifies the model to train:
train_wavelet: Runs the Wavelet model.
train_curvelet: Runs the Curvelet model.
train_wavelet-curvelet: Runs the combined Wavelet-Curvelet model.
- --train <train_size>: Specifies the number of observations in the training dataset.
- --test <test_size>: Specifies the number of observations in the test dataset.
- --alignment <true/false>: Enables (if set true) or disables (if set false) alignment processing in the model:

Please make sure the .sh file execultable using

        chmod +x lin_models.sh
### Example Usage
To train the linear Wavelet model with 80 training observations per class, 20 test observations per class, and alignment preprocessing applied:

        ./lin_models.sh train_wavelet --train 80 --test 20 --alignment true
        

The probabilities, prediction and confusion matrices will be saved in the following folder `./AlphaDAWG/Data/Results` and will have the following format: `Lin_<Prob|Pred|CM>_<W|C|CW>_<align|parse>.csv`



Nonlinear Model training and testing
===========================================

This script allows users to train three nonlinear α-DAWG models for detecting positive natural selection: α-DAWG[W], α-DAWG[C], and α-DAWG[W-C]. The user can specify which linear model to run, the number of training observations, number of testing observations, and whether to apply alignment processing or use or not.

## How to Run

        ./lin_models.sh {train_wavelet|train_curvelet|train_wavelet-curvelet} --train <train_size> --test <test_size> --alignment <true/false>


- `{train_wavelet|train_curvelet|train_wavelet-curvelet}` Specifies the model to train:
   - `<train_wavelet>` Runs the Wavelet model
   - `<train_curvelet>` Runs the Curvelet model
   - `<train_wavelet-curvelet>` Runs the combined Wavelet-Curvelet model

{train_wavelet|train_curvelet|train_wavelet-curvelet}: Specifies the model to train:
train_wavelet: Runs the Wavelet model.
train_curvelet: Runs the Curvelet model.
train_wavelet-curvelet: Runs the combined Wavelet-Curvelet model.
- --train <train_size>: Specifies the number of observations in the training dataset.
- --test <test_size>: Specifies the number of observations in the test dataset.
- --alignment <true/false>: Enables (if set true) or disables (if set false) alignment processing in the model:

Please make sure the .sh file execultable using

        chmod +x nonlin_models.sh
### Example Usage
To train the linear Wavelet model with 80 training observations per class, 20 test observations per class, and alignment preprocessing applied:

        ./nonlin_models.sh train_wavelet --train 80 --test 20 --alignment true
        

The probabilities, prediction and confusion matrices will be saved in the following folder `./AlphaDAWG/Data/Results` and will have the following format: `Nonlin_<Prob|Pred|CM>_<W|C|CW>_<align|parse>.csv`

Empirical Application
===========================================


## VCF to MS Conversion



This script converts VCF (Variant Call Format) files into ms files. It allows the user to input a chromosome number and performs the conversion process.

## How to Run

### Steps

Please make sure the .sh file execultable using 

        chmod +x VCF_to_MS.sh

Now run the following command:

1. **Run the script** by passing the chromosome number as an argument:

    ```bash
    ./VCF_to_MS.sh <chromosome_number>
    ```

### Example Usage

        ./VCF_to_MS.sh CEU22




This will populate the `./AlphaDAWG/Data/VCF` folder with the .ms files `output_0.ms`, `output_1.ms`.. and so on.

Please note that an example sample file CEU22.vcf has been included in `./AlphaDAWG/Data/` folder which you can utilize. 

Please note the files have to be in the format "CEUX.vcf" where X is the chromosome number. Please adhere to this format in the file naming process.

# Preprocess ms files from VCF to csv


This script preprocesses the ms files to CSV and performs alignment processing. 


## How to Run

### Steps

1. **Run the script** 

Please make sure the .sh file execultable using 

        chmod +x EMP_preprocess.sh

Now run the following command:


We pass the chromosome number as an argument:

        ./EMP_preprocess.sh <number of observations>



### Example Usage

```bash
./EMP_preprocess.sh 1998
```

This will convert the .ms files to .csv, perform global sorting, and alignment processing on the .ms files. This will populate the `./AlphaDAWG/Data/VCF` folder with the alignment processed .csv files: `output_0.csv`, `output_1.csv`.. and so on. Also, a file named `Starting Positions of the samples.csv` will be saved in the `./AlphaDAWG/Data/VCF` folder that is of length 1998 representing the chromosomal positions.

## CSV to wavelet transformation Script

This script processes CSV files by applying wavelet decomposition. You will need to put `../Data` as the output directory and the number of observations to parse and wavelet-transform.

1. **Run the script** by passing the `../Data` as the output directory and the number of observations as an argument:


Please make sure the .sh file execultable using 

        chmod +x vcf_wav.sh

Now run the following command:

        ./vcf_wav.sh <output_directory> <observations>


    
    
### Example Usage

        ./vcf_wav.sh ../Data 1998

Each `64 x 64` matrix yields a total of 4096 curvelet coefficients in the `./AlphaDAWG/Data/VCF` folder, the combined curvelets will be available in the same folder and will have the following filename: `EMP_Curvelets_.csv`.



## CSV to curvelet transformation Script

Now we have to perform curvelet transformation for our empirical samples. We have to follow the same steps as we outlined in the **Curvelet transformation** section for  opening MATLAB in the terminal. Also, we need to set the working directory of MATLAB to `./fdct_wrapping_matlab` by typing
    
        cd ./fdct_wrapping_matlab


Now the following command will perform the curvelet transform on the empirical samples stored in the `./Data/VCF` folder.

        EMP_Transform_Curvelet(<number of samples>)
        
Example,

        EMP_Transform_Curvelet(1998) 

 The output will be collected in a matrix, stored in `./Data/VCF` folder.        

In the case of the example above, it will transform 1998 empirical samples that are alignment processed and will output a matrix of size
`1998 x 10521` in the `./Data/VCF` folder. Each `64 x 64` matrix yields a total of 10521 curvelet coefficients in the `./AlphaDAWG/Data/VCF` folder, the combined curvelets will be available and will have the following format: `EMP_Curvelets_.csv`. 



This will make a matrix with \<number of samples\> number of rows and 10521 columns in
`./Data/VCF`. Don't forget to exit MATLAB with

        exit





Now we will have to change the working directory to the `./AlphaDAWG/Scripts` folder again.
        
        cd ..


Now, let's move on to test these empirical samples using our combined model.

Empirical Testing
=============

1. **Run the script**:

Please make sure the .sh file execultable using

        chmod +x Alpha_emp.sh

Now run the following command:


This script allows users to train the combined nonlinear α-DAWG model. The user can specify the number of training observations, number of testing observations, and whether to apply alignment processing or use or not..

./Alpha_emp.sh --train <train_size> --test <test_size> --alignment <true/false>


## How to Run
    
        ./Alpha_emp.sh <number_of_train_observations> <number_of_test_observations> <alignment>

- --train <train_size>: Specifies the number of observations in the training dataset.
- --test <test_size>: Specifies the number of observations in the test dataset.
- --alignment <true/false>: Enables (if set true) or disables (if set false) 

### Example Usage

To train the nonlinear combined model with 80 training observations per class, 20 test observations per class, and alignment preprocessing applied:

        ./Alpha_emp.sh --train 80 --test 20 --alignment true


The probabilities of the empirical test samples will be saved in the  `./AlphaDAWG/Data/VCF` folder using the following name prob_vcf.csv. 

Please delete the empirical files after the model testing is done to ensure correct reading of files.



Trained models
=============
We have made available the trained mdoels in the `./AlphaDAWG/Trained models` directory inside `./AlphaDAWG/Trained models` folder. These models are using the CEU_2 dataset with 10000 train observations per class and 1000 test observations per class.

*Note:* The current implementation is limited to phased data but we intend to integrate the option to operate on unphased data in the future.

License
=============
Distributed under the MIT License. See **LICENSE.txt** for more information.


Contact
=============
Md Ruhul Amin (Aminm2021@fau.edu)



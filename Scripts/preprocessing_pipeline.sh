#!/bin/bash


# Function to display help
function show_help {
    echo "Usage: $0 [options] <output_directory> <observations>"
    echo "example: ./run_pipeline.sh ../Data 10"
    echo "Options:"
    echo "  -h, --help                Show this help message and exit"
    echo ""
    echo "Arguments:"
    echo "  output_directory          Directory where output files will be saved"
    echo "  observations              Number of observations you want to parse and decompose for each class"
    echo ""
    echo "Pipeline steps:"
    echo "  1. Run MS_CSV.py to process convert the ms files to csv"
    echo "  2. Run Parse.py to parse observations using local sorting"
    echo "  3. Run Align.py to performing alignment processing"
    echo "  4. Run Waveleted.R to apply wavelet decomposition"
    echo "  5. Run Wav_append.py to combine the wavelet decomposed observations"
}

# Check if help is requested
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
    exit 0
fi

# Check if the required number of arguments are provided
if [[ $# -lt 2 ]]; then
    echo "Error: Missing required arguments"
    show_help
    exit 1
fi

# The first argument is the output directory
outdir=$1
mkdir -p $outdir

# The second argument is the number of observations you want to parse and decompose for each class
observations=$2

# Run the pipeline steps
python3 MS_CSV.py $outdir $observations
python3 Parse.py  $observations
python3 Align.py $observations
Rscript Waveleted.R $outdir $observations
python3 Wav_append.py $outdir $observations

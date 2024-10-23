
# Function to display help
function show_help {
    echo "Usage: $0 [options] <output_directory> <observations>"
    echo "example: ./vcf_wav.sh ../Data 1998"
    echo "Options:"
    echo "  -h, --help                Show this help message and exit"
    echo ""
    echo "Arguments:"
    echo "  output_directory          Directory of the Data folder"
    echo "  observations              Number of observations you want to parse and decompose for each class"
    echo ""
    echo "Pipeline steps:"
    echo "  1. Run Waveleted_vcf.R to apply wavelet decomposition"
    echo "  2. Run Wav_append_vcf.py to combine the wavelet decomposed observations"
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

# The first argument is the Data directory
outdir=$1


# The second argument is the number of observations you want to parse and decompose for each class
observations=$2

Rscript Waveleted_vcf.R $outdir $observations
python3 Wav_append_vcf.py $outdir $observations

function show_help {
  
    echo "example usage: ./VCF_to_CSV.sh 1998"
    echo "Options:"
    echo "  -h, --help                Show this help message and exit"
    echo ""
    echo "Arguments:"
    echo "  numbrer of observations         Example: 1998"
    echo ""
    echo "Pipeline steps:"
    echo "  1. Run VCF_MS_CSV.py to process convert the ms files to locally sorted csv files"
	echo "  2. Run Align_VCF.py to perform alignment processing to locally sorted csv files"
    

}


observations=$1

# Run the pipeline steps
python3 VCF_MS_CSV.py $observations
python3 Align_VCF.py $observations


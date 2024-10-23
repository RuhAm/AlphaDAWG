function show_help {
  
    echo "example usage: ./VCF_to_MS.sh CEU22"
    echo "Options:"
    echo "  -h, --help                Show this help message and exit"
    echo ""
    echo "Arguments:"
    echo "  chromosome number         Example: CEU22"
    echo ""
    echo "Pipeline steps:"
    echo "  1. Run VCF_MS.py to process convert the VCF file to ms files"


}




chrom=$1



observations=$2
python3 VCF_MS.py $chrom


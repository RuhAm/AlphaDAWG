#!/bin/bash

# Function to display usage instructions
print_help() {
    echo "Usage: $0 [sweep|neutral] <number_of_replicates>"
    echo
    echo "Arguments:"
    echo "  sweep         Generate sweep replicates."
    echo "  neutral       Generate neutral replicates."
    echo "  number of replicates  Number of replicates to generate."
    echo
    echo "Example:"
    echo "  $0 sweep 10     # Generates 10 sweep replicates."
    echo "  $0 neutral 5    # Generates 5 neutral replicates."
}

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Error: Incorrect number of arguments."
    print_help  # Call the help function
    exit 1
fi

# Get input parameters
replicate_type=$1
num_replicates=$2

# Validate replicate type
if [ "$replicate_type" != "sweep" ] && [ "$replicate_type" != "neutral" ]; then
    echo "Error: Invalid replicate type. Choose 'sweep' or 'neutral'."
    print_help  # Call the help function
    exit 1
fi

# Execute corresponding Python script based on the replicate type
if [ "$replicate_type" == "sweep" ]; then
    echo "Generating $num_replicates sweep replicates..."
    python3 ceu_sweep.py $replicate_type $num_replicates
elif [ "$replicate_type" == "neutral" ]; then
    echo "Generating $num_replicates neutral replicates..."
    python3 ceu_neut.py $replicate_type $num_replicates
fi

# Print completion message
echo "Replicate generation complete."

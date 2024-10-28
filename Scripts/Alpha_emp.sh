#!/bin/bash

# Function to train the wavelet-curvelet combined model
train_wavelet_curvelet() {
  echo "Training Wavelet-Curvelet model with $1 train observations per class, $2 test observations per class, and alignment processing: $3..."
  python3 Alpha_emp.py --train "$1" --test "$2" --alignment "$3"
}

# Check for the correct number of arguments
if [ "$#" -ne 6 ]; then
  echo "Usage: ./emp_pipeline.sh --train <train_size> --test <test_size> --alignment <true/false>"
  echo "Example: ./emp_pipeline.sh --train 100 --test 20 --alignment true"
  exit 1
fi

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --train) train_obs="$2"; shift ;;
    --test) test_obs="$2"; shift ;;
    --alignment) alignment_choice="$2"; shift ;;
    *) echo "Unknown parameter passed: $1"; exit 1 ;;
  esac
  shift
done

# Validate alignment input
if [[ "$alignment_choice" != "true" && "$alignment_choice" != "false" ]]; then
  echo "Invalid alignment choice! Please enter 'true' or 'false'."
  exit 1
fi

# Run the training function
train_wavelet_curvelet "$train_obs" "$test_obs" "$alignment_choice"

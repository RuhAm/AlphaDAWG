#!/bin/bash

# Function to train the wavelet model
train_wavelet() {
  echo "Training Wavelet model with $1 train observations per class, $2 test observations per class, and alignment processing: $3..."
  python3 Keras_wav_software.py --train "$1" --test "$2" --alignment "$3"
}

# Function to train the curvelet model
train_curvelet() {
  echo "Training Curvelet model with $1 train observations per class, $2 test observations per class, and alignment processing: $3..."
  python3 Keras_crv_software.py --train "$1" --test "$2" --alignment "$3"
}

# Function to train the wavelet-curvelet combined model
train_wavelet-curvelet() {
  echo "Training Wavelet-Curvelet model with $1 train observations per class, $2 test observations per class, and alignment processing: $3..."
  python3 Keras_C+W-software.py --train "$1" --test "$2" --alignment "$3"
}

# Check for the correct number of arguments
if [ "$#" -lt 7 ]; then
  echo "Usage: ./wav.sh {train_wavelet|train_curvelet|train_wavelet_curvelet} --train <train_size> --test <test_size> --alignment <true/false>"
  echo "Example: ./wav.sh train_wavelet --train 100 --test 20 --alignment true"
  exit 1
fi

# Parse command-line arguments
model_choice=$1
shift

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

# Call the appropriate function based on the model choice
case $model_choice in
  train_wavelet)
    train_wavelet "$train_obs" "$test_obs" "$alignment_choice"
    ;;
  train_curvelet)
    train_curvelet "$train_obs" "$test_obs" "$alignment_choice"
    ;;
  train_wavelet-curvelet)
    train_wavelet-curvelet "$train_obs" "$test_obs" "$alignment_choice"
    ;;
  *)
    echo "Invalid model choice! Please enter 'train_wavelet', 'train_curvelet', or 'train_wavelet-curvelet'."
    exit 1
    ;;
esac

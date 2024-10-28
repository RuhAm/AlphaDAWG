#!/bin/bash

# Check the first argument to determine the method
method=$1

# Shift the first argument (train_<method>) off, leaving the rest of the arguments
shift

# Handle different methods based on the first argument
case "$method" in
  train_wavelet)
    echo "Running Wavelet model..."
    Rscript Wav_lin.R "$@"
    ;;

  train_curvelet)
    echo "Running Curvelet model..."
    Rscript Crv_lin.R "$@"
    ;;

  train_wavelet-curvelet)
    echo "Running Wavelet-Curvelet model..."
    Rscript CW_lin.R "$@"
    ;;

  *)
    echo "Usage: ./wav.sh {train_wavelet|train_curvelet|train_wavelet-curvelet} --train <train_size> --test <test_size> --alignment <true/false>"
    exit 1
    ;;
esac

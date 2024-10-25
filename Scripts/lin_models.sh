#!/bin/bash


print_help() {
    echo "Usage: $0 <model_choice> <number_of_train_observation> <number_of_test_observation> <alignment>"
    echo
    echo "Arguments:"
    echo "  model_choice: "
	echo "				  1 for Wavelet model"
    echo "				  2 for Curvelet model"
    echo "				  3 for Wavelet-Curvelet combined model"
    echo "  number_of_train_observation: total number of observation for training"
	echo "  number_of_test_observation: total number of observation for test"
    echo "  alignment: "
	echo "			   1 for alignment"
    echo "			   0 for no alignment"
    echo
    echo "Example:"
    echo "  $0 3 80 20 1    # train wavelet-curvelet combined model with 80 training and 20 test observation using alignment processing"
}


# Check if the correct number of arguments is provided
if [ "$#" -ne 4 ]; then
    echo "Error: Incorrect number of arguments."
    print_help  # Call the help function
    exit 1
fi

# Function to train the wavelet model
train_wavelet() {
  echo "Training Wavelet model with $1 train observations per class, $2 test observations per class, and alignment processing: $3..."
  Rscript Wav_lin.R --train $1 --test $2 --alignment $3
}

# Function to train the curvelet model
train_curvelet() {
  echo "Training Curvelet model with $1 train observations per class, $2 test observations per class, and alignment processing: $3..."
  Rscript Crv_lin.R --train $1 --test $2 --alignment $3
}

# Function to train the wavelet-curvelet combined model
train_wavelet_curvelet() {
  echo "Training Wavelet-Curvelet model with $1 train observations per class, $2 test observations per class, and alignment processing: $3..."
  Rscript CW_lin.R --train $1 --test $2 --alignment $3
}





model_choice=$1
train_obs=$2
test_obs=$3
alignment_choice=$4


# echo "$0 $1 $2 $3 $4"
# echo "$model_choice"

# Call the appropriate function based on the user's choice
case $model_choice in
  1)
    train_wavelet $train_obs $test_obs $alignment_choice
    ;;
  2)
    train_curvelet $train_obs $test_obs $alignment_choice
    ;;
  3)
    train_wavelet_curvelet $train_obs $test_obs $alignment_choice
    ;;
  *)
    echo "Invalid choice! Please enter 1 for Wavelet, 2 for Curvelet, or 3 for Wavelet-Curvelet."
    ;;
esac


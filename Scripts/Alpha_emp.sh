#!/bin/bash

# Function to train the wavelet model


# Function to train the wavelet-curvelet combined model
train_wavelet_curvelet() {
  echo "Training Wavelet-Curvelet model with $1 train observations per class, $2 test observations per class, and alignment processing: $3..."
  python3 Alpha_emp.py --train $1 --test $2 --alignment $3
}

# Get user input for the number of train and test observations
echo "Enter the number of train observations per class:"
read train_obs

echo "Enter the number of test observations per class:"
read test_obs

# Get user input for model selection
echo "Choose the model to be trained:"
#echo "1 - Wavelet"
#echo "2 - Curvelet"
echo "1 - Wavelet-Curvelet"
read model_choice

# Get user input for alignment processing
echo "Use alignment processing? (Press 1 for Yes, 0 for No):"
read alignment_choice

# Call the appropriate function based on the user's choice
case $model_choice in

  1)
    train_wavelet_curvelet $train_obs $test_obs $alignment_choice
    ;;
  *)
    echo "Invalid choice! Please enter 1 for for Wavelet-Curvelet."
    ;;
esac

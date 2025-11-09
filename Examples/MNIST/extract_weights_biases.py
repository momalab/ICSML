import os
import h5py
import numpy as np

# Read Model
model = h5py.File('dense-256-512-256.h5', 'r')

# List keys
# list(f.keys())

# Get weights. Note weight matrices are transposed because the PLC ML Inference Framework reads weights that way
weights = model['model_weights']

L1_biases = np.array(weights['dense']['sequential']['dense']['bias'], dtype='float64')
L1_weights = np.array(weights['dense']['sequential']['dense']['kernel'], dtype='float64').transpose()

L2_biases = np.array(weights['dense_1']['sequential']['dense_1']['bias'], dtype='float64')
L2_weights = np.array(weights['dense_1']['sequential']['dense_1']['kernel'], dtype='float64').transpose()

L3_biases = np.array(weights['dense_2']['sequential']['dense_2']['bias'], dtype='float64')
L3_weights = np.array(weights['dense_2']['sequential']['dense_2']['kernel'], dtype='float64').transpose()

L4_biases = np.array(weights['dense_3']['sequential']['dense_3']['bias'], dtype='float64')
L4_weights = np.array(weights['dense_3']['sequential']['dense_3']['kernel'], dtype='float64').transpose()

# Create weights and biases directory
if not os.path.exists('plc_mnist_weights'):
    os.makedirs('plc_mnist_weights')

# Iterate through layers saving weights and biases as binary files of float64 numbers
for index, (weights, biases) in enumerate([(L1_weights, L1_biases), (L2_weights, L2_biases),
                                           (L3_weights, L3_biases), (L4_weights, L4_biases)]):
    weights.tofile(f"plc_mnist_weights/L{index+1}_weights.bin")
    biases.tofile(f"plc_mnist_weights/L{index+1}_biases.bin")

# ICSML
ICSML is a Machine Learning Inference Framework for ICS environments. It is built using Structured Text and is compatible with all IEC 61131-3 standard languages. Its goal is to provide the ML application engineer with a code base and structured approach for effortlessly building and deploying cross-compatible, real-time, and efficient ML solutions on PLC hardware.

## Features

### Activation Functions
ICSML provides parameterizable implementations for the following Activation Functions:
- Binary Step
- Exponential Linear Unit
- Rectified Linear Unit (ReLU)
- Leaky ReLU
- Sigmoid
- Softmax
- Swish
- Hyperbolic Tangent (Tanh)

### Math & Utility Functions
- Dot Product: Used for matrix and vector multiplications
- BINARR: abstraction to load array data from binary files. Can be used for loading weights, biases, inputs etc.
- ARRBIN: abstraction to save array data to binary files. Can be used for creating datasets, saving inference results etc.

### Layers & Data Structures
- Dense Layers: Used to create Neural Networks. Can optionally apply an activation function to their outputs.
- Concatenation Layers: Combine the outputs of their inputs and can be used to build ML models with parallel sections that branch out and merge.
- Activation Layers: Apply an activation function to their inputs.
- dataMem Data Structure: Offers a convenient way to manage Layer memory by associating memory areas with their metadata.

### Models
- Sequential: Contains a sequential Layer evaluator for feedforward ANNs.


## Documentation & Examples
Extensive Documentation for ICSML is available within the code files. A whitepaper and a centralized documentation platform are also in the works. For an example on how to port a TensorFlow-Keras model to ICSML, see the Examples folder.

## Porting
Porting ICSML to a new PLC ecosystem that adheres to the IEC 61131-3 standard is fairly easy and mostly involves copying the existing Structured Text code and pasting it into the new ecosystem's code editor. For readily available implementations of the ICSML library see the [Releases](#releases) section.

## Releases
For ICSML implementations on various PLC ecosystems take a look at the [Releases](https://github.com/momalab/ICSML/releases/) page.

## Cite ICSML
The ICSML paper will be published soon.
(*#-#-#-#-#-#-#-#-#-#---Declaration---#-#-#-#-#-#-#-#-#-#-#-#-#*)
METHOD fpass
VAR
	index: UINT;
	dot_prod: REAL;
	weight_vector: POINTER TO REAL;
END_VAR
(*#-#-#-#-#-#-#-#-#-#---Implementation---#-#-#-#-#-#-#-#-#-#-#-#-#*)
// Using accessors directly on the result of a function call is prohibited.
// Iterate over rows in the weights matrix and calculate their dot product with the input.
// Essentially this is a calculation for each neuron in the dense layer.
FOR index := 0 TO output_i.length-1 DO
	// Pointer to start of current weights row
	weight_vector := ADR(weights[index * input_i.length]);
	// Calculate dot product of weights vector with input vector
	dot_prod := DOT(weight_vector, input_i.address, input_i.length);
	// Add bias
	dot_prod := dot_prod + biases[index];
	// Assign result to output
	output_i.address[index] := dot_prod;
END_FOR

// If the activation function is not set to linear or the use of an activation parameter is set to true, apply activation function
IF (activation <> activationType.Linear) OR activation_use_parameter THEN
	applyActivation();
END_IF
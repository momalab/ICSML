(*#-#-#-#-#-#-#-#-#-#---Declaration---#-#-#-#-#-#-#-#-#-#-#-#-#*)
METHOD fpass
VAR
	// Number of channels in the input
	channels: UINT;
	// Number of elements in each channel
	channel_size: UDINT;
	// Iterator for number of channels
	channel_idx: UINT;
	
	// Iterator for input elements
	in_idx: UDINT;
	
	// Batch normalization parameters
	beta, gamma, mov_avg, mov_var: REAL;
	
	// Temporary variable
	temp: REAL;
	
END_VAR(*#-#-#-#-#-#-#-#-#-#---Implementation---#-#-#-#-#-#-#-#-#-#-#-#-#*)
// Batch Normalization Function. Uses beta, gamma, moving average and moving variance to normalize inputs uniformly or per channel.

// Calculate number of channels and the size of them
IF use_channels = TRUE THEN
	channels := input_i.dimensions[input_i.dimensions_num - 1];
	channel_size := input_i.length / channels;
ELSE
	channels := 1;
	channel_size := input_i.length;
END_IF

// Iterate over number of channels
FOR channel_idx := 0 TO channels-1 DO
	// Get parameters
	beta := weights[channel_idx * 4];
	gamma := weights[channel_idx * 4 + 1];
	mov_avg := weights[channel_idx * 4 + 2];
	mov_var := weights[channel_idx * 4 + 3];
	
	// Iterate over input elements applying batch normalization
	FOR in_idx := 0 TO channel_size-1 DO
		temp := gamma * (input_i.address[channel_idx * channel_size + in_idx] - mov_avg) / SQRT(mov_var) + beta;
		output_i.address[channel_idx * channel_size + in_idx] := temp;
	END_FOR
	
END_FOR;

// If the activation function is not set to linear or the use of an activation parameter is set to true, apply activation function
IF (activation <> activationType.Linear) OR activation_use_parameter THEN
	applyActivation(activationType.ReLU); //probably need to change this in the future.
END_IF;
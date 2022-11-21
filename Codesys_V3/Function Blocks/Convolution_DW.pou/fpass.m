(*#-#-#-#-#-#-#-#-#-#---Declaration---#-#-#-#-#-#-#-#-#-#-#-#-#*)
METHOD fpass
VAR
	out_size: UINT;
	index_f: UINT; //filter numebr
	filt_row_n: UINT;
	curr_depth: UINT;
	curr_row: UINT;
	curr_col: UINT;
	out_row: UINT;
	out_col: UINT;
	dot_prod: REAL;
	conv_sum: REAL;
	weight_vector: POINTER TO REAL;
	input_vector: POINTER TO REAL;
	temp: UINT;
END_VAR(*#-#-#-#-#-#-#-#-#-#---Implementation---#-#-#-#-#-#-#-#-#-#-#-#-#*)
// Calculate number of filters
num_filt:=input_i.dimensions[input_i.dimensions_num - 1];

// out_size := (input_i.dimensions[0]-filt_size)/stride + 1; // Calculating output size

temp := input_i.dimensions[0]-filt_size;
IF (input_i.dimensions[0]-filt_size) MOD stride > 0 THEN
	temp := temp - (temp MOD stride) + stride;
END_IF

out_size := REAL_TO_UINT( temp / stride + 1); //Calculating output size

// Iterate over filters and input channels. In depthwise convolution we have 1 filter per channel
FOR index_f:= 0 TO num_filt-1 DO
	curr_row := 0;
	out_row := 0;
	// Slide the filter vertically over the image
	WHILE (curr_row + filt_size) <= input_i.dimensions[0] DO
		curr_col := 0;
		out_col := 0;
		// Slide the filter horizontally over the image
		WHILE (curr_col + filt_size) <= input_i.dimensions[1] DO
			// Convolution result
			conv_sum := 0;
			
			// Iterate over filter rows calculating dot product of each row with the corresponding input row
			FOR filt_row_n := 0 TO filt_size-1 DO //Dot product row by row. Count is the row number of the specific filter.
				weight_vector := ADR(weights[index_f*filt_size*filt_size + filt_row_n*filt_size]);
				// Sum components in address index: (1) to locate the filter start in memory, (2) to locate the starting row position, (3) to locate the column, (4) to skip ahead to the specific row
				input_vector := ADR(input_i.address[index_f * input_i.dimensions[0] * input_i.dimensions[1] + curr_row * input_i.dimensions[1] + curr_col + filt_row_n * input_i.dimensions[1]]);
				conv_sum := conv_sum + DOT(weight_vector, input_vector, filt_size);
			END_FOR;

// 			dot_prod := dot_prod + biases[index_f]; //Adding bias to dot product
			output_i.address[index_f*out_size*out_size + out_row*out_size + out_col] := conv_sum; // Storing sum of dot products to output
			
			curr_col := curr_col + stride; //Incrementing current column by stride
			out_col := out_col + 1; // Increment output column by 1
		END_WHILE;
		curr_row := curr_row + stride; //Incrementing current row by stride
		out_row := out_row + 1;
	END_WHILE;
END_FOR;

// If the activation function is not set to linear or the use of an activation parameter is set to true, apply activation function
IF (activation <> activationType.Linear) OR activation_use_parameter THEN
	applyActivation(activationType.ReLU); //probably need to change this in the future.
END_IF;
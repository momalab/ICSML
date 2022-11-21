(*#-#-#-#-#-#-#-#-#-#---Declaration---#-#-#-#-#-#-#-#-#-#-#-#-#*)
METHOD fpass
VAR
	out_size: UINT;
	index_f: UINT; //filter numebr
	count: UINT;
	curr_depth: UINT;
	curr_row: UINT;
	curr_col: UINT;
	out_row: UINT;
	out_col: UINT;
	dot_prod: REAL;
	weight_vector: POINTER TO REAL;
	input_vector: POINTER TO REAL;
	temp: UINT;
END_VAR(*#-#-#-#-#-#-#-#-#-#---Implementation---#-#-#-#-#-#-#-#-#-#-#-#-#*)
//Convolution Function. Note that the weights are stored in a specific way. For details, look at the Python code of storing convolution layer weights.

temp := input_i.dimensions[0]-filt_size;
IF (input_i.dimensions[0]-filt_size) MOD stride > 0 THEN
	temp := temp - (temp MOD stride) + stride;
END_IF

out_size := REAL_TO_UINT( temp / stride + 1); //Calculating output size

FOR index_f:= 0 TO num_filt-1 DO //Traversing through all filters
	curr_row := 0;
	out_row := 0;
	WHILE (curr_row + filt_size) <= input_i.dimensions[0] DO //Sliding filter vertically until end of image
		curr_col := 0;
		out_col := 0;
		WHILE (curr_col + filt_size) <= input_i.dimensions[0] DO //Sliding filter horizontally until end of image
			
			IF input_i.dimensions[2] = 1 THEN //Case when input is single depth - i.e has a single channel
				FOR count := 0 TO filt_size-1 DO //Dot product row by row. Count is the row number of the specific filter.
					weight_vector := ADR(weights[index_f*filt_size*filt_size + count*filt_size]);
					input_vector := ADR(input_i.address[curr_row*input_i.dimensions[0] + curr_col + count*input_i.dimensions[0]]);
					dot_prod := dot_prod + DOT(weight_vector, input_vector, filt_size);
				END_FOR;
			ELSE //Case when input has multiple channels
				FOR curr_depth := 0 TO input_i.dimensions[2]-1 DO // Iterate over channels
					FOR count := 0 TO filt_size-1 DO //Dot product row by row. Count is the row number of the specific filter.
						weight_vector := ADR(weights[index_f*input_i.dimensions[2]*filt_size*filt_size + curr_depth*filt_size*filt_size + count*filt_size]);
						input_vector := ADR(input_i.address[curr_depth*input_i.dimensions[0]*input_i.dimensions[0] + curr_row*input_i.dimensions[0] + curr_col + count*input_i.dimensions[0]]);
						dot_prod := dot_prod + DOT(weight_vector, input_vector, filt_size);
					END_FOR;
				END_FOR;
			END_IF;
			dot_prod := dot_prod + biases[index_f]; //Adding bias to dot product
			output_i.address[index_f*out_size*out_size + out_row*out_size + out_col] := dot_prod; //Storing dot product to output
			dot_prod := 0;
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
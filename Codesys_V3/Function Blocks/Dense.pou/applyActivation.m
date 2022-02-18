(*#-#-#-#-#-#-#-#-#-#---Declaration---#-#-#-#-#-#-#-#-#-#-#-#-#*)
METHOD PRIVATE applyActivation : REAL
VAR
	index: UINT;
END_VAR

(*#-#-#-#-#-#-#-#-#-#---Implementation---#-#-#-#-#-#-#-#-#-#-#-#-#*)
// Apply defined activation with desired activation parameter (if set)
CASE activation OF
	activationType.Linear:
		FOR index := 0 TO output_i.length DO
			output_i.address[index] := LIN(output_i.address[index], activation_parameter);
		END_FOR
	activationType.Binary:
		FOR index := 0 TO output_i.length DO
			output_i.address[index] := BSTEP(output_i.address[index]);
		END_FOR
	activationType.Sigmoid:
		FOR index := 0 TO output_i.length DO
			output_i.address[index] := SIG(output_i.address[index]);
		END_FOR
	activationType.Tanh:
		FOR index := 0 TO output_i.length DO
			output_i.address[index] := TANH(output_i.address[index]);
		END_FOR
	activationType.ReLU:
		FOR index := 0 TO output_i.length DO
			IF activation_use_parameter THEN
				output_i.address[index] := RELU(output_i.address[index], activation_parameter);
			ELSE
				output_i.address[index] := RELU(output_i.address[index]);
			END_IF
		END_FOR
	activationType.LReLU:
		FOR index := 0 TO output_i.length DO
			output_i.address[index] := LRELU(output_i.address[index]);
		END_FOR
	activationType.ELU:
		FOR index := 0 TO output_i.length DO
			IF activation_use_parameter THEN
				output_i.address[index] := ELU(output_i.address[index], activation_parameter);
			ELSE
				output_i.address[index] := ELU(output_i.address[index]);
			END_IF
		END_FOR
	activationType.Swish:
		FOR index := 0 TO output_i.length DO
			output_i.address[index] := SWISH(output_i.address[index]);
		END_FOR
	activationType.Softmax:
		SOFTMAX(output_i.address, output_i.address, output_i.length);
END_CASE
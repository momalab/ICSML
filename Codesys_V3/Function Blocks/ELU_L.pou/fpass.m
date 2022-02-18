(*#-#-#-#-#-#-#-#-#-#---Declaration---#-#-#-#-#-#-#-#-#-#-#-#-#*)
METHOD fpass
VAR
	index: UINT;
END_VAR
(*#-#-#-#-#-#-#-#-#-#---Implementation---#-#-#-#-#-#-#-#-#-#-#-#-#*)
// Calculate result of ELU function for each element and write it to output dataMem address
FOR index := 0 TO input_i.length-1 DO
	output_i.address[index] := ELU(input_i.address[index], alpha_i);
END_FOR
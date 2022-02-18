(*#-#-#-#-#-#-#-#-#-#---Declaration---#-#-#-#-#-#-#-#-#-#-#-#-#*)
METHOD fpass
VAR
	index: UINT;
END_VAR
(*#-#-#-#-#-#-#-#-#-#---Implementation---#-#-#-#-#-#-#-#-#-#-#-#-#*)
// Calculate result of binary step function for each element and write it to output dataMem address
FOR index := 0 TO input_i.length-1 DO
	output_i.address[index] := BSTEP(input_i.address[index]);
END_FOR

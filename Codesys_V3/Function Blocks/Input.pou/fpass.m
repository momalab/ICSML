(*#-#-#-#-#-#-#-#-#-#---Declaration---#-#-#-#-#-#-#-#-#-#-#-#-#*)
METHOD fpass
VAR
	index: UINT;
END_VAR
(*#-#-#-#-#-#-#-#-#-#---Implementation---#-#-#-#-#-#-#-#-#-#-#-#-#*)
// Simply copy external input to output dataMem address
// More advanced data preprocessing can be done here in a custom Input Layer implementation
FOR index := 0 TO input_i.length-1 DO
	output_i.address[index] := input_i.address[index];
END_FOR
(*#-#-#-#-#-#-#-#-#-#---Declaration---#-#-#-#-#-#-#-#-#-#-#-#-#*)
METHOD fpass
VAR
	// Number of dimensions of the two input arrays
	dimensions_num: UINT;
	
	// Index of upwards dimensions
	dim_index: UINT;
	
	// Number of elements in subspace defined by the axis and downwards/later dimensions for each array
	block_size_1: DWORD := 1;
	block_size_2: DWORD := 1;
	
	// Times to run combined copy loop
	loop_times: UINT := 1;
	
	// Loop index
	loop_idx: UINT := 0;
	
	// Read heads for Input 1 & 2
	
	// Index to writing point of output array
	out_write_head: UINT := 0;
	
END_VAR
(*#-#-#-#-#-#-#-#-#-#---Implementation---#-#-#-#-#-#-#-#-#-#-#-#-#*)
// Number of dimensions of the two input arrays
dimensions_num := input_i.dimensions_num;

// Current & Downwards / Lower Dimensions Block size
FOR  dim_index := axis_i TO dimensions_num - 1 DO
	block_size_1 := block_size_1 * input_i.dimensions[dim_index];
	block_size_2 := block_size_2 * input2_i.dimensions[dim_index];
END_FOR

// Total times to loop and copy blocks. Defined by common upwards dimensions.
FOR dim_index := 0 TO axis_i-1 DO
	loop_times := loop_times * input_i.dimensions[dim_index];
END_FOR

// Copy Blocks
FOR loop_idx := 0 TO loop_times-1 DO
	// Copy block from Array 1
	SysMem.SysMemCpy(ADR(output_i.address[loop_idx * (block_size_1 + block_size_2)]), ADR(input_i.address[loop_idx * block_size_1]), block_size_1 * SIZEOF(REAL)); 
	
	// Copy block from Array 2
	SysMem.SysMemCpy(ADR(output_i.address[loop_idx * (block_size_1 + block_size_2) + block_size_1]), ADR(input2_i.address[loop_idx * block_size_2]), block_size_2 * SIZEOF(REAL));
END_FOR
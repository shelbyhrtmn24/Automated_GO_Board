`timescale 1ns/100ps
module bitwise_or_tb;

	// Module Inputs
	reg[31:0] A = 0, 
			  B = 0; 

	// Expected Module Inputs
	reg[31:0] ExpRes = 0;

	// Module outputs
	wire[31:0] Res;

	// Instantiate the module
	bitwise_or OrTest(
		.data_operandA(A), .data_operandB(B), 
        .data_result(Res));

	// Initialize our strings
	reg[127:0] paramFileName, expFileName, diffFileName, actFileName, testName;

	// Where to store file error codes
	integer 	paramFile, 	   expFile,		diffFile, 	  actFile,
				paramScan,	   expScan;

	// Metadata
	integer errors = 0,
			tests = 0;

	initial begin

		// Assign Command Line Arguments to the Inputs
		if(! $value$plusargs("test=%s", testName)) begin
			$display("Please specify the test");
			$finish;
		end

		// Output file name
        $dumpfile({testName, ".vcd"});
        // Module to capture and what level, 0 means all wires
        $dumpvars(0, bitwise_or_tb);

		// Create the names for the files we are using
		expFileName =   {testName, "_exp.csv"};
		actFileName =   {testName, "_actual.csv"};
		diffFileName =  {testName, "_diff.csv"};

		// Read the expected file
		expFile = $fopen(expFileName, "r");

		// Check for any errors in opening the file
		if(!expFile) begin
			$display("Couldn't read the output file.",
				"\nMake sure you are in the right directory and the %0s_exp.csv file exists.", testName);
			$display("%0s", expFileName);
			$finish;
		end

		// Create the files to store the output
		actFile   = $fopen(actFileName,  "w");
		diffFile  = $fopen(diffFileName,  "w");

		// Add the headers to the Actual and Difference files
		$fdisplay(actFile, "A, B, Result");
		$fdisplay(diffFile, "Test Number, A, B, Result ",
			"Expected Result");

		// Ignore the header of the Expected file
		expScan = $fscanf(expFile, "%s,%s,%s", 
			A, B,ExpRes);

		if(expScan == 0) begin
			$display("Error reading the %0s file.\nMake sure there are no spaces ANYWHERE in your file.\nYou can check by opening it in a text editor.", expFileName);
			$finish;
		end

		$dumpfile({testName, ".vcd"});
		$dumpvars(0, bitwise_or_tb);

		// Get the input for the parameters from the input file
		expScan = $fscanf(expFile, "%d,%d,%d",
			A, B, ExpRes);

		if(expScan != 3) begin
			$display("Error reading %0s\nMake sure there are no spaces ANYWHERE in your file.\nYou can check by opening it in a text editor.", expFileName);
			$finish;
		end

		// Iterate until reaching the end of the file
		while(expScan == 3) begin

			#10;

			tests = tests + 1;

			// Write the actual module outputs to the actual file
			$fdisplay(actFile, "%d,%d,%d",
				$signed(A), $signed(B), 
				$signed(Res));

			// Check for any inaccuracies in the module output and the expected output
			if((Res !== ExpRes)) begin

				// Increment the Errors
				errors = errors + 1;

				// Output any differences to the difference file
				$fdisplay(diffFile, "%0d,%d,%d,%d,%d",
					tests, $signed(A), $signed(B), $signed(Res),
					$signed(ExpRes));

				$display("Test %3d: FAILED", tests);
			end else begin
				$display("Test %3d: PASSED", tests);
			end

			// Get the input for the parameters from the input file
			expScan = $fscanf(expFile, "%d,%d,%d",
				A, B, ExpRes);
		end

		if (expScan > 0) begin
			$display("Testbench ended prematurely, please check test %0d", tests+1);
			$finish;
		end

		// Close the Files
		$fclose(expFile);
		$fclose(actFile);
		$fclose(diffFile);

		// Display the tests and errors
		$display("Finished %0d test%c with %0d error%c", tests, "s"*(tests != 1), errors, "s"*(errors != 1));

		#100;
		$finish;
	end
endmodule
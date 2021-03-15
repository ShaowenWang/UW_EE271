module series_dffs (clk, reset, d1, q1);
	input logic clk, reset, d1;
	output logic q1;
	logic n1;
	
	
	
	
always_ff @(posedge clk)
	begin
	if (reset)
		begin
			n1 <= 0; 
			q1 <= 0;
		end
	else
		n1 <= d1; // nonblocking
		q1 <= n1; // nonblocking
		
	end
endmodule








module series_dffs_testbench();
	logic clk, reset, d1;
	logic q1;

		series_dffs dut (clk, reset, d1, q1);
		
		// Set up a simulated clock.
		parameter CLOCK_PERIOD=100;
		initial begin
			clk <= 0;
			forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
			
		end
		
		
		// Set up the inputs to the design. Each line is a clock cycle.
		initial begin
											@(posedge clk);
											@(posedge clk);
			reset <= 1;					@(posedge clk); // Always reset FSMs at start
		reset <= 0; d1 <= 0;  		@(posedge clk);
											@(posedge clk);
											@(posedge clk);
											@(posedge clk);
			 d1 <= 1; 	  repeat(3) @(posedge clk);
			 d1 <= 0; 	  repeat(3) @(posedge clk);
			 d1 <= 1; 	  repeat(3)	@(posedge clk);
											@(posedge clk);
			 d1 <= 0;					@(posedge clk);
											@(posedge clk);
											@(posedge clk);
											@(posedge clk);
			$stop; // End the simulation.
		end
endmodule 

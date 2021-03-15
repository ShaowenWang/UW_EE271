module getBonus (clk, reset, in, out);
	input logic clk, reset, in;
	output logic out;


	// State variables
	enum { none, get } ps, ns;
	
	// Next State logic
	always_comb begin
		case (ps)
			none: if (in) ns = get;
			
						else ns = none;
						
			get:  if(!in) ns = none;
						else ns = get;
						
			
						
		endcase
	end
	
	// Output logic - could also be another always_comb block.
	assign out = (in) &&((ps == none) && (ns == get));
	
	// DFFs
	always_ff @(posedge clk) begin
		if (reset)
		
			ps <= none;
			
		else
		
			ps <= ns;
			
		end
		
endmodule








module getBonus_testbench();
logic clk, reset, in;
logic out;

		getBonus dut (clk, reset, in, out);
		
		// Set up a simulated clock.
		parameter CLOCK_PERIOD=100;
		initial begin
			clk <= 0;
			forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
			
		end
		
		
		// Set up the inputs to the design. Each line is a clock cycle.
		initial begin
											@(posedge clk);
			reset <= 1;					@(posedge clk); // Always reset FSMs at start
		reset <= 0; in <= 0;  		@(posedge clk);
											@(posedge clk);
											@(posedge clk);
											@(posedge clk);
			 in <= 1; 					@(posedge clk);
								         @(posedge clk);
			          					@(posedge clk);
			 in <= 1;					@(posedge clk);
											@(posedge clk);
											@(posedge clk);
			          				   @(posedge clk);
			 in <= 0;					@(posedge clk);
											@(posedge clk);
			       						@(posedge clk);
											@(posedge clk);
			 in <= 0;					@(posedge clk);
											@(posedge clk);
											@(posedge clk);
			$stop; // End the simulation.
		end
endmodule

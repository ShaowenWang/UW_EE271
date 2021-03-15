module centerLight (clk, rst, L, R, NL, NR, light);
	input logic clk, rst, L, R, NL, NR;
	output logic light;
	
	enum {on, off} ps, ns;
	
	always_comb begin
			case (ps)
				off: if (NR && L && !NL && !R) ns = on;
					  else if (NL && R && !NR && !L) ns = on;
					  else ns = off;
					  
				on:  if (!NR && !NL && !R && L) ns = off;
				     else if (!NR && !NL && !L && R) ns = off;
					  else ns = on;
			endcase
	end 
	
	assign light = (ps == on);
	
	always_ff @(posedge clk) begin
		if (rst)  
			ps <= on;
		
		else 
			ps <= ns;
	end 
endmodule 




module centerLight_testbench();
	logic clk, rst, NL, NR, L, R;
	logic light;

		centerLight dut (clk, rst, L, R, NL, NR, light);
		
		// Set up a simulated clock.
		parameter CLOCK_PERIOD=100;
		initial begin
			clk <= 0;
			forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
			
		end
		
		
		// Set up the inputs to the design. Each line is a clock cycle.
	initial begin
																					@(posedge clk);
			rst <= 1;															@(posedge clk); // Always reset FSMs at start
		rst <= 0; NL <= 0; NR <= 0; L <= 0; R <= 0;  	 			@(posedge clk);
																					@(posedge clk);
																					@(posedge clk);
																					@(posedge clk);
			NL <= 0; NR <= 0; L <= 1; R <= 0;						   @(posedge clk);
																		         @(posedge clk);
			NL <= 0; NR <= 0; L <= 0; R <= 1;			  				@(posedge clk);
																					@(posedge clk);
			NL <= 1; NR <= 0; L <= 0; R <= 0;							@(posedge clk);
																					@(posedge clk);
			NL <= 1; NR <= 0; L <= 0; R <= 1;							@(posedge clk);
																					@(posedge clk);
					                                                @(posedge clk);
																					@(posedge clk);
			NL <= 0; NR <= 1; L <= 0; R <= 0;							@(posedge clk);
																	         	@(posedge clk);
			NL <= 0; NR <= 1; L <= 1; R <= 0;							@(posedge clk);
			                                                      @(posedge clk);
																					@(posedge clk);
		
			$stop; // End the simulation.
		end
endmodule



















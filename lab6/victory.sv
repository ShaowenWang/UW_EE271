module victory (clk, rst, L, R, edgelight_L, edgelight_R, display);
	input logic clk, rst,  L, R;
	input logic edgelight_L, edgelight_R ;
	output logic [6:0]display;
	
	parameter ONE = 7'b1111001;   // 1
	parameter TWO = 7'b0100100;   // 2
	parameter blank  = 7'b1111111; // blank
	
	enum{going, onewin, twowin}ps,ns;
	always_comb begin
		case (ps)
			going: if (!edgelight_L && edgelight_R && !L && R) ns = onewin;
			
					 else if(edgelight_L && !edgelight_R && L && !R) ns = twowin;
			
						else ns = going;
						
			onewin:  ns = onewin;
			twowin:  ns = twowin;
						
			
						
		endcase
	end
	
	
	
	
	// Output logic 
	
	always_comb begin
		case(ps)
			onewin: display = ONE;
					
			
			twowin:  display = TWO;
				
						
			going: display = blank;
		endcase
	end
	
	
	
	always_ff @(posedge clk) begin
		if (rst)
		
			ps <= going;
			
			
		else
		
			ps <= ns;
			
		end
			
		
endmodule








module victory_testbench();
 logic clk, rst, L, R;
 logic edgelight_L, edgelight_R;
 logic [6:0]display;

		victory dut (clk, rst, L, R, edgelight_L, edgelight_R, display);
		
		// Set up a simulated clock.
		parameter CLOCK_PERIOD=100;
		initial begin
			clk <= 0;
			forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
			
		end
		
		
		// Set up the inputs to the design. Each line is a clock cycle.
		initial begin
																										@(posedge clk);
			rst <= 1;																				@(posedge clk); // Always reset FSMs at start
			rst <= 0; edgelight_L <= 0; edgelight_R <= 0; L <= 0; R <= 0;  	 				@(posedge clk);
																										@(posedge clk);
			edgelight_L <= 1; edgelight_R <= 0; L <= 1; R <= 0;						@(posedge clk);
																										@(posedge clk);
																										@(posedge clk);
			edgelight_L <= 0; edgelight_R <= 0; L <= 1; R <= 0;	repeat(2)		@(posedge clk);
			rst <= 1;																				@(posedge clk);
			rst <= 0;edgelight_L <= 0; edgelight_R <= 1; L <= 0; R <= 1;	repeat(2)	   @(posedge clk);
			                                                      	 				@(posedge clk);
			edgelight_L <= 0; edgelight_R <= 0; L <= 0; R <= 1;			  			@(posedge clk);
																										@(posedge clk);

			$stop; // End the simulation.
		end
endmodule

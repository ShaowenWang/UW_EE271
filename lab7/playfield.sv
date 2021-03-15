module playfield (clk, rst, L, R, leds);
	input logic clk, rst,  L, R;
	output logic [8:0]leds;
  

	
	genvar i;
	generate
		for(i = 0; i < 9; i++) begin : eachLight
				// The right edge light
				if (i == 0)
						normalLight led (.clk, .rst, .L, .R, .NL(leds[i+1]), .NR(1'b0), .light(leds[i]));
						
				// The center light
				else if (i == 4)
				      centerLight led (.clk, .rst, .L, .R, .NL(leds[i+1]), .NR(leds[i-1]), .light(leds[i]));
				
				// The left edge light
				else if (i == 8)
						normalLight led (.clk, .rst, .L, .R, .NL(1'b0), .NR(leds[i-1]), .light(leds[i]));
				
				// Any other light
				else
						normalLight led (.clk, .rst, .L, .R, .NL(leds[i+1]), .NR(leds[i-1]), .light(leds[i]));
						
				
		end
	endgenerate
	

		
endmodule
	
	
	
	
	
	
	
	
	
	
	
module playfield_testbench();
	logic clk, rst, L, R;
	
	logic [8:0] leds;
	
	
	playfield dut (clk, rst, L, R, leds);
	
		// Set up a simulated clock.
		parameter CLOCK_PERIOD=100;
		initial begin
			clk <= 0;
			forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
			
		end
	
		// Set up the inputs to the design. Each line is a clock cycle.
		initial begin
																@(posedge clk);
		rst <= 1;								    		@(posedge clk); // Always reset FSMs at start
		              				                  @(posedge clk);
																@(posedge clk);
		rst <= 0; L <= 0; R <= 1;						@(posedge clk);
																@(posedge clk);
																@(posedge clk);
		          L	<= 0; R <= 1;						@(posedge clk);
																@(posedge clk);
																@(posedge clk); 
					 L <= 0; R <= 1;						@(posedge clk);
																@(posedge clk);
																@(posedge clk);
					 L <= 0; R <= 1;						@(posedge clk);
																@(posedge clk);
																@(posedge clk);
					 L <= 1; R <= 0;						@(posedge clk)								
																@(posedge clk);
																@(posedge clk); 
																@(posedge clk);
																@(posedge clk);
																@(posedge clk);
																@(posedge clk);
																@(posedge clk);
																@(posedge clk);
																@(posedge clk);
																@(posedge clk); 
																@(posedge clk);
																@(posedge clk);
																@(posedge clk);
																@(posedge clk);
																@(posedge clk);														
																
																
		
			$stop; // End the simulation.
		end
endmodule

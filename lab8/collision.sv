module collision (clk, rst, GrnPixels, RedPixels, gameover);
		
		input logic clk, rst;
		input logic [15:0][15:0] GrnPixels;
		input logic [15:0][15:0] RedPixels;
		output logic gameover; // output true if gameover
		
		int i, j;
		logic [15:0][15:0] overlap;
		logic result;

	assign  overlap = GrnPixels & RedPixels;
	assign result = | overlap;
	
		
			always_ff @ (posedge clk) begin
					if (rst) begin
							
							gameover <= 0;
							
							
					end else  begin 
							gameover <= result;

					end
							
			
				  
			end



endmodule






module collision_testbench();
	logic clk, rst;
	logic [15:0][15:0] GrnPixels;
	logic [15:0][15:0] RedPixels;
	logic gameover;
	
	int i, j;
	logic [15:0][15:0] overlap;
	logic result;

	collision dut (.clk, .rst, .GrnPixels, .RedPixels, .gameover);
	
	 
				// Set up a simulated clock.
				parameter CLOCK_PERIOD=100;
				initial begin
							clk <= 0;
							forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
				end

				initial begin
																																																		@(posedge clk); 
			rst <= 1; GrnPixels = '0; 				RedPixels = '0;																														@(posedge clk); // Always reset at start
			rst <= 0; GrnPixels[4][12] = 1'b1; GrnPixels[3][12] = 1'b1;	RedPixels[5][12] = 1'b1; RedPixels[6][12] = 1'b1;											@(posedge clk); // Test arbitary case 1: at col 12, the right 2 redPixle just pass over
																																																	   @(posedge clk);
			rst <= 1; GrnPixels[4][12] = 1'b0; GrnPixels[3][12] = 1'b0;	RedPixels[5][12] = 1'b0; RedPixels[6][12] = 1'b0;											@(posedge clk); // Always reset at start
			rst <= 0; GrnPixels[4][13] = 1'b1; GrnPixels[3][13] = 1'b1;	RedPixels[4][13] = 1'b1; RedPixels[5][13] = 1'b1;											@(posedge clk);// Test arbitary case 2: at col 13, the upperleft redPixel hit.
																																																		@(posedge clk);
			rst <= 1;GrnPixels[4][13] = 1'b0; GrnPixels[3][13] = 1'b0;	RedPixels[4][13] = 1'b0; RedPixels[5][13] = 1'b0;											@(posedge clk); // Always reset at start
			rst <= 0; GrnPixels[6][12] = 1'b1; GrnPixels[5][12] = 1'b1;	RedPixels[6][12] = 1'b1; RedPixels[7][12] = 1'b1;											@(posedge clk); // Test arbitary case 3: at col 12, the upper right redPixel hit
																																																	   @(posedge clk);
			rst <= 1;GrnPixels[6][12] = 1'b0; GrnPixels[5][12] = 1'b0;	RedPixels[6][12] = 1'b0; RedPixels[7][12] = 1'b0;											@(posedge clk); // Always reset at start
			rst <= 0; GrnPixels[6][12] = 1'b1; GrnPixels[5][12] = 1'b1;	RedPixels[5][12] = 1'b1; RedPixels[6][12] = 1'b1;											@(posedge clk); // Test arbitary case 4: at col 12, the both redPixel hit
																																																	   @(posedge clk);
			rst <= 1; GrnPixels[6][12] = 1'b0; GrnPixels[5][12] = 1'b0;	RedPixels[5][12] = 1'b0; RedPixels[6][12] = 1'b0;											@(posedge clk); // Always reset at start
			rst <= 0; GrnPixels[11][12] = 1'b1; GrnPixels[12][12] = 1'b1;	RedPixels[10][12] = 1'b1; RedPixels[11][12] = 1'b1;									@(posedge clk); // Test arbitary case 5: at col 12, a random bottom redPixel hit
																																																	   @(posedge clk);

				 $stop; // End the simulation.
				end
endmodule

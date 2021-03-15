module pipe_generator #(parameter SHIFT_THRESHOLD = 300, // default speed (pixel/s),  default SHIFT_THRESHOLD=70, used 20 in demo ,  
					parameter  GAP = 10) // default 7 pixels
					(clk, rst, gameover,  GrnPixels);

				
		input logic clk, rst, gameover;

		output logic [15:0][15:0] GrnPixels;
		
		logic [15:0] pipe_pattern;
		
		pipe_picker pick (.clk, .rst, .pattern(pipe_pattern[15:0]));	//generate a new colomn

		int shift, gap_btwn, i, j; // internal timing counters
		
			always_ff @ (posedge clk) begin
					if (rst) begin

							shift  <= 0;
							gap_btwn	<= 0;
							GrnPixels <= '0;
					end
					else begin
							 
							if(gameover) begin                             

												GrnPixels <= GrnPixels;//maintain where it is if the game is over
												
							
						
							end else begin                                   
												shift <= shift + 1;
												
												if (shift == SHIFT_THRESHOLD) begin

															gap_btwn <= gap_btwn + 1;
															shift <= 0;
															
															
															for (i=0; i < 16; i++)begin
															
																	for (j =1; j<16; j++) begin
																		GrnPixels[i][j] <= GrnPixels [i][j-1];                               // shifting colomn 1~14 to the left.
																		
																	end
																	
																	if (gap_btwn == GAP) begin


																				
																				GrnPixels[i][0] <= pipe_pattern[i];   //generate piper                         
																				gap_btwn <= 0;
																	end else begin
																				GrnPixels[i][0] <= 1'b0;                                       // turn off the rightmost colomn
																				
																	end
															
															end
															
												end
							
							end
							
							
							
				  end
			end
			
			
			

endmodule











module pipe_generator_testbench();
	logic clk, rst, gameover;
	logic [15:0][15:0] GrnPixels;
	logic [15:0] pipe_pattern;
	int shift, gap_btwn, i, j;

	 pipe_generator #(.SHIFT_THRESHOLD(70), .GAP(7))  dut (.clk, .rst, .gameover, .GrnPixels);
	
	 
				// Set up a simulated clock.
				parameter CLOCK_PERIOD=100;
				initial begin
							clk <= 0;
							forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
				end

				initial begin
																				@(posedge clk); 
			rst <= 1;  gameover <= 0;									@(posedge clk); 		// Always reset at start
			rst <= 0;									  repeat(1800) @(posedge clk); 		// Test case : if different pipes would be generated in certain amount of shift_threshold and gap.
			rst <= 1;														@(posedge clk); 
			rst <= 0; 					              repeat(1600) @(posedge clk); 	  	
			rst <= 1; 				 										@(posedge clk);	 
			rst <= 0; gameover <= 1;				  repeat(1600) @(posedge clk); 		
			rst <= 1;														@(posedge clk); 
			
				 $stop; // End the simulation.
				end
endmodule

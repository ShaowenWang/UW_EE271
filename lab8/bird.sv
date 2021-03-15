module bird #(parameter FLY_THRESHOLD = 120, parameter GRAV_THRESHOLD = 200) 
					(clk, rst, button, gameover, position);
	input logic clk, rst, button, gameover;
	output int position; // 0 is top 14 is bottom
	
	int gravity, fly;
	
	always_ff @ (posedge clk) begin
					if (rst) begin
							position <= 5; // slightly above halfway up the board
							gravity  <= 0;
							fly 		<= 0;
					end
					else begin
							 
							if(gameover) begin                             // if gameover, maintain position
												position <= position;
	
							end else if(position == 14 & !button) begin    // else if at bottom edge and no button, maintain position											
												position <= position;					
							
							end else if(position == 0 & button) begin      // else if at top edge and button, maintain position											
												position <= position;
							
							end else if(button) begin                     // else if button, fly up
												fly <= fly +1;
												if (fly == FLY_THRESHOLD) begin
															position <= position - 1;
															fly <= 0;			
												end
							
							end else begin                                   // else (if no button, gravity pulls down)
												gravity <= gravity + 1;
												if (gravity == GRAV_THRESHOLD) begin
															position <= position + 1;
															gravity <= 0;
														
												end
							
							end
				  end
			end
endmodule















module bird_testbench();
	logic clk, rst, button, gameover;
	int position;

	 bird #(.FLY_THRESHOLD(100), .GRAV_THRESHOLD(150)) dut (.clk, .rst, .button, .gameover, .position);
	 
				// Set up a simulated clock.
				parameter CLOCK_PERIOD=100;
				initial begin
							clk <= 0;
							forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
				end

				initial begin
																				@(posedge clk); 
			rst <= 1; button <=0; gameover <= 0;					@(posedge clk); 		// Always reset at start
			rst <= 0;									  repeat(1800) @(posedge clk); 		// Test case 1: gravity, ensure bird doesn’t fall off bottom
			rst <= 1;														@(posedge clk); 
			rst <= 0; button <= 1;                repeat(1600) @(posedge clk); 	  	// Test case 2: fly, ensure bird doesn’t fly above top
			rst <= 1; 				 										@(posedge clk);
			rst <= 0; gameover <= 1;button <= 1;	repeat(36)	@(posedge clk);
																				@(posedge clk); 
			rst <= 0; gameover <= 1;button <= 0;					@(posedge clk); 
			rst <= 0; gameover <= 1;				  repeat(1600) @(posedge clk); 		// Test case 3: gameover (freeze)
			rst <= 1;														@(posedge clk); 
			
				 $stop; // End the simulation.
				end
endmodule

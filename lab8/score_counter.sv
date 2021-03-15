module score_counter (clk, rst, GrnPixels, gameover, ten_digit, one_digit  );
		
		input logic clk, rst, gameover;
		input logic [15:0][15:0] GrnPixels;
		output logic [3:0] ten_digit; // count the ten digit
		output logic [3:0] one_digit; // count the unit digit (lowest digit)
		
		

		

	
	logic increment, buffered_incre;
	
	assign increment = (GrnPixels[0][14] == 1'b1 | GrnPixels[15][14] == 1'b1);
	// buffer the increment 
	
	enum { none, got_one } ps, ns;
	
	// Next State logic
	always_comb begin
		case (ps)
			none: if (increment) ns = got_one;
			
						else ns = none;
						
			got_one:  if(!increment) ns = none;
						else ns = got_one;
						
			
						
		endcase
	end
	
	// Output logic - could also be another always_comb block.
	assign buffered_incre = ((ps == none) && (ns == got_one));
	
	// DFFs
	always_ff @(posedge clk) begin
		if (rst)
		
			ps <= none;
			
		else
		
			ps <= ns;
			
		end

	
	
		
			always_ff @ (posedge clk) begin
//		always_comb begin
					if (rst) begin
							
							ten_digit <= 4'b0000;
							one_digit <= 4'b0000;
							
					end else if(buffered_incre & ten_digit == 4'b1001 & one_digit == 4'b1001 &!gameover) begin // if reached 99
					
									 ten_digit <= 4'b1001;
									 one_digit <= 4'b1001;
					
							
					end else if(buffered_incre & ten_digit != 4'b1001 & one_digit == 4'b1001 & !gameover) begin // if reached 09, 19, ......, 89.
					
									 ten_digit <= ten_digit + 4'b0001;
									 one_digit <= 4'b0000;
					
					end else if(buffered_incre & one_digit != 4'b1001 & !gameover) begin // increment on unit digit. 
									ten_digit <= ten_digit;
									one_digit <= one_digit + 4'b0001;
					
					end else begin                               // moving through gaps or gameover.
									ten_digit <= ten_digit;
									one_digit <= one_digit;
					
					
					end
							
			
				  
			end











endmodule


module score_counter_testbench();
	logic clk, rst, gameover;
	logic [15:0][15:0] GrnPixels;
	logic [3:0] ten_digit; 
	logic [3:0] one_digit;
	

	 score_counter dut (.clk, .rst, .GrnPixels, .gameover, .ten_digit, .one_digit);
	
	 
				// Set up a simulated clock.
				parameter CLOCK_PERIOD=100;
				initial begin
							clk <= 0;
							forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
				end

				initial begin
																				@(posedge clk); 
			rst <= 1;  	GrnPixels <= '0;								@(posedge clk); 		// Always reset at start
			rst <= 0; 	gameover <= 0;									@(posedge clk); 
			repeat(55) begin
			GrnPixels[0][14] <= 1'b0;				    				@(posedge clk); 		// Test case 1: running through 110 increment with a group of arbitary GrnPixel we could use. 
			GrnPixels[15][14] <= 1'b1;					 				@(posedge clk);
			GrnPixels[15][14] <= 1'b0;				    				@(posedge clk); 	
			GrnPixels[0][14] <= 1'b1;				    				@(posedge clk); 	
			end
				
			rst <= 1;  														@(posedge clk); 		//  reset 
			rst <= 0; 	gameover <= 0;									@(posedge clk); 
			repeat(10) begin
			GrnPixels[0][14] <= 1'b0;				    				@(posedge clk); 		// Test case  
			GrnPixels[15][14] <= 1'b1;					 				@(posedge clk);
			GrnPixels[15][14] <= 1'b0;				    				@(posedge clk); 	
			GrnPixels[0][14] <= 1'b1;				    				@(posedge clk); 	
			end
			gameover <= 1;	GrnPixels[15][14] <= 1'b1;				@(posedge clk);
			repeat(10) begin
			GrnPixels[0][14] <= 1'b0;				    				@(posedge clk); 		// Test case 
			GrnPixels[15][14] <= 1'b1;					 				@(posedge clk);
			GrnPixels[15][14] <= 1'b0;				    				@(posedge clk); 	
			GrnPixels[0][14] <= 1'b1;				    				@(posedge clk); 	
			end
																				@(posedge clk);
				 $stop; // End the simulation.
				end
endmodule

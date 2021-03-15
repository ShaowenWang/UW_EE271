module victory (clk, rst, L, R, edgelight_L, edgelight_R, increment_refresh, score_p1, score_p2);
	input logic clk, rst,  L, R;
	input logic edgelight_L, edgelight_R ;
	output logic increment_refresh;
	output logic [2:0] score_p1;
	output logic [2:0] score_p2;
	
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
	
	always_ff @(posedge clk) begin
	
		if (rst) begin
					
					score_p1 <= 3'b000;
					score_p2 <= 3'b000;// set scores to 0
					ps <= going;
					increment_refresh <= 1;
					
		end else if   (ps == onewin) begin
											
											score_p1 <= score_p1 + 3'b001;
											increment_refresh <= 1;
											ps <= going;
											
										
		end else if   (ps == twowin) begin
											score_p2 <= score_p2 + 3'b001;
										   increment_refresh <= 1;
											ps <= going;
											
		end else begin 
								ps <= ns;
								increment_refresh <= 0;
						
		end
   end




			
		
endmodule
	
	
	



module victory_testbench();
	 logic clk, rst,  L, R;
	 logic edgelight_L, edgelight_R;
	 logic increment_refresh;
	 logic [2:0] score_p1,score_p2;
	
	
		victory dut (clk, rst, L, R, increment_refresh, edgelight_L, edgelight_R, score_p1, score_p2);
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
			edgelight_L <= 1; edgelight_R <= 0; L <= 1; R <= 0;						@(posedge clk);// player 1
																										@(posedge clk);
			edgelight_L <= 0; edgelight_R <= 0; L <= 1; R <= 0;						@(posedge clk);
			rst <= 1;																				@(posedge clk);
rst <= 0;edgelight_L <= 0; edgelight_R <= 0; L <= 0; R <= 1;						@(posedge clk);
			edgelight_L <= 0; edgelight_R <= 0; L <= 0; R <= 0;  	 				@(posedge clk);
			edgelight_L <= 0; edgelight_R <= 1; L <= 0; R <= 1;			  			@(posedge clk);// player 2
																										@(posedge clk);

			$stop; // End the simulation.
		end

		
endmodule		 






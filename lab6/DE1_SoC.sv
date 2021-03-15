module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	input logic CLOCK_50; // 50MHz clock.
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY; // True when not pressed, False when pressed
	input logic [9:0] SW;

	// Generate clk off of CLOCK_50, whichClock picks rate.

	logic reset;
	logic [31:0] div_clk;
	logic [8:0] lights;
	
	assign LEDR[8:0] = lights;
	assign LEDR[9] = 1'b0;
	
	

	assign reset = SW[9];
	assign HEX1 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX5 = 7'b1111111;
	
	logic mid0, mid3, KEY0, KEY3;
	
	//anti-metastability
	series_dffs antim0 (.clk(CLOCK_50), .reset, .d1(~KEY[0]), .q1(mid0));
	series_dffs antim3 (.clk(CLOCK_50), .reset, .d1(~KEY[3]), .q1(mid3));
	
	//input
	getBonus zero (.clk(CLOCK_50), .reset, .in(mid0), .out(KEY0));
	getBonus three (.clk(CLOCK_50), .reset, .in(mid3), .out(KEY3));
	
	//lighting
	playfield lighting (.clk(CLOCK_50), .rst(reset), .R(KEY0), .L(KEY3), .leds(lights));
	
	//Victory
	victory win (.clk(CLOCK_50), .rst(reset), .L(KEY3), .R(KEY0), .edgelight_L(lights[8]), .edgelight_R(lights[0]), .display(HEX0));
	
	
	
	
endmodule
	
	
	
	
module DE1_SoC_testbench();
		logic CLOCK_50;
		logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
		logic [9:0] LEDR;
		logic [3:0] KEY;
		logic [9:0] SW;
		
		DE1_SoC dut (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
		
		// Set up a simulated clock.
		parameter CLOCK_PERIOD=100;
			initial begin
				CLOCK_50 <= 0;
				forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50; // Forever toggle the clock
			end
		
		
		// Test the design.
		initial begin
			
									 repeat(1) @(posedge CLOCK_50);
					SW[9] <= 1; repeat(1) @(posedge CLOCK_50); // Always reset FSMs at start
					SW[9] <= 0; repeat(1) @(posedge CLOCK_50);
	  KEY[0] <=0 ; KEY[3] <= 1; repeat(3)  	@(posedge CLOCK_50); // Test case 1 calm: input is 00
											@(posedge CLOCK_50);
	  KEY[0] <=0 ; KEY[3] <= 0;  	@(posedge CLOCK_50); // Test case 2 Right To Left: input 01 for 6 cycleS
											@(posedge CLOCK_50);
	  KEY[0] <=0 ; KEY[3] <= 1;  	@(posedge CLOCK_50);
		                           @(posedge CLOCK_50);
		KEY[0] <=0 ; KEY[3] <= 0;  @(posedge CLOCK_50); 
											@(posedge CLOCK_50);
	  KEY[0] <=0 ; KEY[3] <= 1;   	@(posedge CLOCK_50);
	                              @(posedge CLOCK_50);
		KEY[0] <=0 ; KEY[3] <= 0;  	@(posedge CLOCK_50); 
	                             	@(posedge CLOCK_50);
		 KEY[0] <=0 ; KEY[3] <= 1;   	@(posedge CLOCK_50);
	                              @(posedge CLOCK_50);
		KEY[0] <=0 ; KEY[3] <= 0;  	@(posedge CLOCK_50); 
	                             	@(posedge CLOCK_50);
	  KEY[0] <=0 ; KEY[3] <= 1;   	@(posedge CLOCK_50);
	                              @(posedge CLOCK_50);
		KEY[0] <=0 ; KEY[3] <= 0;  	@(posedge CLOCK_50); 
	                             	@(posedge CLOCK_50);
	 KEY[0] <=0 ; KEY[3] <= 1;   	@(posedge CLOCK_50);
	                              @(posedge CLOCK_50);
		KEY[0] <=0 ; KEY[3] <= 0;  	@(posedge CLOCK_50); 
	                             	@(posedge CLOCK_50);
		 KEY[0] <=0 ; KEY[3] <= 1;   	@(posedge CLOCK_50);
	                              @(posedge CLOCK_50);
		KEY[0] <=0 ; KEY[3] <= 0;  	@(posedge CLOCK_50); 
	                             	@(posedge CLOCK_50);
		 KEY[0] <=0 ; KEY[3] <= 1;   	@(posedge CLOCK_50);
	                              @(posedge CLOCK_50);
		KEY[0] <=0 ; KEY[3] <= 0;  	@(posedge CLOCK_50); 
	                             	@(posedge CLOCK_50);

											@(posedge CLOCK_50);
	  				SW[9] <= 1; repeat(1) @(posedge CLOCK_50); // Always reset FSMs at start
					SW[9] <= 0; repeat(1) @(posedge CLOCK_50);
	  KEY[0] <=1 ; KEY[3] <= 0;  	@(posedge CLOCK_50); 
											@(posedge CLOCK_50);
	  KEY[0] <=0 ; KEY[3] <= 0;  	@(posedge CLOCK_50); // Test case 2 Right To Left: input 01 for 6 cycleS
											@(posedge CLOCK_50);
	  KEY[0] <=1 ; KEY[3] <= 0;  	@(posedge CLOCK_50);
		                            	@(posedge CLOCK_50); 
	  KEY[0] <=0 ; KEY[3] <= 0;  	@(posedge CLOCK_50);
	                           	@(posedge CLOCK_50);  
	  KEY[0] <=1 ; KEY[3] <= 0;  	@(posedge CLOCK_50);
											@(posedge CLOCK_50); 
	  KEY[0] <=0 ; KEY[3] <= 0;  	@(posedge CLOCK_50);
	                              @(posedge CLOCK_50);
		 KEY[0] <=1 ; KEY[3] <= 0;  	@(posedge CLOCK_50);
											@(posedge CLOCK_50); 
	  KEY[0] <=0 ; KEY[3] <= 0;  	@(posedge CLOCK_50);
	                              @(posedge CLOCK_50);
		 KEY[0] <=1 ; KEY[3] <= 0;  	@(posedge CLOCK_50);
											@(posedge CLOCK_50); 
	  KEY[0] <=0 ; KEY[3] <= 0;  	@(posedge CLOCK_50);
	                              @(posedge CLOCK_50);
		 KEY[0] <=1 ; KEY[3] <= 0;  	@(posedge CLOCK_50);
											@(posedge CLOCK_50); 
	  KEY[0] <=0 ; KEY[3] <= 0;  	@(posedge CLOCK_50);
	                              @(posedge CLOCK_50);
		 KEY[0] <=1 ; KEY[3] <= 0;  	@(posedge CLOCK_50);
											@(posedge CLOCK_50); 
	  KEY[0] <=0 ; KEY[3] <= 0;  	@(posedge CLOCK_50);
	                              @(posedge CLOCK_50);
											

	            SW[9] <= 1; repeat(1) @(posedge CLOCK_50); // Always reset FSMs at start
					SW[9] <= 0; repeat(1) @(posedge CLOCK_50);@(posedge CLOCK_50); 
	  KEY[0] <=1 ; KEY[3] <= 0;  	@(posedge CLOCK_50);
	                           	@(posedge CLOCK_50); 
	  KEY[0] <=0 ; KEY[3] <= 1;	@(posedge CLOCK_50);
	                           	@(posedge CLOCK_50);
	  KEY[0] <=0 ; KEY[3] <= 1;	@(posedge CLOCK_50);
											@(posedge CLOCK_50); 
											@(posedge CLOCK_50);	
											@(posedge CLOCK_50);
											@(posedge CLOCK_50);	
											
					$stop; // End the simulation.
					
			end
endmodule


	



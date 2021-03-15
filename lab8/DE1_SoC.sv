// Top-level module that defines the I/Os for the DE-1 SoC board
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, SW, LEDR, GPIO_1, CLOCK_50);
    output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	 output logic [9:0]  LEDR;
    input  logic [3:0]  KEY;
    input  logic [9:0]  SW;
    output logic [35:0] GPIO_1; // Used for LED board
    input logic CLOCK_50;

	 // Turn off HEX displays

    assign HEX2 = '1;
    assign HEX3 = '1;
    assign HEX4 = '1;
    assign HEX5 = '1;
	 
	 // Reset
	 logic rst;                   // reset - toggle this on startup
	 assign rst = SW[9];

	 
	 /* Set up system base clock to 1526 Hz (50 MHz / 2**(14+1))
	    ===========================================================*/
	 logic [31:0] div_clk;
	 clock_divider cdiv (.clk(CLOCK_50),
								.rst,
								.divided_clocks(div_clk));

	 // Clock selection; allows for easy switching between simulation and board clocks
	 logic clkSelect;
		
	 // Uncomment ONE of the following two lines depending on intention
		assign clkSelect = CLOCK_50;  // for simulation
	// assign clkSelect = div_clk[14]; // 1526 Hz clock for board
	 
	 
	 
	  /* Set up LED board driver
	    ================================================================== */
	 logic [15:0][15:0]RedPixels; // 16 x 16 array representing red LEDs (row x col)
    logic [15:0][15:0]GrnPixels; // 16 x 16 array representing green LEDs (row x col)
	 
	 LEDDriver Driver (.clk(clkSelect), .rst, .EnableCount(1'b1), .RedPixels, .GrnPixels, .GPIO_1);
	 

		
		
		
		
		
		logic gameover;
//		assign gameover = SW[0]; // for test puropse 
		logic [3:0] ten_bits; 
		logic [3:0] one_bits;
		logic KEY0;

		
		series_dffs KEY0_dffs(.clk(clkSelect), .reset(rst), .d1(~KEY[0]), .q1(KEY0));    //Hook series_dffs

		

		int i;// instantiate bird module
		bird  #(.FLY_THRESHOLD(0), .GRAV_THRESHOLD(0)) birdLogic (.clk(clkSelect), .rst, .button(KEY0), .gameover, .position(i));  //bird for simulation
		//bird birdLogic (.clk(clkSelect), .rst, .button(KEY0), .gameover, .position(i));															//bird for board
		
	
	//instantiate pipe_generator module
		pipe_generator #(.SHIFT_THRESHOLD(0), .GAP(7)) gen1 (.clk(clkSelect), .rst, .gameover, .GrnPixels);	//pipe generator for simulation.		
		// pipe_generator  gen1 (.clk(clkSelect), .rst, .gameover, .GrnPixels);                         			//pipe generator for board 
		
		score_counter score (.clk(clkSelect), .rst, .GrnPixels, .gameover, .ten_digit(ten_bits), .one_digit(one_bits));  //instantiate score counter
		
		
		seg7 decade_num (.bcd(ten_bits), .leds(HEX1));     //instanciate seg7 to display on HEX
		seg7 unit_num (.bcd(one_bits), .leds(HEX0));
		
		collision collide_gameover(.clk(clkSelect), .rst, .GrnPixels, .RedPixels, .gameover);			//real gameover logic

		 
		 

		// display bird
		always_comb begin
				RedPixels = '0; // first, set entire RedPixels array off
				RedPixels[i][13] = 1'b1; // set bird top left pixel on
				RedPixels[i][12] = 1'b1; // set bird top right pixel on
				RedPixels[i+1][13] = 1'b1; // set bird bottom left pixel on
				RedPixels[i+1][12] = 1'b1; // set bird bottom right pixel on
		end

	 
endmodule














module DE1_SoC_testbench();
		logic CLOCK_50;
		logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
		logic [9:0] LEDR;
		logic [3:0] KEY;
		logic [9:0] SW;
		logic [35:0] GPIO_1; // Used for LED board
     
	 DE1_SoC dut (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, SW, LEDR, GPIO_1, CLOCK_50);
//		DE1_SoC dut (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
		
		// Set up a simulated clock.
		parameter CLOCK_PERIOD=100;
			initial begin
				CLOCK_50 <= 0;
				forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50; // Forever toggle the clock
			end
		
		
		// Test the design.
			initial begin
			
										repeat(1) @(posedge CLOCK_50);
					SW[9] <= 1;	 	repeat(1) @(posedge CLOCK_50); // Always reset FSMs at start
					SW[9] <= 0; 	repeat(1) @(posedge CLOCK_50);
					
	  KEY[0] <=1 ;							  	@(posedge CLOCK_50); // Test case 1 going through 2 pipes
													@(posedge CLOCK_50);
	  KEY[0] <=1 ;  				  			@(posedge CLOCK_50); 
		KEY[0] <=1 ;  				  			@(posedge CLOCK_50);
		
		KEY[0] <=1 ;  				  			@(posedge CLOCK_50); 
		KEY[0] <=1;							@(posedge CLOCK_50);
	
		KEY[0] <=1 ;							@(posedge CLOCK_50);
		KEY[0] <=1 ;							@(posedge CLOCK_50);
		KEY[0] <=1;							@(posedge CLOCK_50);
		KEY[0] <=1;							@(posedge CLOCK_50);// Test case 2: hitting a pipe.
		KEY[0] <=1 ;							@(posedge CLOCK_50);
		KEY[0] <=1 ;							@(posedge CLOCK_50);
		KEY[0] <=1 ;							@(posedge CLOCK_50);
		KEY[0] <=1 ;							@(posedge CLOCK_50);		
		KEY[0] <=1;							@(posedge CLOCK_50);
		KEY[0] <=1 ;							@(posedge CLOCK_50);											
		KEY[0] <=1;							@(posedge CLOCK_50);
		KEY[0] <=1 ;							@(posedge CLOCK_50);
		//KEY[0] <=1 ;							@(posedge CLOCK_50);
		KEY[0] <=0 ;							@(posedge CLOCK_50);
		//KEY[0] <=1 ;							@(posedge CLOCK_50);
		
		KEY[0] <=1;							@(posedge CLOCK_50);		

		KEY[0] <=1 ;							@(posedge CLOCK_50);
		KEY[0] <=1 ;							@(posedge CLOCK_50);
					$stop; // End the simulation.
					
			end
endmodule










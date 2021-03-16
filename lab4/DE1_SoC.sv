

module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
   output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
   output logic [9:0] LEDR;
   input logic [3:0] KEY;
   input logic [9:0] SW;


   //ASSIGNMENT1
	seg7 firstHEX (.bcd(SW[3:0]), .leds(HEX0));
	seg7 secondHEX (.bcd(SW[7:4]), .leds(HEX1));

   //ASSIGNMENT2
	//FRED hook (.upc(SW[9:7]), .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5);
	//Lab4Verilog hook2(.LEDR(LEDR[1:0]), .SW(SW[9:0]));
	
endmodule

module DE1_SoC_testbench();
   logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
   logic [9:0] LEDR;
   logic [3:0] KEY;
   logic [9:0] SW;

   DE1_SoC dut (.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR,
  .SW);

   // A1
   integer i;

   initial begin
      for(i = 0; i <256; i++) begin
			SW[7:0] = i; #10;
		end
   end
//	  
//	// A2
//	integer i;
//	integer j;
//	initial begin
//		SW[6:1] = 1'b0;
//	   for(i = 0; i <8; i++) begin
//			for(j = 0; j < 2; j++) begin
//			SW[0] = j;
//			SW[9:7] = i; #10;
//			end
//      end
//   end
endmodule


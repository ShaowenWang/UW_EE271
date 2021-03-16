

module Lab3Verilog (LEDR, SW);
   output logic [1:0] LEDR;
   input logic [9:0] SW;
	
	//set LED0 as sale light
   assign LEDR[0] = SW[8] | (SW[9] & SW[7]);
	
	//set LED1 as stolen light
   assign LEDR[1] = (~SW[8]) & (~SW[0]) & (SW[9] | ~SW[7]);
	
	//bal
  
	
endmodule

module Lab3Verilog_testbench();
   logic [1:0] LEDR;
   logic [9:0] SW;

   Lab3Verilog dut ( .LEDR,
  .SW);

   // Try all combinations of inputs.
	
   integer i;
	integer j;
   initial begin
     SW[6:1] = 1'b0;
     for(i = 0; i <8; i++) begin
		for(j=0; j<2; j++) begin 
			SW[0] = j;
		   SW[9:7] = i; #10;
		end
     end
   end
endmodule 


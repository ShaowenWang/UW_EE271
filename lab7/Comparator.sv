module Comparator (out, A, B, clk, rst);
	output logic out;
	input logic clk, rst;
	input logic [9:0] A, B;
	
	assign out = (A > B);
endmodule 



module Comparator_testbench();
	logic out;
	logic clk, rst;
	logic [9:0] A, B;
	
	Comparator dut (.out, .A, .B, .clk, .rst);
	
	initial begin
		clk = 1; rst = 0;
		A = 10'b0000000000;
		B = 10'b0000000000;
		#10;
		A = 10'b0000000001;
		B = 10'b0000000010;
		#10;
		A = 10'b0000000001;
		B = 10'b0000000000;
		#10;
	end
endmodule

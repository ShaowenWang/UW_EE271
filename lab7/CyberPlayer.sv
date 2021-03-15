module CyberPlayer(out, Q, SW, clk, rst);
	output logic out;
	input logic [9:0] Q;
	input logic [8:0] SW;
	input logic clk, rst;
	logic [9:0] SW_addOneBit;
	
	assign SW_addOneBit = {1'b0, SW};
	
	Comparator compare (.out, .A(SW_addOneBit), .B(Q), .clk, .rst);
	
endmodule

module CyberPlayer_testbench();
	logic out;
	logic [9:0] Q;
	logic [8:0] SW;
	logic clk, rst;	
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		rst <= 1;																@(posedge clk);
		rst <= 0;		Q = 10'b0000000000; SW = 10'b0000000000;	@(posedge clk);
																					@(posedge clk);
																					@(posedge clk);
							Q = 10'b0000000001; SW = 10'b0000000000;  @(posedge clk);
																					@(posedge clk);
																					@(posedge clk);
							Q = 10'b0000000001; SW = 10'b0000000100;  @(posedge clk);
		
		@(posedge clk);
	end
	
endmodule

	

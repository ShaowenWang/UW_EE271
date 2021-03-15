module random(rand_num, clk, rst);
	output logic [3:0] rand_num;
	input logic clk, rst;
	logic xnor_result;
	// input: 10, 7 by table
	// 1 2 3 4 
	// 3 2 1 0 
	xnor calculate (xnor_result, rand_num[0], rand_num[1]);
	always_ff @(posedge clk) begin
		if (rst)
			rand_num <= 4'b0000;
		else
			rand_num <= { xnor_result, rand_num[3:1] };
	end

endmodule

module random_testbench();
	logic [3:0] rand_num;
	logic clk, rst;
	
	random dut (.rand_num, .clk, .rst);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		rst <= 1;		@(posedge clk);
		rst <= 0;		@(posedge clk);
		               @(posedge clk);
							@(posedge clk);
							@(posedge clk);
							@(posedge clk);
							@(posedge clk);
							@(posedge clk);
							@(posedge clk);
							@(posedge clk);
							@(posedge clk);
		$stop();
	end
endmodule

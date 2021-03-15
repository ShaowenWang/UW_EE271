module LFSR(Q, Clock, Reset);
	output logic [9:0] Q;
	input logic Clock, Reset;
	logic xnor_result;
	// input: 10, 7 by table
	// 1 2 3 4 5 6 7 8 9 10
	// 9 8 7 6 5 4 3 2 1 0
	xnor calculate (xnor_result, Q[0], Q[3]);
	always_ff @(posedge Clock) begin
		if (Reset)
			Q <= 10'b0000000000;
		else
			Q <= { xnor_result, Q[9:1] };
	end

endmodule

module LFSR_testbench();
	logic [9:0] Q;
	logic Clock, Reset;
	
	LFSR dut (.Q, .Clock, .Reset);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		Clock <= 0;
		forever #(CLOCK_PERIOD/2) Clock <= ~Clock;
	end
	
	initial begin
		Reset <= 1;		@(posedge Clock);
		Reset <= 0;		@(posedge Clock);
		               @(posedge Clock);
							@(posedge Clock);
							@(posedge Clock);
							@(posedge Clock);
							@(posedge Clock);
							@(posedge Clock);
							@(posedge Clock);
							@(posedge Clock);
							@(posedge Clock);
		$stop();
	end
endmodule

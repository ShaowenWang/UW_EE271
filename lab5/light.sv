module light (clk, reset, i1, i0, out2, out1, out0);
	input logic clk, reset, i1, i0;
	output logic out2, out1, out0;
	
	//state variable
	enum logic [2:0] { A = 3'b101, B = 3'b010, C = 3'b001, D = 3'b100 } ps, ns;
	
	//next state logic
	always_comb begin
	ns = C;
		case (ps)
			A:    if (~i1 && ~i0)          ns = B;
					else if (i1 && ~i0)      ns = D;
					else if (~i1 && i0)      ns = C;
							 
			B:    if (~i1 && ~i0)			 ns = A;
					else if (i1 && ~i0)      ns = C;
					else if (~i1 && i0)		 ns = D;
			C:    if (~i1 && ~i0)          ns = A;
			      else if (i1 && ~i0)      ns = D;
					else if (~i1 && i0)      ns = B;
			D:    if (~i1 && ~i0)			 ns = A;
					else if (i1 && ~i0)      ns = B;
					else if (~i1 && i0)		 ns = C;
		endcase
	end
	
	//output logic
	assign {out2, out1, out0} = ps;
	
	//DFFs
	always_ff @(posedge clk) begin
		if(reset)
			ps <= A;
		else
			ps <= ns;
	end
	
endmodule


module light_testbench();
	logic clk, reset, i1, i0;
	logic out2, out1, out0;

	light dut (clk, reset, i1, i0, out2, out1, out0);

	// Set up a simulated clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end

	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin
												@(posedge clk);
		reset <= 1; 		   			@(posedge clk); // Always reset FSMs at start
		reset <= 0; i1 <= 0; i0 <= 1; @(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
						i1 <= 1; i0 <= 0; @(posedge clk);
						                  @(posedge clk);
												@(posedge clk);
						i1 <= 0; i0 <= 0;	@(posedge clk);
												@(posedge clk);
												@(posedge clk);
						i1 <= 0; i0 <= 1; @(posedge clk);
												@(posedge clk);
		$stop; // End the simulation.
	end
endmodule 
	
	
					
			

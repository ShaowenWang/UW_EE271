module seg7 (bcd, leds);
	input logic [2:0] bcd;
	output logic [6:0] leds;
		always_comb begin
			case (bcd)
				//          Light: 6543210
				3'b000: leds = 7'b1000000; // 0
				3'b001: leds = 7'b1111001; // 1
				3'b010: leds = 7'b0100100; // 2
				3'b011: leds = 7'b0110000; // 3
				3'b100: leds = 7'b0011001; // 4
				3'b101: leds = 7'b0010010; // 5
				3'b110: leds = 7'b0000010; // 6
				3'b111: leds = 7'b1111000; // 7
			
				
				default: leds = 7'bX;
		endcase
	end
endmodule

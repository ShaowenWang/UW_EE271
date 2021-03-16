module FRED (upc, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);

	input logic [2:0] upc;
	
	output logic [6:0] HEX0;
	output logic [6:0] HEX1;
	output logic [6:0] HEX2;
	output logic [6:0] HEX3;
	output logic [6:0] HEX4;
	output logic [6:0] HEX5;
	
	
	
	parameter TWO = 7'b0100100;  //2
	parameter A  = 7'b0001000; // A
	parameter C  = 7'b1000110; // C
	parameter E  = 7'b0000110; // E
	parameter H  = 7'b0001001; // H
	parameter L  = 7'b1000111; // L
	parameter O  = 7'b0100011; // o
	parameter P  = 7'b0001100; // P
	parameter R  = 7'b1001110; // r
	parameter Y  = 7'b0010001; // y
	parameter blank  = 7'b1111111; // blank
				
	
		always_comb begin
			case (upc)
					
					
					// Item 1
				3'b000: begin  
					
					 HEX5 = P;
					 HEX4 = A;
				    HEX3 = P;
				    HEX2 = A;
			       HEX1 = Y;
				    HEX0 = A;
				  
				 end
				 
				 //ITEM 2
				 3'b001: begin 
					
					 HEX5 = blank;
					 HEX4 = blank;
				    HEX3 = blank;
				    HEX2 = H;
			       HEX1 = TWO;
				    HEX0 = O;
				  
				 end
				 
				 //ITEM 3
				 3'b011: begin 
					
					 HEX5 = blank;
					 HEX4 = A;
				    HEX3 = P;
				    HEX2 = P;
			       HEX1 = L;
				    HEX0 = E;
				  
				 end
				 
				 //ITEM 4
				 3'b100: begin 
					
					 HEX5 = blank;
					 HEX4 = blank;
				    HEX3 = P;
				    HEX2 = E;
			       HEX1 = A;
				    HEX0 = R;
				  
				 end
				 
				 //ITEM 5
				 3'b101: begin 
					
					 HEX5 = blank;
					 HEX4 = blank;
				    HEX3 = C;
				    HEX2 = O; 
			       HEX1 = C;
				    HEX0 = O;
				  
				 end
				 
				 //ITEM 6
				 3'b110: begin 
					
					 HEX5 = blank;
					 HEX4 = blank;
				    HEX3 = blank;
				    HEX2 = P;
			       HEX1 = E;
				    HEX0 = A;
				  
				 end
				 
				 default: begin
				
							HEX5 = 7'bx;
							HEX4 = 7'bX;
							HEX3 = 7'bX;
							HEX2 = 7'bX;
							HEX1 = 7'bX;
							HEX0 = 7'bX;
		       end
			
							

		endcase
	end
endmodule

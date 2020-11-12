// Module Name:    ALU 
// Project Name:   CSE141L
//
// Revision Fall 2020
// Based on SystemVerilog source code provided by John Eldon
// Comment:
// 


	 
module ALU(InputA,InputB,OP,Out,Zero);

	input [ 7:0] InputA;
	input [ 7:0] InputB;
	input [ 3:0] OP;
	output reg [7:0] Out; // logic in SystemVerilog
	output reg Zero;

	always@* // always_comb in systemverilog
	begin 
		Out = 0;
		case (OP)
		4'b0000: Out = InputA + InputB; 	 // ADD
		4'b0001: Out = InputA & InputB; 	 // AND
		4'b0010: Out = InputA | InputB; 	 // OR
		4'b0011: Out = InputA ^ InputB; 	 // XOR
		4'b0100: Out = InputA << 1;			 // Shift left
		4'b0101: Out = {1'b0,InputA[7:1]};   // Shift right
		4'b0110: Out = {1'b0,InputA[7:1]};   // Shift right
		4'b0111: Out = {1'b0,InputA[7:1]};   // Shift right
		4'b1000: Out = {1'b0,InputA[7:1]};   // Shift right
		4'b1001: Out = {1'b0,InputA[7:1]};   // Shift right
		4'b1010: Out = {1'b0,InputA[7:1]};   // Shift right
		4'b1011: Out = {1'b0,InputA[7:1]};   // Shift right
		4'b1100: Out = {1'b0,InputA[7:1]};   // Shift right
		4'b1101: Out = {1'b0,InputA[7:1]};   // Shift right
		4'b1110: Out = {1'b0,InputA[7:1]};   // Shift right
		default: Out = 0;
	  endcase
	
	end 

	always@*							  // assign Zero = !Out;
	begin
		case(Out)
			'b0     : Zero = 1'b1;
			default : Zero = 1'b0;
      endcase
	end


endmodule
`timescale 1ns/ 1ps



//Test bench
//Arithmetic Logic Unit
/*
* INPUT: A, B
* op: 00, A PLUS B
* op: 01, A AND B
* op: 10, A OR B
* op: 11, A XOR B
* OUTPUT A op B
* equal: is A == B?
* even: is the output even?
*/


module ALU_tb;
reg [7:0] INPUTA;	// data inputs
reg [7:0] INPUTB;
reg [3:0] op;	// ALU opcode, part of microcode
reg [1:0] OverflowIn;
wire[7:0] OUT;
wire OverflowOut; 

wire Zero;    

reg [ 7:0] expected;
reg [1:0] expectedOverflow;
reg [7:0] sub;
 
// CONNECTION
ALU uut(
  .InputA(INPUTA),
  .InputB(INPUTB),
  .OP(op),
  .OverflowIn(OverflowIn),
  .Out(OUT),
  .OverflowOut(OverflowOut),	
  .Zero(Zero)
);
	 
initial begin
	// add
	INPUTA = 1;
	INPUTB = 1; 
	op= 'b0000;
	assign sub = INPUTA - INPUTB;
	test_alu_func; // void function call
	#5;
	// sub
	INPUTA = 1;
	INPUTB = 1; 
	op= 'b0001;
	assign sub = INPUTA - INPUTB;
	test_alu_func; // void function call
	#5;
	// nand
	INPUTA = 1;
	INPUTB = 1; 
	op= 'b0110;
	assign sub = INPUTA - INPUTB;
	test_alu_func; // void function call
	#5;
	// or
	INPUTA = 1;
	INPUTB = 1; 
	op= 'b0111;
	assign sub = INPUTA - INPUTB;
	test_alu_func; // void function call
	#5;
	// sll
	INPUTA = 1;
	INPUTB = 1; 
	op= 'b1000;
	assign sub = INPUTA - INPUTB;
	test_alu_func; // void function call
	#5;
	// srl
	INPUTA = 1;
	INPUTB = 1; 
	op= 'b1001;
	assign sub = INPUTA - INPUTB;
	test_alu_func; // void function call
	#5;
	// lt
	INPUTA = 1;
	INPUTB = 1; 
	op= 'b1101;
	assign sub = INPUTA - INPUTB;
	test_alu_func; // void function call
	#5;
	// eql
	INPUTA = 1;
	INPUTB = 1; 
	op= 'b1110;
	assign sub = INPUTA - INPUTB;
	test_alu_func; // void function call
	#5;
	end
	
	task test_alu_func;
	begin
	  case (op)
		// add
		4'b0000: {expectedOverflow, expected} = INPUTA + INPUTB + OverflowIn;
		// sub
		4'b0001: expected = sub;
		// nand
		4'b0110: expected = ~(INPUTA & INPUTB);
		// or
		4'b0111: expected = INPUTA | INPUTB;
		// sll
		4'b1000: expected = INPUTA << INPUTB;
		// srl
		4'b1001: expected = INPUTA >> INPUTB;
		// lt
		4'b1101:
		begin
			// InputA < InputB so sub has overflow
			if (sub[7:7] == 1'b1)
				expected = 8'b00000001;
			else
				expected = 8'b00000000;
		end
		// eql
		4'b1110:
		begin
			if (sub == 8'b00000000)
				expected = 8'b00000001;
			else
				expected = 8'b00000000;
		end
	  endcase
	  #1; if(expected == OUT) begin
			$display("%t YAY!! inputs = %h %h, opcode = %b, Zero %b",$time, INPUTA,INPUTB,op, Zero);
		end else begin 
			$display("%t FAIL! inputs = %h %h, opcode = %b, zero %b",$time, INPUTA,INPUTB,op, Zero);
		end
	end
	endtask
endmodule
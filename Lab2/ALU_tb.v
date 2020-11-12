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
reg [ 7:0] INPUTA;     	  // data inputs
reg [ 7:0] INPUTB;
reg [ 2:0] op;		// ALU opcode, part of microcode
wire[ 7:0] OUT;		  

  wire Zero;    
 
 reg [ 7:0] expected;
 
// CONNECTION
ALU uut(
  .InputA(INPUTA),      	  
  .InputB(INPUTB),
  .OP(op),				  
  .Out(OUT),		  			
  .Zero(Zero)
    );
	 
initial begin


	INPUTA = 1;
	INPUTB = 1; 
	op= 'b01; // AND
	test_alu_func; // void function call
	#5;
	
	
	INPUTA = 4;
	INPUTB = 1;
	op= 'b101; // ADD
	test_alu_func; // void function call
	#5;
	end
	
	task test_alu_func;
	begin
	  case (op)
		0: expected = INPUTA + INPUTB;
		1: expected = INPUTA & INPUTB;
		2: expected = INPUTA | INPUTB;
		3: expected = INPUTA ^ INPUTB;
		4: expected = INPUTA << 1;				// Shift left
		5: expected = {1'b0,INPUTA[7:1]};   // Shift right
	  endcase
	  #1; if(expected == OUT)
		begin
			$display("%t YAY!! inputs = %h %h, opcode = %b, Zero %b",$time, INPUTA,INPUTB,op, Zero);
		end
	    else begin $display("%t FAIL! inputs = %h %h, opcode = %b, zero %b",$time, INPUTA,INPUTB,op, Zero);end
		
	end
	endtask



endmodule
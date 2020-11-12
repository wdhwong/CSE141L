// Module Name:    Ctrl 
// Project Name:   CSE141L
//
// Revision Fall 2020
// Based on SystemVerilog source code provided by John Eldon
// Comment:
// This module is the control decoder (combinational, not clocked)
// Out of all the files, you'll probably write the most lines of code here
// inputs from instrROM, ALU flags
// outputs to program_counter (fetch unit)
// There may be more outputs going to other modules

module Ctrl (Instruction, Jump, BranchEn);


  input[ 8:0] Instruction;	   // machine code
  output reg Jump,
              BranchEn;

	// jump on right shift that generates a zero
	always@*
	begin
	  if(Instruction[2:0] ==  3'b111) // assuming 111 is your jump instruction
		 Jump = 1;
	  else
		 Jump = 0;
		 
		 if(Instruction[2:0] ==  3'b110 /*AND some other conditions are true*/) // assuming 110 is your branch instruction
		 BranchEn = 1;
	  else
		 BranchEn = 0;
		 
		 
	end


endmodule


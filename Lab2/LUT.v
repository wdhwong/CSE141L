// Module Name:    LUT 
// Project Name:   CSE141L
//
// Revision Fall 2020
// Based on SystemVerilog source code provided by John Eldon
// Comment: 
// This is the lookup table
// Leverage a few-bit pointer to a wider number
// It is optional
// You may increase the Addr, but you are not allowed to go over 32 elements (5 bits)
// You could use it for anything you want. Ex. possible lookup table for PC target
// Lookup table acts like a function: here Target = f(Addr);
//  in general, Output = f(Input); 
module LUT(Addr, Target);
  
    input       [ 1:0] Addr;
	output reg[ 9:0] Target;

	always @*
	  case(Addr)		  
		2'b00:    Target = 10'h3ff;  // Ex. -1
		2'b01:	 Target = 10'h003;
		2'b10:	 Target = 10'h007;
		default:  Target = 10'h001;
	  endcase

endmodule
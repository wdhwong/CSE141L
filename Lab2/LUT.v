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
  
  input       [ 3:0] Addr;
  output reg  [ 7:0] Target;

  always @*
    case(Addr)
      4'b0000:    Target = 8'b00000001; // 1
      4'b0001:	  Target = 8'b00000010; // 2
      4'b0010:	  Target = 8'b00000100; // 4
      4'b0011:    Target = 8'b00001000; // 8
      4'b0100:    Target = 8'b00001001; // 9
      4'b0101:    Target = 8'b00001010; // 10
      4'b0110:    Target = 8'b00001011; // 11
      4'b0111:    Target = 8'b01111111; // 127
      4'b1000:    Target = 8'b00001111; // 15
      4'b1001:    Target = 8'b00000111; // 7
      4'b1010:    Target = 8'b11111111;
      4'b1011:    Target = 8'b11111111;
      4'b1100:    Target = 8'b11111111;
      4'b1101:    Target = 8'b11111111;
      4'b1110:    Target = 8'b11111111;
      4'b1111:    Target = 8'b11111111;
      default:    Target = 8'b00000000;
    endcase

endmodule
// Module Name:    ALU 
// Project Name:   CSE141L
//
// Revision Fall 2020
// Based on SystemVerilog source code provided by John Eldon
// Comment:
// 

module ALU(InputA,InputB,OP,OverflowIn,Out,OverflowOut);

  input [ 7:0] InputA;
  input [ 7:0] InputB;
  input [ 3:0] OP;
  input OverflowIn;
  output reg [7:0] Out; // logic in SystemVerilog
  output reg OverflowOut;

  wire [9:0] temp = InputA + ~InputB + 8'd1 - OverflowIn;

  always@* // always_comb in systemverilog
  begin 
    Out = 0;
    OverflowOut = OverflowIn;
    case (OP)
    // add
    4'b0000: {OverflowOut, Out} = InputA + InputB + OverflowIn;
    // sub
    4'b0001: {OverflowOut, Out} = InputA + (~InputB + 8'd1) - OverflowIn;
    // load
    4'b0010: Out = InputB;
    // store
    4'b0011: Out = InputB;
    // mov
    4'b0100: Out = InputB;
    // cpy
    4'b0101: Out = InputA;
    // nand
    4'b0110: Out = ~(InputA & InputB);
    // or
    4'b0111: Out = InputA | InputB;
    // sll
    4'b1000: Out = InputA << InputB;
    // srl
    4'b1001: Out = InputA >> InputB;
    // rst
    4'b1010: OverflowOut = 1'b0;
    // halt
    4'b1011: ;
    // LUT
    4'b1100: Out = InputB;
    // lt
    4'b1101:
    begin
      // InputA < InputB so sub has overflow
      if( InputA == InputB)
        Out = 8'b00000000;
      else if (temp[8:8] == 1)
        Out = 8'b00000001;
      else
        Out = 8'b00000000;
    end
    // eql
    4'b1110:
    begin
      if (InputA == InputB)
        Out = 8'b00000001;
      else
        Out = 8'b00000000;
    end
    // not
    4'b1111: Out = ~InputB;
    default:;
    endcase
  end

endmodule

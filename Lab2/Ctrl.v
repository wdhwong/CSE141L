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

module Ctrl (Instruction, BranchEn, RegWrEn, MemWrite, MemRead, IsOverflow, AccWrEn, LookUp, MemToReg, Ack);

  input[ 8:0] Instruction;	   // machine code
  output reg  RegWrEn,
              MemWrite,
              MemRead,
              IsOverflow,
              AccWrEn,
              LookUp,
              Ack,
              MemToReg,
              BranchEn;

  always@*
  begin
    if(Instruction[8:8] ==  1'b1) begin // check type bit
      RegWrEn = 0;
      BranchEn = 1;
      MemWrite = 0;
      MemRead = 0;
      IsOverflow = 0;
      AccWrEn = 0;
      LookUp = 0;
      MemToReg = 0;
      Ack = 0;
    end else begin
      case (Instruction[7:4])
        // add
        4'b0000: begin
          RegWrEn = 0;
          BranchEn = 0;
          MemWrite = 0;
          MemRead = 0;
          IsOverflow = 0;
          AccWrEn = 1;
          LookUp = 0;
          MemToReg = 0;
          Ack = 0;
        end
        // sub
        4'b0001: begin
          RegWrEn = 0;
          BranchEn = 0;
          MemWrite = 0;
          MemRead = 0;
          IsOverflow = 0;
          AccWrEn = 1;
          LookUp = 0;
          MemToReg = 0;
          Ack = 0;
        end
        // load
        4'b0010: begin
          RegWrEn = 0;
          BranchEn = 0;
          MemWrite = 0;
          MemRead = 1;
          IsOverflow = 0;
          AccWrEn = 1;
          MemToReg = 1;
          LookUp = 0;
          Ack = 0;
        end
        // store
        4'b0011: begin
          RegWrEn = 0;
          BranchEn = 0;
          MemWrite = 1;
          MemRead = 0;
          IsOverflow = 0;
          AccWrEn = 0;
          LookUp = 0;
          MemToReg = 0;
          Ack = 0;
        end
        // mov
        4'b0100: begin
          RegWrEn = 0;
          BranchEn = 0;
          MemWrite = 0;
          MemRead = 0;
          IsOverflow = 0;
          AccWrEn = 1;
          LookUp = 0;
          MemToReg = 0;
          Ack = 0;
        end
        // cpy
        4'b0101: begin
          RegWrEn = 1;
          BranchEn = 0;
          MemWrite = 0;
          MemRead = 0;
          IsOverflow = 0;
          AccWrEn = 0;
          LookUp = 0;
          MemToReg = 0;
          Ack = 0;
        end
        // nand
        4'b0110: begin
          RegWrEn = 0;
          BranchEn = 0;
          MemWrite = 0;
          MemRead = 0;
          IsOverflow = 0;
          AccWrEn = 1;
          LookUp = 0;
          MemToReg = 0;
          Ack = 0;
        end
        // or
        4'b0111: begin
          RegWrEn = 0;
          BranchEn = 0;
          MemWrite = 0;
          MemRead = 0;
          IsOverflow = 0;
          AccWrEn = 1;
          LookUp = 0;
          MemToReg = 0;
          Ack = 0;
        end
        // sll
        4'b1000: begin
          RegWrEn = 0;
          BranchEn = 0;
          MemWrite = 0;
          MemRead = 0;
          IsOverflow = 0;
          AccWrEn = 1;
          LookUp = 0;
          MemToReg = 0;
          Ack = 0;
        end
        // slr
        4'b1001: begin
          RegWrEn = 0;
          BranchEn = 0;
          MemWrite = 0;
          MemRead = 0;
          IsOverflow = 0;
          AccWrEn = 1;
          LookUp = 0;
          MemToReg = 0;
          Ack = 0;
        end
        // rst
        4'b1010: begin
          RegWrEn = 0;
          BranchEn = 0;
          MemWrite = 0;
          MemRead = 0;
          IsOverflow = 1;
          AccWrEn = 0;
          LookUp = 0;
          MemToReg = 0;
          Ack = 0;
        end
        // halt
        4'b1011: begin
          RegWrEn = 0;
          BranchEn = 0;
          MemWrite = 0;
          MemRead = 0;
          IsOverflow = 0;
          AccWrEn = 0;
          LookUp = 0;
          MemToReg = 0;
          Ack = 1;
        end
        // lookup
        4'b1100: begin
          RegWrEn = 0;
          BranchEn = 0;
          MemWrite = 0;
          MemRead = 0;
          IsOverflow = 0;
          AccWrEn = 1;
          LookUp = 1;
          MemToReg = 0;
          Ack = 0;
        end
        // lt
        4'b1101: begin
          RegWrEn = 0;
          BranchEn = 0;
          MemWrite = 0;
          MemRead = 0;
          IsOverflow = 0;
          AccWrEn = 1;
          LookUp = 0;
          MemToReg = 0;
          Ack = 0;
        end
        // eql
        4'b1110: begin
          RegWrEn = 0;
          BranchEn = 0;
          MemWrite = 0;
          MemRead = 0;
          IsOverflow = 0;
          AccWrEn = 1;
          LookUp = 0;
          MemToReg = 0;
          Ack = 0;
        end
        // ult
        4'b1111: begin
          RegWrEn = 0;
          BranchEn = 0;
          MemWrite = 0;
          MemRead = 0;
          IsOverflow = 0;
          AccWrEn = 1;
          LookUp = 0;
          MemToReg = 0;
          Ack = 0;
        end
      endcase
    end
  end

endmodule


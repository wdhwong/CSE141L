// Module Name:    CPU 
// Project Name:   CSE141L
//
// Revision Fall 2020
// Based on SystemVerilog source code provided by John Eldon
// Comment:
// This is the TopLevel of your project
// Testbench will create an instance of your CPU and test it
// You may add a LUT if needed
// Set Ack to 1 to alert testbench that your CPU finishes doing a program or all 3 programs

module CPU(Reset, Start, Clk,Ack);

  input Reset;		// init/reset, active high
  input Start;		// start next program
  input Clk;			// clock -- posedge used inside design
  output reg Ack;   // done flag from DUT

  wire [10:0] PgmCtr,        // program counter
  wire [ 8:0] Instruction;   // our 9-bit instruction
  wire [ 7:4] Instr_opcode;  // out 3-bit opcode
  wire [ 7:0] ReadA, ReadB;  // reg_file outputs
  wire [ 7:0] InA, InB, 	   // ALU operand inputs
              ALU_out;       // ALU result
  wire [ 7:0] LookupValue;   // lookup value
  wire [ 7:0] RegWriteValue, // data in to reg file
              MemWriteValue, // data in to data_memory
              MemReadValue;  // data out from data_memory
  wire        MemWrite,	     // data_memory write enable
              MemRead,       // data_memory read
              RegWrEn,	     // reg_file write enable
              LookUp,        // use lookup table
              IsOverflow,    // 1 if overflow else 0
              OverflowValue, // value of the overflow register
              OverflowValueN,// value of the overflow register for next cycle
              AccWrEn,       // write to accumulator
              MemToReg,      // store data_memory in reg
              BranchEn;	     // to program counter: branch enable
  reg  [15:0] CycleCt;	     // standalone; NOT PC!

  // Fetch = Program Counter + Instruction ROM
  // Program Counter
  InstFetch IF1 (
    .Reset       (Reset),
    .Start       (Start),
    .Clk         (Clk),
    .Branch      (BranchEn),  // branch enable
    .Target      (Instruction[7:0]),
    .ProgCtr     (PgmCtr)	   // program count = index to instruction memory
  );

  // Control decoder
  Ctrl Ctrl1 (
    .Instruction,  // from instr_ROM
    // output signals
    .BranchEn,
    .RegWrEn,
    .MemWrite,
    .MemRead,
    .IsOverflow,
    .AccWrEn,
    .LookUp,
    .MemToReg,
    .Ack
  );

  // instruction ROM
  InstROM IR1(
    .InstAddress   (PgmCtr), 
    .InstOut       (Instruction)
  );

  //Reg file
  // Modify D = *Number of bits you use for each register*
  // Width of register is 8 bits, do not modify
  RegFile #(.W(8),.D(4)) RF1 (
    .Clk       (Clk),
    .AccWrEn,
    .WriteEn   (RegWrEn),
    .RaddrA    (Instruction[2:0]),
    .DataIn    (RegWriteValue),
    .DataOutA  (ReadA),
    .DataOutB  (ReadB)
  );

  // used to look up the address to branch to
  LUT lut1(
    .Addr   (Instruction[3:0]),
    .Target (LookupValue)
  );

  assign InA = ReadA;						                             // connect RF out to ALU in
  assign InB = LookUp ? LookupValue : ReadB;                 // either the immediate value or the register value
  assign Instr_opcode = Instruction[7:4];
  assign RegWriteValue = MemToReg ? MemReadValue : ALU_out;  // either the ALU output or the MemReadValue

  // Arithmetic Logic Unit
  ALU ALU1(
    .InputA(InA),
    .InputB(InB),
    .OverflowIn(OverflowValue),
    .OP(Instruction[7:4]),
    .Out(ALU_out),
    .OverflowOut(OverflowValueN)
  );

  // Data Memory
  DataMem DM1(
    .DataAddress  (ReadA),
    .WriteEn      (MemWrite),
    .ReadEn       (MemRead),
    .DataIn       (MemWriteValue),
    .DataOut      (MemReadValue),
    .Clk 		      (Clk),
    .Reset		    (Reset)
  );

  always @(posedge Clk)
    if (Start == 1 || IsOverflow == 1)
      OverflowValue <= 0;
    else
      OverflowValue <= OverflowValueN;

// count number of instructions executed
// Help you with debugging
  always @(posedge Clk)
    if (Start == 1)	   // if(start)
      CycleCt <= 0;
    else if(Ack == 0)   // if(!halt)
      CycleCt <= CycleCt+16'b1;

endmodule
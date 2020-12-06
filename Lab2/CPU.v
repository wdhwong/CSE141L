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
  output Ack;     // done flag from DUT

  wire [ 9:0] PgmCtr;        // program counter
  wire [ 8:0] Instruction;   // our 9-bit instruction
  wire [ 7:4] Instr_opcode;  // out 3-bit opcode
  wire [ 7:0] AccReg, DstReg;// reg_file outputs
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
              OverflowValueN,// value of the overflow register for next cycle
              AccWrEn,       // write to accumulator
              MemToReg,      // store data_memory in reg
              BranchEn;	     // to program counter: branch enable
  reg  OverflowValue;
  reg  [15:0] CycleCt;	     // standalone; NOT PC!

  // Fetch = Program Counter + Instruction ROM
  // Program Counter
  InstFetch IF1 (
    .Reset    (Reset),
    .Start    (Start),
    .Clk      (Clk),
    .Branch   (BranchEn && (AccReg != 8'b00000000)),  // branch enable
    .Target   (Instruction[7:0]),
    .ProgCtr  (PgmCtr)	   // program count = index to instruction memory
  );

  // instruction ROM
  InstROM IR1(
    .InstAddress (PgmCtr), 
    .InstOut     (Instruction)
  );

  // Control decoder
  Ctrl Ctrl1 (
    .Instruction (Instruction),  // from instr_ROM
    // output signals
    .BranchEn    (BranchEn),
    .RegWrEn     (RegWrEn),
    .MemWrite    (MemWrite),
    .MemRead     (MemRead),
    .IsOverflow  (IsOverflow),
    .AccWrEn     (AccWrEn),
    .LookUp      (LookUp),
    .MemToReg    (MemToReg),
    .Ack         (Ack)
  );

  // Reg file
  // Modify D = *Number of bits you use for each register*
  // Width of register is 8 bits, do not modify
  RegFile #(.W(8),.D(4)) RF1 (
    .Reset     (Reset),
    .Clk       (Clk),
    .AccWrEn   (AccWrEn),
    .WriteEn   (RegWrEn),
    .RaddrA    (4'b0000),          // Accumulator Register
    .RaddrB    (Instruction[3:0]), // Targeted Register
    .DataIn    (RegWriteValue),
    .DataOutA  (AccReg),
    .DataOutB  (DstReg)
  );

  // used to look up various values hardcoded in the LUT table
  LUT lut1(
    .Addr   (Instruction[3:0]),
    .Target (LookupValue)
  );

  assign InA = AccReg;						                           // connect RF out to ALU in
  assign InB = LookUp ? LookupValue : DstReg;                // either the immediate value or the register value
  assign Instr_opcode = Instruction[7:4];
  assign RegWriteValue = MemToReg ? MemReadValue : ALU_out;  // either the ALU output or the MemReadValue
  assign MemWriteValue = AccReg;                             // accumulator value to memory

  // Arithmetic Logic Unit
  ALU ALU1(
    .InputA      (InA),
    .InputB      (InB),
    .OverflowIn  (OverflowValue),
    .OP          (Instr_opcode),
    // output values
    .Out         (ALU_out),
    .OverflowOut (OverflowValueN)
  );

  // Data Memory
  DataMem DM1(
    .Clk 		      (Clk),
    .Reset		    (Reset),
    .DataAddress  (ALU_out),
    .WriteEn      (MemWrite),
    .ReadEn       (MemRead),
    .DataIn       (MemWriteValue),
    // output value
    .DataOut      (MemReadValue)
  );

  always @(posedge Clk)
    if (Start == 1 || IsOverflow == 1)
      OverflowValue <= 0;
    else
      OverflowValue <= OverflowValueN;

// count number of instructions executed
// Help you with debugging
  always @(posedge Clk) begin
    if(Instruction[8:8] ==  1'b1) begin
      $display("%t bne %d", $time, Instruction[7:0]);
    end else begin
      case (Instruction[7:4])
        0: $display("%t add %d %d - %d", $time, InA, InB, ALU_out);
        1: $display("%t sub %d %d - %d", $time, InA, InB, ALU_out);
        2: $display("%t load %d - %d", $time, InB, MemReadValue);
        3: $display("%t store %d - %d", $time, InB, MemWriteValue);
        4: $display("%t mov %d - %d", $time, InB, AccReg);
        5: $display("%t cpy %d - %d", $time, InB, AccReg);
        6: $display("%t nand %b %b - %b", $time, InA, InB, ALU_out);
        7: $display("%t or %b %b - %b", $time, InA, InB, ALU_out);
        8: $display("%t sll %b %b - %b", $time, InA, InB, ALU_out);
        9: $display("%t slr %b %b - %b", $time, InA, InB, ALU_out);
        10: $display("%t rst", $time);
        11: $display("%t halt", $time);
        12: $display("%t lkup %d - %d", $time, InB, AccReg);
        13: $display("%t lt %d %d - %d", $time, InA, InB, ALU_out);
        14: $display("%t eql %d %d - %d", $time, InA, InB, ALU_out);
      endcase
    end
    if (Start == 1)	   // if(start)
      CycleCt <= 0;
    else if(Ack == 0)   // if(!halt)
      CycleCt <= CycleCt+16'b1;
  end

endmodule
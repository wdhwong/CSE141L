`timescale 1ns/ 1ps

module InstFetch_tb;
reg Reset;
reg Start;
reg Clk;
reg Branch;
reg [9:0] Target;
wire [9:0] PC;

// Testing IF
InstFetch uut(
  .Reset (Reset),
  .Start (Start),
  .Clk (Clk),
  .Branch (Branch),
  .Target (Target),
  .ProgCtr (PC)
);

always #5 Clk = ~Clk;

initial begin
  Clk = 0;

  // Reset
  Reset = 1;
  #5;
  check_if_func;
  Reset = 0;

  // Increment
  check_if_func;
  #15;

  // Branch
  Branch = 1;
  Target = 9'b000001000;
  #5;
  check_if_func;
  Branch = 0;

  $stop;
end

task check_if_func;
  begin
    #1;
    $display("%t inputs = %b %b %b %b %h, PC = %h",$time, Reset, Start, Clk, Branch, Target, PC);
  end
endtask
endmodule
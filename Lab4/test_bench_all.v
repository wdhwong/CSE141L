// CSE141L  Fall 2020
// test bench to be used to verify student projects
// pulses start while loading program 1 operand into DUT
//  waits for done pulse from DUT
//  reads and verifies result from DUT against its own computation
// pulses start while loading program 2 operands into DUT
//  waits for done pulse from DUT
//  reads and verifies result from DUT against its own computation
// pulses start while loading program 3 operand into DUT
//  waits for done pulse from DUT
//  reads and verifies result from DUT against its own computation
 // Based on SystemVerilog source code provided by John Eldon
module test_bench_all();


  reg      clk   = 1'b0   ;      // advances simulation step-by-step
  reg           init  = 1'b1   ;      // init (reset) command to DUT
  reg           start = 1'b1   ;      // req (start program) command to DUT
  wire       done           ;      // done flag returned by DUT


// ***** instantiate your own top level design here *****
  CPU dut(
    .Clk     (clk  ),   // input: use your own port names, if different
    .Reset    (init ),   // input: some prefer to call this ".reset"
    .Start     (start),   // input: launch program
    .Ack     (done )    // output: "program run complete"
  );

// program 1 variables
reg[63:0] dividend;      // fixed for pgm 1 at 64'h8000_0000_0000_0000;
reg[15:0] divisor1;	   // divisor 1 (sole operand for 1/x) to DUT
reg[63:0] quotient1;	   // internal wide-precision result
reg[15:0] result1,	   // desired final result, rounded to 16 bits
            result1_DUT;   // actual result from DUT
real quotientR;			   // quotient in $real format


// program 2 variables
reg[15:0] div_in2;	   // dividend 2 to DUT
reg[ 7:0] divisor2;	   // divisor 2 to DUT
reg[23:0] result2,	   // desired final result, rounded to 24 bits
            result2_DUT;   // actual result from DUT
			
// program 3 variables
reg[15:0] dat_in3;	   // operand to DUT
reg[ 7:0] result3;	   // expected SQRT(operand) result from DUT
reg[47:0] square3;	   // internal expansion of operand
reg[ 7:0] result3_DUT;   // actual SQRT(operand) result from DUT
real argument, result, 	   // reals used in test bench square root algorithm
     error, result_new;
	 
// clock -- controls all timing, data flow in hardware and test bench
always begin
       clk = 0;
  #5; clk = 1;
  #5;
end

initial begin

// launch program 1
  start = 1;
  dividend = 64'h8000_0000_0000_0000;	   // this is 1.000000000
  // *** try various values here ***
  divisor1 = 4;		// This is testing 1/4, which would produce hex value 2000        
// your memory gets loaded here
// *** change names of memory or its guts as needed ***
  dut.DM1.Core[8] = divisor1[15:8];
  dut.DM1.Core[9] = divisor1[ 7:0];
  if(divisor1) div1;										// regal value of nonzero vector = 1; 
  else result1 = '1;    // 1/0 = all 1's (maximum value; "saturating reg")
  #20; start = 0;
  #20;
  wait(done);
// your memory gets read here
// *** change names of memory or its guts as needed ***
  result1_DUT[15:8] = dut.DM1.Core[10];
  result1_DUT[ 7:0] = dut.DM1.Core[11];
  $display ("divisor = %h , quotient = %h , result1 = %h, equiv to %10.5f", 
    divisor1, quotient1, result1, quotientR); 
  if(result1==result1_DUT) $display("success -- match1");
  else $display("OOPS1! expected %h, got %h",result1,result1_DUT);
  
 
 // preload operands and launch program 2
  #10; start = 1;	
// The test below is calculating 3/255
// insert dividend and divisor
  div_in2 = 3;	   	// *** try various values here ***
  divisor2 = 8'hFF;		   // *** try various values here ***
// *** change names of memory or its guts as needed ***
  dut.DM1.Core[0] = div_in2[15:8];
  dut.DM1.Core[1] = div_in2[ 7:0];
  dut.DM1.Core[2] = divisor2;
  if(divisor2) div2; 							             // divisor2 is "true" only if nonzero
  else result2 = '1; // same as program 1: limit to max.
  #20; start = 0;
  #20; wait(done);
// *** change names of memory or its guts as needed ***
  result2_DUT[23:16] = dut.DM1.Core[4];
  result2_DUT[15: 8] = dut.DM1.Core[5];
  result2_DUT[ 7: 0] = dut.DM1.Core[6];
  $display ("dividend = %h, divisor2 = %h, quotient = %h, result2 = %h, equiv to %10.5f",
    dividend, divisor2, quotient1, result2, quotientR); 
  if(result2==result2_DUT) $display("success -- match2");
  else $display("OOPS2! expected %h, got %h",result2,result2_DUT); 
  
  
// preload operands and launch program 3
  #10; start = 1;
// insert operand
  dat_in3 = 81;// Max : 65535;		   // *** try various values here ***
// *** change names of memory or its guts as needed ***
  dut.DM1.Core[16] = dat_in3[15: 8];
  dut.DM1.Core[17] = dat_in3[ 7: 0]; 
  if(dat_in3==0) result3 = 0;   // trap 0 case up front
  else div3;
  #20; start = 0;
  #20; wait(done);
// *** change names of memory or its guts as needed ***
  result3_DUT = dut.DM1.Core[18];     
  $display("operand(hex) = %h, sqrt(hex) = %h",dat_in3,result3);
  if(result3==result3_DUT) $display("success -- match3");
  else $display("OOPS3! expected %h (hex), got %h",result3,result3_DUT);
  
  #10; $stop;
end

task automatic div1;
begin
  quotient1 = dividend/divisor1;			// Actually doing 1/ divisor to get a result to compare with your processor's division
  //result1 = quotient1[63:48]+quotient1[47]; // half-LSB upward rounding (Uncomment this line to use rounding)
  result1 = quotient1[63:48];                 // No Rounding
  quotientR = 1.00000/$itor(divisor1);
end
endtask


task automatic div2;
begin
  dividend = div_in2<<48;
  quotient1 = dividend/divisor2;
  //result2 = quotient1[63:40]+quotient1[39]; // half-LSB upward rounding (Uncomment this line to use rounding)
  result2 = quotient1[63:40];                 // No rounding
  quotientR = $itor(div_in2)/$itor(divisor2);
end
endtask


task automatic div3;
begin
  argument = $itor(dat_in3);
//  real error, result_new;
  result = 1.0;
  error = 1.0;
  while (error > 0.001) begin
    result_new = argument/2.0/result + result/2.0;
    error = (result_new - result)/result;
    if (error < 0.0) error = -error;
      result = result_new;
  end
  result3 = $rtoi(result);
  
  // The following two lines are for rounding. if you want to 'floor' instead, comment the two lines below
  if(!(&(result3))) 
    result3 = $rtoi(result+0.5);
	
end
endtask

endmodule
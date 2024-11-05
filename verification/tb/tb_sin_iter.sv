/*
 * This source file contains a Verilog description of an IP core
 * automatically generated by the Floating-Point Design Generator.
 *
 * Author: Xiaokun Yang and Maria Vega, University of Houston Clear Lake 
 * Date: June 2022
 *
 * For more information, see the project website at:
 * https://sceweb.sce.uhcl.edu/xiaokun/OpenIC/
 *
//   Latency: 1 cycle per addition
//   Precision: Single bit
//   Resources required: 16 adders (32 x 32 bit)
*/


module tb_Sin();
parameter TEST_SIZE = 9;
`ifdef SIN_N32_PD32_BW32
parameter LATENCY = 67;
`elsif SIN_N16_PD16_BW32
parameter LATENCY = 52;
`elsif SIN_N8_PD8_BW32
parameter LATENCY = 40;
`elsif SIN_N4_PD4_BW32
parameter LATENCY = 37;
`endif

parameter ERROR_TOLERANCE = 1;
localparam real PI = 3.141592653589793;
reg [31:0]  output_sin[TEST_SIZE-1:0]; 
reg [31:0]  input_theta[TEST_SIZE-1:0];

`include "tb_func.sv"

initial begin
   $readmemh("../golden/rtl-rand-theta-input.txt",input_theta);
   $readmemh("../golden/rtl-rand-sin-output.txt",output_sin);
end

reg         clock;
reg         reset;
reg  [31:0] io_in;
wire [31:0] io_out;

 always #5 clock = ~clock;

Sin u_Sin(
  .clock (clock ),
  .reset (reset ),
  .io_in (io_in ),
  .io_out(io_out)
);
  
integer i,j; 
real dut_in_real, golden_real, dut_out_real, error_percent;
initial begin
   reset = 1'b1;
   clock = 1'b0;
   io_in = 32'h0;  
   #2;
   reset = 1'b0;
   @(posedge clock);

  for (i=0; i < TEST_SIZE; i = i+1) begin
    io_in = input_theta[i];  
    dut_in_real=ieee754_to_fp(io_in)*180/PI;
    $display("At %dns, the input theta: %h and %f", $time, io_in, dut_in_real);
    @(posedge clock);
  end
end

initial begin
  wait (reset);
  @(negedge clock);
  repeat(LATENCY) @(negedge clock);
  for (j=0; j < TEST_SIZE; j = j+1) begin
      golden_real=ieee754_to_fp(output_sin[j]);
      dut_out_real=ieee754_to_fp(io_out);
      if(output_sin[j]==32'h248D3132) begin
        if((golden_real-dut_out_real<=0.00001)|(dut_out_real-golden_real<=0.00001)) begin //if less than 0.001 pass the test
          error_percent=1;
        end else begin
          error_percent=2;
        end
        //$display("Monitor at %dns, cos output: %f, expected: %f", $time, dut_out_real, golden_real);
      end else begin
        error_percent  = (dut_out_real-golden_real)/golden_real*100;
        if (error_percent < 0) begin
            error_percent  = -error_percent;
        end
      end

    if(error_percent<=ERROR_TOLERANCE) begin
      //$display("At %dns, the test case PASS! error_percent: %f, cos output: %h, expected: %h", $time, error_percent, io_out, output_cos[j]);
      $display("At %dns, the test case PASS! error_percent: %f, sin output: %f, expected: %f", $time, error_percent, dut_out_real, golden_real);
      //$display("At %dns, the test case Pass! error_percent: %f, cos output: %h", $time, error_percent, output_cos[j]);
      //$display("At %dns, the test case Pass! error_percent: %f, cos output: %f", $time, error_percent, golden_real);
    end else begin
      //$display("At %dns, the test case FAIL! error_percent: %f, cos output: %h, expected: %h", $time, error_percent, io_out, output_cos[j]);
      $display("At %dns, the test case FAIL! error_percent: %f, sin output: %f, expected: %f", $time, error_percent, dut_out_real, golden_real);
    end
    @(negedge clock);
  end
  
end
endmodule


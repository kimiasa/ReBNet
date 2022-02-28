
module pop_tb;

parameter weight_levels = 2;
parameter simd_width = 4;
parameter popcount_width = 8;

  reg clk = 1'b0;
  reg rst = 1'b0;
  reg start = 1'b0;
  reg [(weight_levels*simd_width)-1:0] in;
  reg [(popcount_width*simd_width)-1:0] gamma;
  wire [popcount_width-1:0] out;
  wire done;
	
PopCount #(weight_levels, simd_width, popcount_width) 
pp_tb 
		(clk,rst,start,in,gamma,out,done);
		  
initial
    begin 
	in = 8'b10110011; 
	gamma = 16'b1010101000110011;
 end
endmodule



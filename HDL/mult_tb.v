module mult_tb;

parameter weight_levels = 2;
parameter simd_width = 4;

  reg [(simd_width*2)-1:0] operand1;
  reg [simd_width-1:0] operand2;
  wire [simd_width-1:0] multiply_res;
	

  assign multiply_res = operand1 + operand2;
  
initial
    begin 
	operand1 = 8'd01010000; 
	operand2= 4'b0101;
 end
endmodule
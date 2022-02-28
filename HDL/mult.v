
module Mult
#(parameter 
weight_levels = 2,
simd_width = 32
)
(
  input [simd_width-1:0] operand1,
  input [(weight_levels*simd_width)-1:0] operand2,
  output [(weight_levels*simd_width)-1:0] multiply_res  
);
 

 
genvar w;
 
generate
	for (w=0; w < weight_levels; w = w+1) begin : xnor_res
		
		assign multiply_res[((w+1)*simd_width)-1:w*simd_width] = ~(operand1^operand2[((w+1)*simd_width)-1:w*simd_width]);

	end
endgenerate

endmodule

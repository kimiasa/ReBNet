module Reshape
#(parameter
binary_levels = 2,
simd_width = 32
)
(
  input [(simd_width*binary_levels)-1:0] in,
  output [(simd_width*binary_levels)-1:0] out
);

genvar indexOne, indexTwo; 

      
generate
	for (indexOne = 0; indexOne < binary_levels; indexOne = indexOne+1) begin : col
		for(indexTwo = 0; indexTwo < simd_width; indexTwo = indexTwo+1) begin : row
			assign out[(simd_width*indexOne)+indexTwo]= in[(binary_levels*indexTwo)+indexOne]; 
		end
	end
endgenerate

endmodule

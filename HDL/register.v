
module Register
//Parameters 
#(parameter
weight_levels = 2,
simd_width = 32 
)
//Arguments 
(
  input clk,
  input rst,
  input enable, 
  input [(simd_width*weight_levels)-1:0] in, 
  output [(simd_width*weight_levels)-1:0] out
);

  reg [(simd_width*weight_levels)-1:0] outReg;

always @(posedge clk) 
    begin 
		if (rst) begin
			outReg <= 0; 
		end
		else begin
			if(enable) begin
				outReg <= in;
			end
		end
    end
	
  assign out = outReg;
  
      
endmodule
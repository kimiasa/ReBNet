
module PopCount
#(parameter 
weight_levels = 2,
simd_width = 32,
popcount_width = 16,
Twidth = 24,
fixed_point = 8
)
(
	input clk,
	input rst,
	input start,
	input [(weight_levels*simd_width)-1:0] xnor_res,
	input signed [(Twidth*weight_levels)-1:0] weightGamma,
	output signed [popcount_width-1:0] popcount_res,
	output Done
);

reg signed [popcount_width-1:0] res [weight_levels-1:0];
reg signed [popcount_width-1:0] bet [weight_levels-1:0];
reg signed [Twidth-1:0] weis [weight_levels-1:0];
reg signed [popcount_width-1:0] afterGamma; 
integer i,j,init;


always @(*)

	begin
		if(rst) begin
					
			afterGamma = 0;
			for (init=0; init<weight_levels; init=init+1) begin
				res[init] = 0;
				weis[init] = 0;
				bet[init] = 0;
			end
		end
		
		else begin
		
			if(start) begin
			
				for (j=0; j<weight_levels; j=j+1) begin : first
					for (i=0; i<simd_width; i=i+1) begin : second
						
						res[j] = res[j] + xnor_res[(j*simd_width)+i];
				end
				
				//res[j] = (2*res[j]) - simd_width;
				weis[j] = weightGamma[j*Twidth +: Twidth] >>> ((Twidth-popcount_width)+fixed_point);
				bet[j] = res[j] * weis[j]; 
				afterGamma = afterGamma + bet[j]; 
		
				end
			end
			
			else begin
				afterGamma = 0;
				for (init=0; init<weight_levels; init=init+1) begin
					res[init] = 0;
					weis[init] = 0;
					bet[init] = 0;
				end
			end
		end
	end 
	
	assign popcount_res = afterGamma;

endmodule

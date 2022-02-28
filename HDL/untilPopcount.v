
module Until_Popcount
#(parameter
popcount_width = 16,
simd_width = 32,
weight_levels = 2,
binary_input_levels = 2,
Twidth = 24,
fixed_point = 8
)
(
	input clk,
	input rst,
	input pcnt,
	input continueAcc,
	input addPcnts,
	input [simd_width-1:0] inputKernel, 
	input [(simd_width*weight_levels)-1:0] weightMemory,
	input signed [(Twidth*weight_levels)-1:0] weightGamma,
	input signed [Twidth-1:0] thisLayerGamma, 
	output pcntDone,
	output accDone,
	output signed [Twidth-1:0] outFixedPoint
); 

wire [(simd_width*weight_levels)-1:0] outPixel, inPixel;
wire signed [popcount_width-1:0] outPopcount;
wire signed [(weight_levels*popcount_width)-1:0] weightGammaReduced;
wire signed [popcount_width-1:0] outAcced;
wire signed [Twidth-1:0] TwidthAcced ;
wire signed [Twidth-1:0] gamma ;
wire pDone;
wire aDone;

	Mult #(weight_levels,simd_width) mult(inputKernel,weightMemory,outPixel); 
	Register #(weight_levels,simd_width) save(clk,rst,addPcnts,outPixel,inPixel);
	PopCount #(weight_levels,simd_width,popcount_width,Twidth,fixed_point) popcnt(clk,rst,pcnt,inPixel,weightGamma,outPopcount,pDone);
	Accumulator #(popcount_width) acc(clk,rst,continueAcc,outPopcount,outAcced,aDone);
	
	assign weightGammaReduced = weightGamma >>> (Twidth-popcount_width);
	assign pcntDone = pDone;
	assign accDone = aDone;
	assign TwidthAcced = outAcced >>> (Twidth-popcount_width); // ??
	assign gamma =  thisLayerGamma >>> ((Twidth-popcount_width)+fixed_point); 
	assign outFixedPoint = TwidthAcced;
	//* thisLayerGamma;  edame jomle ghabl
      
endmodule


//https://forums.xilinx.com/t5/Design-Entry/Verilog-Loop-error-range-must-be-bounded-by-constant-expressions/td-p/721765


module PEDesign

#(parameter
weight_levels = 2,
binary_input_levels = 2,
binary_output_levels = 2,
Twidth = 24,
popcount_width = 16,
simd_width = 32, 
synopseFold = 18,
weight_address = 12,
input_address = 12,
output_channels = 1,
fixed_point = 8
)
(
  input clk,
  input rst,
  input isPixelIn,  
  input [input_address-1:0] firstInputAddress, 
  input [weight_address-1:0] firstWeightAddress, 
  input signed [Twidth-1:0] thisPEalpha,
  input signed [Twidth-1:0] thisPEthreshold,
  input signed [(Twidth*weight_levels)-1:0] weightGamma, 
  input signed [(Twidth*binary_input_levels)-1:0] inputGamma, 
  input signed [(Twidth*binary_output_levels)-1:0] outputGamma,
  output [binary_output_levels-1:0] outputPixelOneBit,
  output signed [(Twidth*binary_output_levels)-1:0] outputFixedPoint,
  output nextPixelCanCome
); 

wire cntDone, isCount,isRead,continuePcnt,continueAcc,binarizeStart,addPcnts,readDone,pcntDone,readyToPick,accDone,finishAll;


	PE_DataPath #(weight_levels,binary_input_levels,binary_output_levels,Twidth,popcount_width,simd_width,synopseFold,weight_address,input_address,output_channels) dp
	( 
		clk,
		rst,
		isCount,
		firstInputAddress,
		firstWeightAddress,
		isRead,
		continuePcnt,
		continueAcc,
		binarizeStart,
		thisPEalpha,
		thisPEthreshold,
		weightGamma,
		inputGamma,
		addPcnts,  // ezafe
		outputGamma,
		cntDone, // out
		readDone, 
		readyToPick,
		pcntDone,
		accDone,
		outputPixelOneBit, 
		outputFixedPoint, 
		finishAll
	);

	PE_Controller controller
	(
		clk,
		rst,
		isPixelIn,
		cntDone,
		readDone,
		readyToPick,
		pcntDone,
		accDone,
		finishAll,
		isCount,
		isRead,
		continuePcnt,
		continueAcc,
		binarizeStart,
		addPcnts, // ezafe
		nextPixelCanCome
	);
	
endmodule

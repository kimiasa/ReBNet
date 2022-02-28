
module PE_DataPath

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
  input isCount,
  input [input_address-1:0] firstInputAddress,
  input [weight_address-1:0] firstWeightAddress,
  input isRead, 
  input continuePcnt,
  input continueAcc,
  input binarizeStart,
  input signed [Twidth-1:0] thisPEalpha,
  input signed [Twidth-1:0] thisPEthreshold,
  input signed [(Twidth*weight_levels)-1:0] weightGamma,
  input signed [(Twidth*binary_input_levels)-1:0] inputGamma, 
  input addPcnts,
  input signed [(Twidth*binary_output_levels)-1:0] outputGamma,
  output cntDone,
  output readDone,
  output readyToPick,
  output pcntDone,
  output accDone,
  output [binary_output_levels-1:0] outputPixelBit,
  output signed [(Twidth*binary_output_levels)-1:0] outputFixedPoint,
  output finishAll
); 

wire RW, inputReadDone, weightReadDone, inputReadyToPick, weightReadyToPick, cntDoneIn, cntDoneWei;
wire [binary_output_levels-1:0] finishLevel; 
wire [(simd_width*binary_input_levels)-1:0] inputKernel, inputKernelRaw;
wire [(simd_width*weight_levels)-1:0] filter ,filterRaw;
wire [input_address-1:0] inputAddressOut;
wire [weight_address-1:0] weightAddressOut;
reg signed [Twidth-1:0] acced;
wire signed [Twidth-1:0] outFromBN;
wire signed[(Twidth*binary_input_levels)-1:0] outFixedPoint;
genvar level_in;
integer level_add;

	assign RW = 1;
	assign readDone = inputReadDone & weightReadDone;
	assign cntDone = cntDoneIn & cntDoneWei;
	assign readyToPick = inputReadyToPick & weightReadyToPick;
	
	Address_Generator #(synopseFold,input_address) addgenin
	( 
	clk,
	rst,
	isCount, 
	firstInputAddress, 
	inputAddressOut,
	cntDoneIn,
	inputReadDone
	);

	Input_Buffer #(input_address,synopseFold,simd_width,binary_input_levels) inbuf
	(
	clk,
	rst,
	isRead,
	RW, // 1 = read 0 = write
	inputAddressOut,
	inputKernelRaw,
	inputReadyToPick
	);
	
	Address_Generator #(synopseFold,weight_address) addgenwei
	(
	clk,
	rst,
	isCount, 
	firstWeightAddress, 
	weightAddressOut, 
	cntDoneWei,
	weightReadDone
	);

	Weight_Memory #(weight_address,synopseFold,simd_width,weight_levels,output_channels) weimem 
	(
	clk,
	rst,
	isRead,
    weightAddressOut,
    filterRaw,
	weightReadyToPick
	);
	
	Reshape #(binary_input_levels,simd_width) reshInput 
	(
	inputKernelRaw,
	inputKernel
	);
	
	Reshape #(weight_levels,simd_width) reshWeight 
	(
	filterRaw,
	filter
	);
	
		
generate
	for (level_in=0; level_in<binary_input_levels; level_in=level_in+1) begin : levelize
		
		Until_Popcount #(popcount_width,simd_width,weight_levels,binary_input_levels,Twidth) befppcnt
		(
		clk,
		rst,
		continuePcnt,
		continueAcc,
		addPcnts,
		inputKernel[(simd_width*(level_in+1))-1:simd_width*level_in],
		filter,
		weightGamma,
		inputGamma[(Twidth*(level_in+1))-1:(Twidth*level_in)],
		pcntDone,
		accDone,
		outFixedPoint[(Twidth*(level_in+1))-1:(Twidth*level_in)]
		);
		
	end
endgenerate

always @(*)
	
	if(rst) begin
		acced = 0;
	end
	
	else begin 	
		for (level_add=0; level_add<binary_input_levels; level_add=level_add+1) begin : addVec
		
			acced = acced + outFixedPoint[Twidth*level_add +: Twidth];
		
		end
	end

	BatchNormalization #(Twidth) bn(acced,thisPEalpha,thisPEthreshold,outFromBN);
	
	After_Popcount #(Twidth,binary_output_levels) aftppcnt
	(
	clk,
	rst,
	binarizeStart,
	outFromBN,
	outputGamma,
	outputFixedPoint,
	outputPixelBit,
	finishAll
	); 
	
endmodule



module pe_tb;

parameter weight_levels = 2;
parameter binary_input_levels = 2;
parameter binary_output_levels = 2;
parameter Twidth = 24;
parameter popcount_width = 16;
parameter simd_width = 32; 
parameter synopseFold = 18;
parameter weight_address = 12;
parameter input_address = 12;
parameter output_channels = 1;

reg clk = 1'b0;
reg RST_n,start;
//reg [input_address-1:0] din;
//reg [weight_address-1:0] weight;
//reg [Twidth-1:0] alpha,threshold;
//reg [Twidth-1:0] w_gamma;
//reg [Twidth-1:0] i_gamma;
//reg [Twidth-1:0] o_gamma;
wire next;
wire [binary_output_levels-1:0] dout;
wire [(Twidth*binary_output_levels)-1:0] fixed_point_out;

	
PEDesign #(weight_levels, binary_input_levels, binary_output_levels, Twidth, popcount_width, simd_width, synopseFold, weight_address, input_address, output_channels) 
pedesign 
		(.clk(clk), 
		.rst(RST_n), 
		.isPixelIn(start), 
		.firstInputAddress(0), 
		.firstWeightAddress(0), 
		.thisPEalpha(1),
		.thisPEthreshold(0),
		.weightGamma(48'b010000000000000000000000010000000000000000000000),
		.inputGamma(48'b010000000000000000000000010000000000000000000000),
		.outputGamma(48'b010000000000000000000000010000000000000000000000),
		.outputPixelOneBit(dout),
		.outputFixedPoint(fixed_point_out),
		.nextPixelCanCome(next)
	);
  
initial begin	
	      
		  repeat (100000)
			#50 clk = !clk;
end

initial
    begin 
	RST_n = 1'b1; 
    #800;
    RST_n = 1'b0;
    #600;
    start= 1'b1;
    #500;
	start=1'b0;
	#100;
 end
endmodule
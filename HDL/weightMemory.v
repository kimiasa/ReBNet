module Weight_Memory
#(parameter
address_width = 12,
synopseFold = 18,
simd_width = 32,
weight_levels = 2,
output_channels = 1 
)
(
	input clk,
    input rst,
    input enable,
    input [address_width-1:0] address,
    output [(simd_width*weight_levels)-1:0] read_data,
	output readReady
);

reg [(simd_width*weight_levels)-1:0] weightMem [(synopseFold*output_channels)-1:0];

reg [(simd_width*weight_levels)-1:0] dataOut;
reg readyToRead;


initial begin
 $readmemb("weights.bin", weightMem);
end

always @(posedge clk)
begin
    if (rst)
    begin
		dataOut <= 0;
		readyToRead <= 0;
    end
    else
    begin
        if(enable)
			begin
				dataOut <= weightMem[address];
				readyToRead <= 1;
			end
		else
			begin
				dataOut <=0;
				readyToRead <=0;
			end
    end
end
 
	assign read_data = dataOut;
	assign readReady = readyToRead;
	
endmodule
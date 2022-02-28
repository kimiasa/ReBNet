module Input_Buffer
#(parameter
address_width = 12,
synopseFold = 18,
simd_width = 32,
binary_input_levels = 2 
)
(
	input clk,
    input rst,
    input enable,
    input rwEn,
    input [address_width-1:0] address,
    inout [(simd_width*binary_input_levels)-1:0] data,
	output ready
);

reg [(simd_width*binary_input_levels)-1:0] inputBuffer [synopseFold-1:0];

reg [(simd_width*binary_input_levels)-1:0] dataOut;
reg readyToRead;
reg written;

integer i;

initial begin
 $readmemb("inputs.bin", inputBuffer);
end

always @(posedge clk)
begin
    if (rst)
    begin
		dataOut <= 0;
		readyToRead <= 0;
		written <= 0;
        //for(i=0; i<synopseFold; i=i+1)
        //    inputBuffer[i] <= 0;
    end
    else
    begin
        if(enable)
            if(rwEn) // read
			begin
				dataOut <= inputBuffer[address];
				readyToRead <= 1;
			end
			else
			begin
				inputBuffer[address] <= data;
				written <= 1;
			end
		else
		begin
			dataOut <=0;
			written <=0;
			readyToRead <=0;
		end
    end
end

	assign data = dataOut;
	assign ready = readyToRead | written;
 
endmodule
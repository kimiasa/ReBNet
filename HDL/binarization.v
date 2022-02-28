
module After_Popcount
//Parameters
#(parameter
Twidth = 24,
binary_output_levels = 2,
fixed_point = 8
)
//Arguments 
(
  input clk,
  input rst,
  input start,
  input signed [Twidth-1:0] inputPixel, 
  input signed [(Twidth*binary_output_levels)-1:0] nextLayerGamma, 
  output signed [(Twidth*binary_output_levels)-1:0] outputPixel,
  output [binary_output_levels-1:0] outBitPixel, 
  output finisiBinarize
); 

reg signed [(Twidth*binary_output_levels)-1:0] outputFixedPoint;
reg signed [Twidth-1:0] levelOutput;
reg [binary_output_levels-1:0] counter, bitOutput;
reg finish,levelBit;

always @(posedge clk) 
begin 
    if (rst) begin
		counter <= 0;
		levelOutput <= 0; 
		finish <= 0;
		outputFixedPoint <= 0;
		bitOutput <= 0;
		levelBit <= 0;
	end
     
	else begin
		if(start) begin
			counter <= counter + 1;
			if((counter - binary_output_levels) == 0) begin
				counter <= 0;
				finish <= 1;
				levelOutput <= 0;
				outputFixedPoint <= 0;
				bitOutput <= 0;
				levelBit <= 0;
			end
			else begin
				if(counter == 0) begin
					levelOutput <= inputPixel;
					bitOutput[counter] <= ~(inputPixel[Twidth-1]); 
				end
				else begin
					if(levelOutput[Twidth-1]) begin
						levelOutput <= levelOutput-nextLayerGamma;
					end
					else begin
						levelOutput <= levelOutput+nextLayerGamma;
					end
				end

			levelBit <= ~(levelOutput[Twidth-1]); 
			outputFixedPoint <= outputFixedPoint + (levelOutput <<< (counter*Twidth));
			bitOutput[counter] <= levelBit;
			finish <=0; 
					   
			end		
	end
		//finisiBinarize <= finish;
		//outBitPixel <= bitOutput;
		//outputPixel <= outputFixedPoint;
end

	assign finisiBinarize = finish; 
    assign outBitPixel = bitOutput;
	assign outputPixel = outputFixedPoint;
      

endmodule




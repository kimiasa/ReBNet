
module Address_Generator
//Parameters 
#(parameter
synopseFold = 18,
address_width = 12 
)
//Arguments 
(
  input clk,
  input rst,
  input nextCntIn, 
  input [address_width-1:0] baseAddress, 
  output [address_width-1:0] outAddress,
  output done,
  output finishCnt 
);

//Var Declaration
 
reg [address_width-1:0] counter;
reg finish,cntDone;

// Def

always @(posedge clk) 
    begin 
		if (rst) begin
			counter <= 0; 
			finish <= 0;
			cntDone <= 0;
		end
		else begin
			if(nextCntIn) begin
					counter <= counter + 1;
					if((counter - baseAddress) == (synopseFold - 1)) begin
						counter <= 0;
						finish <= 1;
						cntDone <= 0;
					end
					else cntDone <= 1;
			end
			else begin 
				cntDone <= 0;
				finish <=0;
			end
		end
    end
	
  assign outAddress = counter+baseAddress;
  assign finishCnt = finish;
  assign done = cntDone;
  
      
endmodule
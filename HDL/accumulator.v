
module Accumulator
//Parameters 
#(parameter
popcount_width = 16
)
//Arguments 
(
  input clk,
  input rst,
  input continueAcc, 
  input signed [popcount_width-1:0] outPopcount, 
  output signed [popcount_width-1:0] outAcced,
  output accDone 
); 

//Var Declaration
 
reg signed [popcount_width-1:0] acced;
reg done;

// Def

always @(posedge clk) 
    begin 
      if (rst) 
		begin
			acced <= 0; 
			done <= 0;
		end
      else 
		begin
		  if(continueAcc)
				begin
					acced <= acced + outPopcount;
					done <= 1;
				end
		else done <= 0;
    end
				
    end
	
  assign outAcced = acced;
  assign accDone = done;
      
endmodule
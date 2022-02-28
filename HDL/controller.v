
module PE_Controller
(
  input clk,
  input rst,
  input start,
  input cntDone,  
  input readDone, 
  input readyToPick, 
  input pcntDone, 
  input accDone, 
  input finishAll, 
  output isCount,
  output isRead,
  output continuePcnt,
  output continueAcc,
  output binarizeStart,
  output addPcnts,
  output finish
); 
parameter SIZE = 10;
parameter 
	WaitForStart  = 10'b0000000000,
	ReadyToRead = 10'b0000000010,
	ReadFromMem = 10'b0000000100,
	Popcount = 10'b0000001000,
	Dummy1 = 10'b0000010000,
	Accumulate = 10'b0000100000,
	Dummy2 = 10'b0001000000,
	Binarize = 10'b0010000000,
	Finish = 10'b0100000000,
	Wrong = 10'b10000000000;
	
reg	[SIZE-1:0]	state;
reg	[SIZE-1:0]	next_state;

always @ (posedge clk, posedge rst)
	begin 
		if(rst)  
			state <= WaitForStart;
		else
			state <= next_state;
	end


always @ (state, start, cntDone, readDone, readyToPick, pcntDone, accDone, finishAll)
begin

next_state = 10'b0;

 case(state)
 
	WaitForStart : begin
				if (start) 
					next_state = ReadFromMem;
				else
					next_state = WaitForStart;  
			end
			
	ReadyToRead : begin 
				if (cntDone && readDone) 
					next_state = Wrong;
				else if(cntDone && ~readDone)  
					next_state = ReadFromMem;
				else if(~cntDone && readDone)  
					next_state = Dummy2;
				else if(~cntDone && ~readDone)  
					next_state = ReadyToRead;
			end  
			  
	ReadFromMem : begin
				if (readyToPick) 
					next_state = Popcount; 
				else if (readyToPick) 
					next_state = ReadFromMem;
			end  
			  
	Popcount : begin
				next_state = Dummy1;
				//{isCount,isRead,continuePcnt,continueAcc,binarizeStart,addPcnts,finish} = 7'b0000000;
			end
				
	Dummy1 : begin 
	            next_state = Accumulate;
                //{isCount,isRead,continuePcnt,continueAcc,binarizeStart,addPcnts,finish} = 7'b0001000;
			end
				
	Accumulate : begin 
				if (accDone == 1'b1) begin
					next_state = ReadyToRead;
					//{isCount,isRead,continuePcnt,continueAcc,binarizeStart,addPcnts,finish} = 7'b1000000;
				end 
				//if (accDone == 1'b1 && readDone == 1'b1) begin
				//	next_state = Dummy2;
					//{isCount,isRead,continuePcnt,continueAcc,binarizeStart,addPcnts,finish} = 7'b0000000;
				//end
				else if (accDone == 1'b0) begin
					next_state = Accumulate;
					//{isCount,isRead,continuePcnt,continueAcc,binarizeStart,addPcnts,finish} = 7'b0000000;
				end
			end
			
	Dummy2 : begin
				next_state = Binarize;
				//{isCount,isRead,continuePcnt,continueAcc,binarizeStart,addPcnts,finish} = 7'b0000100;
            end
		   
	Binarize : begin
				if (finishAll == 1'b1) begin
					next_state = Finish;
					//{isCount,isRead,continuePcnt,continueAcc,binarizeStart,addPcnts,finish} = 7'b0000100;
				end 
				else if (finishAll == 1'b0) begin
					next_state = Binarize;
					//{isCount,isRead,continuePcnt,continueAcc,binarizeStart,addPcnts,finish} = 7'b0000000;
				end
			end
			  
	Finish : begin
				next_state = WaitForStart;
				//{isCount,isRead,continuePcnt,continueAcc,binarizeStart,addPcnts,finish} = 7'b0000001;
            end
	
	Wrong : begin 
				next_state = Wrong;
				//{isCount,isRead,continuePcnt,continueAcc,binarizeStart,addPcnts,finish} = 7'b0000000;
            end
			
   default : begin 
				next_state = WaitForStart;
				//{isCount,isRead,continuePcnt,continueAcc,binarizeStart,addPcnts,finish} = 7'b0000000;
			end
			
endcase
end
	assign isCount = ( ( state == Accumulate ) & accDone ) ? 1 : 0;
	assign isRead = ( ( ( state == WaitForStart ) & start ) | ( ( state == ReadyToRead ) & cntDone ) ) ? 1 : 0;
	assign continueAcc = ( state == Dummy1 ) ? 1 : 0;
	assign binarizeStart = ( ( state == Dummy2 ) | ( ( state == Binarize ) & ~finishAll ) ) ? 1 : 0;
	assign finish = ( state == Finish ) ? 1 : 0;
	assign continuePcnt = ( (state == Popcount) | (state == Dummy1) ) ? 1 : 0;
	assign addPcnts = ( state == ReadFromMem ) ? 1 : 0;

endmodule










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
  output reg isCount,
  output reg isRead,
  output reg continuePcnt,
  output reg continueAcc,
  output reg binarizeStart,
  output reg addPcnts,
  output reg finish
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


always @ (posedge clk)
begin  
if (rst == 1'b1) begin
  state = WaitForStart;
  isCount = 0;
  isRead = 0;
  continuePcnt = 0;
  continueAcc = 0;
  binarizeStart = 0;
  addPcnts = 0;
  finish = 0;
end else
begin
 case(state)
 
	WaitForStart : begin
				if (start == 1'b1) begin
					next_state = ReadFromMem;
					{isCount,isRead,continuePcnt,continueAcc,binarizeStart,addPcnts,finish} = 7'b0100000;
				end 
				else if (start == 1'b0) begin
					next_state = WaitForStart;
					{isCount,isRead,continuePcnt,continueAcc,binarizeStart,addPcnts,finish} = 7'b0000000;
				end  
			end
			
	ReadyToRead : begin 
				if (cntDone == 1'b1) begin
					next_state = ReadFromMem;
					{isCount,isRead,continuePcnt,continueAcc,binarizeStart,addPcnts,finish} = 7'b0100000;
				end
				else if(cntDone == 1'b0) begin 
					next_state = ReadyToRead;
					{isCount,isRead,continuePcnt,continueAcc,binarizeStart,addPcnts,finish} = 7'b0000000;
				end 
			end  
			  
	ReadFromMem : begin
				if (readyToPick == 1'b1) begin
					next_state = Popcount;
					{isCount,isRead,continuePcnt,continueAcc,binarizeStart,addPcnts,finish} = 7'b0000000;
				end 
				else if (readyToPick == 1'b0) begin
					next_state = ReadFromMem;
					{isCount,isRead,continuePcnt,continueAcc,binarizeStart,addPcnts,finish} = 7'b0000000;
				end
			end  
			  
	Popcount : begin
                next_state = Dummy1;
				{isCount,isRead,continuePcnt,continueAcc,binarizeStart,addPcnts,finish} = 7'b0000000;
			end
				
	Dummy1 : begin 
                next_state = Accumulate;
				{isCount,isRead,continuePcnt,continueAcc,binarizeStart,addPcnts,finish} = 7'b0001000;
			end
				
	Accumulate : begin 
				if (accDone == 1'b1 && readDone == 1'b0) begin
					next_state = ReadyToRead;
					{isCount,isRead,continuePcnt,continueAcc,binarizeStart,addPcnts,finish} = 7'b1000000;
				end 
				if (accDone == 1'b1 && readDone == 1'b1) begin
					next_state = Dummy2;
					{isCount,isRead,continuePcnt,continueAcc,binarizeStart,addPcnts,finish} = 7'b0000000;
				end
				else if (accDone == 1'b0) begin
					next_state = Accumulate;
					{isCount,isRead,continuePcnt,continueAcc,binarizeStart,addPcnts,finish} = 7'b0000000;
				end
			end
			
	Dummy2 : begin
				next_state = Binarize;
				{isCount,isRead,continuePcnt,continueAcc,binarizeStart,addPcnts,finish} = 7'b0000100;
            end
		   
	Binarize : begin
				if (finishAll == 1'b1) begin
					next_state = Finish;
					{isCount,isRead,continuePcnt,continueAcc,binarizeStart,addPcnts,finish} = 7'b0000100;
				end 
				else if (finishAll == 1'b0) begin
					next_state = Binarize;
					{isCount,isRead,continuePcnt,continueAcc,binarizeStart,addPcnts,finish} = 7'b0000000;
				end
			end
			  
	Finish : begin
				next_state = WaitForStart;
				{isCount,isRead,continuePcnt,continueAcc,binarizeStart,addPcnts,finish} = 7'b0000001;
            end
	
	Wrong : begin 
				next_state = Wrong;
				{isCount,isRead,continuePcnt,continueAcc,binarizeStart,addPcnts,finish} = 7'b0000000;
            end
			
   default : begin 
				next_state = WaitForStart;
				{isCount,isRead,continuePcnt,continueAcc,binarizeStart,addPcnts,finish} = 7'b0000000;
			end
			
endcase
end
end

endmodule









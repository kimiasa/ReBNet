module c_tb;


reg clk,RST_n,read,en;
wire count,read_en,pcnt,acc_en,bin,pcnt_en,fin_en;
	
PE_Controller 
control(
		.clk(clk), 
		.rst(RST_n), 
		.start(en),
		.readDone(read), 
		.readyToPick(1'b0), 
		.pcntDone(1'b0), 
		.accDone(1'b0),
		.finishAll(1'b0),
		.isCount(count),
		.isRead(read_en),
		.continuePcnt(pcnt),
		.continueAcc(acc_en),
		.binarizeStart(bin),
		.addPcnts(pcnt_en),
		.finish(fin_en)
	);
	 
always begin	
	#100 clk=0;
	#100 clk=1;
end

initial
    begin 
	RST_n = 1'b1; 
    #600;
    RST_n = 1'b0;
    #400;
	en = 1'b1;
	#300;
	en = 1'b0;
	#300;
    read= 1'b1;
    #200;
	read=1'b0;
	#200;
 end
endmodule
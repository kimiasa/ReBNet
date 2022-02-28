
module buffer_tb;

parameter address_width = 12;
parameter synopseFold = 18;
parameter simd_width = 32;
parameter binary_input_levels = 2;

  reg clk = 1'b0;
  reg rst,enable,rwEn;
  reg [address_width-1:0] address;
  wire [(simd_width*binary_input_levels)-1:0] data;
  wire ready;
	
Input_Buffer #(address_width, synopseFold, simd_width, binary_input_levels) buf_tb 
	
	(clk, rst, enable, rwEn, address, data, ready);
    
	initial
    begin
 
      repeat (1000)
        #50 clk = !clk;
    end
  
	initial
	begin 
		rwEn = 1'b1;
		address = 2;
		rst = 1'b1; 
		#150;
		rst = 1'b0;
		#100;
		enable = 1'b1;
		#350;
		enable = 1'b0;
		#200;
	end
endmodule
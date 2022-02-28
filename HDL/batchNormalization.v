
module BatchNormalization
#(parameter
Twidth = 24,
fixed_point = 8
)
(
	input signed [Twidth-1:0] in,
	input signed [Twidth-1:0] alpha,
	input signed [Twidth-1:0] threshold,
	output signed [Twidth-1:0] out
);
 
	assign out = in - threshold;

endmodule


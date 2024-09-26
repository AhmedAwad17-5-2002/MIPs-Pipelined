module shifter #(parameter SIZE_IN=32,
	                       SIZE_OUT=32) 
(
	input [SIZE_IN-1:0] in,
	output [SIZE_OUT-1:0] out
);

assign out = {in,2'b00} ;

endmodule
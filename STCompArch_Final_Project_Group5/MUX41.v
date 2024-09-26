module Mux_4X1 (
	input [31:0] in0,in1,in2,
	input [1:0] sel,
	output reg [31:0] out 
);

always @(*) begin : Mux_4x1
	if(sel==00)
		out=in0;
	else if (sel == 1)
	    out = in1;
    else if (sel == 2)
		out = in2;
    else 
	    out = 0;
end
endmodule
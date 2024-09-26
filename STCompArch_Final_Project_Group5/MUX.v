module MUX #(parameter SIZE=32)(
	input [SIZE-1:0] in0,in1,
	input sel,
	output reg [SIZE-1:0] out 
);

always @(*) begin : proc_MUX
	if(sel==0)
		out=in0;
	else
		out=in1;
end

endmodule
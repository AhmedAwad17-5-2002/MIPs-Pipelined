module register_file (
	input [4:0] A1,A2,A3,
	input CLK,
	input [31:0] WD3,
	input WE3,
        output [3:0] REG_LED,

	output [31:0] RD1,RD2
);

reg [31:0] mem [31:0];


always @(negedge CLK) begin
	if(WE3) 
		mem[A3] <= WD3;
end



assign RD1 = (A1==0)? 0 : mem[A1];
assign RD2 = (A2==0)? 0 : mem[A2];
assign REG_LED=mem[16];
endmodule
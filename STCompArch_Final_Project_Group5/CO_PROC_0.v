module CO_PROC_0 (
	input CLK,    // Clock
	input rst_n,  // Asynchronous reset active low
    
    input mtc0,
    input [4:0] w_Addr,
    input [31:0] d_in,
	input [31:0] PC,
	input EPCWrite,
	input [1:0]IntCause,
	input CauseWrite,
	// input [4:0]selction_C0, // RD

	output [31:0] C0
);

reg  [31:0] Cause,EPC;
reg  [31:0] mem_C0 [31:0];
wire [31:0] Pre_Cause;

always @(posedge CLK) begin
	if(~rst_n) begin
		Cause <= 0;
		EPC <= 0;
	end else  begin
		if(EPCWrite)
			mem_C0[14] <= PC;
		if(CauseWrite)
			mem_C0[13] <= Pre_Cause;
		if(mtc0 && w_Addr!=13 && w_Addr!=14)
			mem_C0[w_Addr]<= d_in;
	end
end

assign Pre_Cause=(IntCause==0)? 32'h00 :(IntCause==1)? 32'h24 :(IntCause==2)? 32'h28 : 32'h30;
assign C0 = mem_C0[w_Addr];

endmodule
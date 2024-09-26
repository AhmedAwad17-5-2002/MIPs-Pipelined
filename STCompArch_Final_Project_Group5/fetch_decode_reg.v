module fetch_Decode (
	input clk,    // Clock
	input EN1,
	input CLR,
	input rst_n,
    
    input [31:0] inst_R_F,
    input [31:0] PCPlus4_F,

    output reg [31:0] inst_R_D,
    output reg [31:0] PCPlus4_D
);

always @(posedge clk or negedge rst_n) begin
	if(~rst_n) begin
		inst_R_D <= 0;
		PCPlus4_D <= 0;
	end  else if (!EN1) begin
		inst_R_D <= inst_R_D;
		PCPlus4_D <= PCPlus4_D;
	end else if(CLR) begin
		inst_R_D <= 0;
		PCPlus4_D <= 0;
	end  
	else begin
		 inst_R_D <= inst_R_F;
		PCPlus4_D <= PCPlus4_F;
	end
end


endmodule 
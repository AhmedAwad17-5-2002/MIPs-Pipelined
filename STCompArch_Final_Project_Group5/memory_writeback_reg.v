module memory_writeback (
	input clk,    // Clock
	input rst_n,  // Asynchronous reset active low
	
	input MemToReg_M,RegWrite_M,
	input [31:0] ALUOut_M,C0_M,DATA_TO_WRITE_M,
	input [4:0] WriteReg_M,

	input LOAD_BYTE_M,
    input LOAD_HW_M,
    input LOAD_WORD_M,
    input LOAD_BYTE_UNSIGNED_M,
    input LOAD_HW_UNSIGNED_M,
    input OverFlow_M,mfc0_M, mul_DONE_M, mul_en_M,Jump_Link_M,jalr_rs_M,

    output reg OverFlow_W,
	output reg LOAD_BYTE_W,
    output reg LOAD_HW_W,
    output reg LOAD_WORD_W,
    output reg LOAD_BYTE_UNSIGNED_W,
    output reg LOAD_HW_UNSIGNED_W,

	output reg MemToReg_W,RegWrite_W, mfc0_W,
	output reg [31:0] ALUOut_W,C0_W,DATA_TO_WRITE_W,
	output reg [4:0] WriteReg_W,
	output reg mul_DONE_W, mul_en_W,Jump_Link_W,jalr_rs_W,
	input  wire [31:0] PCPlus4_M,
    output reg [31:0] PCPlus4_W  
);

always @(posedge clk or negedge rst_n) begin : proc_
	if(~rst_n) begin
		MemToReg_W <= 0;
		RegWrite_W <= 0;
		// ReadData_W <= 0;
		WriteReg_W <= 0;
		ALUOut_W <= 0;

		LOAD_BYTE_W <= 0;
        LOAD_HW_W <= 0;
        LOAD_WORD_W <= 0;
        LOAD_BYTE_UNSIGNED_W <= 0;
        LOAD_HW_UNSIGNED_W <= 0;
        OverFlow_W <= 0;
        mfc0_W<=0;
        C0_W<=0;
        mul_DONE_W<=0;
        mul_en_W <= 0;
        Jump_Link_W<=0;
        PCPlus4_W<=0;
        jalr_rs_W<=0;
        DATA_TO_WRITE_W<=0;
	end else begin
		MemToReg_W <= MemToReg_M;
		RegWrite_W <= RegWrite_M;
		// ReadData_W <= ReadData_M;
		WriteReg_W <= WriteReg_M;
		ALUOut_W <= ALUOut_M;

		LOAD_BYTE_W <= LOAD_BYTE_M;
        LOAD_HW_W <= LOAD_HW_M;
        LOAD_WORD_W <= LOAD_WORD_M;
        LOAD_BYTE_UNSIGNED_W <= LOAD_BYTE_UNSIGNED_M;
        LOAD_HW_UNSIGNED_W <= LOAD_HW_UNSIGNED_M;

         OverFlow_W <= OverFlow_M;
         mfc0_W<=mfc0_M;
         C0_W<=C0_M;
         mul_DONE_W <= mul_DONE_M;
         mul_en_W <= mul_en_M;
         Jump_Link_W<=Jump_Link_M;
         PCPlus4_W<=PCPlus4_M;
         jalr_rs_W<=jalr_rs_M;
         DATA_TO_WRITE_W<=DATA_TO_WRITE_M;

	end
end

endmodule
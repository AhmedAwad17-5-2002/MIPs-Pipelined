module ecxute_memory (
	input clk,    // Clock
	input rst_n,  // Asynchronous reset active low
	input MemToReg_E,MemWrite_E,RegWrite_E,
	input [31:0] ALUOut_pre_E,WriteData_E,C0_E,
	input [4:0] WriteReg_E,
    input i_start_E,
	input LOAD_BYTE_E,
    input LOAD_HW_E,
    input LOAD_WORD_E,
    input LOAD_BYTE_UNSIGNED_E,
    input LOAD_HW_UNSIGNED_E,
    input STORE_BYTE_E,
    input STORE_HW_E,
    input STORE_WORD_E,
    input [31:0] HI_LO_OUT_E,
    input mfhi_E ,
    input mflo_E,
    input OverFlow_E,
    input mfc0_E,
    input mul_DONE, mul_en_E,Jump_Link_E,jalr_rs_E,
    input [2:0] i_hsize_E,
    input [1:0] i_htrans_E,

	output reg LOAD_BYTE_M,
    output reg LOAD_HW_M,
    output reg LOAD_WORD_M,
    output reg LOAD_BYTE_UNSIGNED_M,
    output reg LOAD_HW_UNSIGNED_M,
    output reg STORE_BYTE_M,
    output reg STORE_HW_M,
    output reg STORE_WORD_M,
    output reg OverFlow_M,
	output reg MemToReg_M,MemWrite_M,RegWrite_M,
	output reg [31:0] ALUOut_pre_M,WriteData_M,C0_M,
	output reg [31:0] HI_LO_OUT_M,
	output reg [4:0] WriteReg_M,
	output reg mfhi_M ,
	output reg mflo_M, mfc0_M,Jump_Link_M,
    output reg mul_DONE_M, mul_en_M,jalr_rs_M,
    input  wire [31:0] PCPlus4_E,
    output reg [31:0] PCPlus4_M,
    output reg i_start_M,
    output reg [2:0] i_hsize_M,
    output reg [1:0] i_htrans_M
);


always @(posedge clk) begin : proc_fetch_Eecode
	if(~rst_n) begin
		MemToReg_M<=0;
		MemWrite_M<=0;
		// Branch_M<=0;
		RegWrite_M<=0;
		ALUOut_pre_M<=0;
		WriteData_M<=0;
		WriteReg_M<=0;

		LOAD_BYTE_M <= 0;
        LOAD_HW_M <= 0;
        LOAD_WORD_M <= 0;
        LOAD_BYTE_UNSIGNED_M <= 0;
        LOAD_HW_UNSIGNED_M <= 0;
        STORE_BYTE_M <= 0;
        STORE_HW_M <= 0;
        STORE_WORD_M <= 0;
        HI_LO_OUT_M<=0;

        mfhi_M <=0;
        mflo_M <=0;

        OverFlow_M<=0;

        mfc0_M <=0;
        C0_M<=0;
        mul_DONE_M <= 0;
        mul_en_M <= 0;
        Jump_Link_M<=0;
        PCPlus4_M<=0;
        jalr_rs_M<=0;

        i_hsize_M<=0;
        i_htrans_M<=0;
        i_start_M<=0;

	end else begin
		MemToReg_M<=MemToReg_E;
		MemWrite_M<=MemWrite_E;
		// Branch_M<=Branch_E;
		RegWrite_M<=RegWrite_E;
		ALUOut_pre_M<=ALUOut_pre_E;
		WriteData_M<=WriteData_E;
		WriteReg_M<=WriteReg_E;

		LOAD_BYTE_M <= LOAD_BYTE_E;
        LOAD_HW_M <= LOAD_HW_E;
        LOAD_WORD_M <= LOAD_WORD_E;
        LOAD_BYTE_UNSIGNED_M <= LOAD_BYTE_UNSIGNED_E;
        LOAD_HW_UNSIGNED_M <= LOAD_HW_UNSIGNED_E;
        STORE_BYTE_M <= STORE_BYTE_E;
        STORE_HW_M <= STORE_HW_E;
        STORE_WORD_M <= STORE_WORD_E;
        HI_LO_OUT_M<=HI_LO_OUT_E;

        mfhi_M <=mfhi_E;
        mflo_M <=mflo_E;

        OverFlow_M<=OverFlow_E;

        mfc0_M <= mfc0_E;
        C0_M<=C0_E;
        mul_DONE_M <= mul_DONE;
        mul_en_M <= mul_en_E;
        Jump_Link_M<=Jump_Link_E;
        PCPlus4_M<=PCPlus4_E;
        jalr_rs_M<=jalr_rs_E;

        i_hsize_M<=i_hsize_E;
        i_htrans_M<=i_htrans_E;
        i_start_M<=i_start_E;
	end
end
endmodule
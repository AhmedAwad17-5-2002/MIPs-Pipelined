module decode_excute(
	input clk,    // Clock
	input rst_n,  // Asynchronous reset active low
	input CLR,
    input i_start_D,
	input MemToReg_D,MemWrite_D,ALUSrc_D,RegDst_D,RegWrite_D,
	input [5:0] ALUControl_D,
	input [31:0] Signimm_D,RD1,RD2,C0_D,inst_R_D,
	input [4:0] RsD,RtD,RdD,
	input LOAD_BYTE_D,
    input LOAD_HW_D,
    input LOAD_WORD_D,
    input LOAD_BYTE_UNSIGNED_D,
    input LOAD_HW_UNSIGNED_D,
    input STORE_BYTE_D,
    input STORE_HW_D,
    input STORE_WORD_D,
    input hi_write_en_D, lo_write_en_D, mfhi_D, mthi_D, mflo_D, mtlo_D, jr_rs_D, jalr_rs_D, mul_en_D, div_en_D,
    input BREAK_D,Jump_Link_D,
    input PCSrcD,
    input mfc0_D, start_div_D,
    input  [2:0] i_hsize_D,
    input  [1:0] i_htrans_D,
    input take_shamt_D,
    

	output reg MemToReg_E,MemWrite_E,ALUSrc_E,RegDst_E,RegWrite_E,
	output reg [31:0] Signimm_E,RD1_E,RD2_E,C0_E,inst_R_E,
	output reg [4:0] RsE,RtE,RdE,
	output reg LOAD_BYTE_E,
    output reg LOAD_HW_E,
    output reg LOAD_WORD_E,
    output reg LOAD_BYTE_UNSIGNED_E,
    output reg LOAD_HW_UNSIGNED_E,
    output reg STORE_BYTE_E,
    output reg STORE_HW_E,
    output reg STORE_WORD_E,
    output reg [5:0] ALUControl_E,
    output reg BREAK_E,
    output reg PCSrcD_E,Jump_Link_E,
    output reg hi_write_en_E, lo_write_en_E, mfhi_E, mthi_E, mflo_E, mtlo_E, jr_rs_E, jalr_rs_E, mul_en_E,div_en_E, start_div_E, mfc0_E,
    input  wire [31:0] PCPlus4_D,
    output reg [31:0] PCPlus4_E,
    output reg [2:0] i_hsize_E,
    output reg [1:0] i_htrans_E,
    output reg take_shamt_E,
    output reg i_start_E
     
);


always @(posedge clk or negedge rst_n) begin : proc_fetch_decode
	if(~rst_n) begin
		MemToReg_E<=0;
		MemWrite_E<=0;
		// Branch_E<=0;
		ALUSrc_E<=0;
		RegDst_E<=0;
		RegWrite_E<=0;
		ALUControl_E<=0;
		RsE<=0;
		RtE<=0;
		RdE<=0;
		Signimm_E<=0;
		RD1_E<=0;
        RD2_E<=0;

        LOAD_BYTE_E<= 0;
        LOAD_HW_E <= 0;
        LOAD_WORD_E <= 0;
        LOAD_BYTE_UNSIGNED_E <= 0;
        LOAD_HW_UNSIGNED_E <= 0;
        STORE_BYTE_E <= 0;
        STORE_HW_E <= 0;
        STORE_WORD_E <= 0;

        hi_write_en_E<=0;
        lo_write_en_E<=0;
        mfhi_E<=0;
        mthi_E<=0;
        mflo_E<=0;
        mtlo_E<=0;
        mul_en_E<=0;
        BREAK_E<=0;
       // PCSrcD_E<=0;
        mfc0_E<=0;
        C0_E<=0;
        start_div_E <= 0;
        div_en_E <= 0 ; 
        Jump_Link_E<=0;
        PCPlus4_E<=0;
        jalr_rs_E<=0;

        i_hsize_E<=0;
        i_htrans_E<=0;
        take_shamt_E<=0;
        inst_R_E<=0;
        i_start_E<=0;

	end 

	else if(CLR) begin
		MemToReg_E<=0;
		MemWrite_E<=0;
		// Branch_E<=0;
		ALUSrc_E<=0;
		RegDst_E<=0;
		RegWrite_E<=0;
		ALUControl_E<=0;
		RsE<=0;
		RtE<=0;
		RdE<=0;
		Signimm_E<=0;
		RD1_E<=0;
        RD2_E<=0;

        LOAD_BYTE_E<= 0;
        LOAD_HW_E <= 0;
        LOAD_WORD_E <= 0;
        LOAD_BYTE_UNSIGNED_E <= 0;
        LOAD_HW_UNSIGNED_E <= 0;
        STORE_BYTE_E <= 0;
        STORE_HW_E <= 0;
        STORE_WORD_E <= 0;

        hi_write_en_E<=0;
        lo_write_en_E<=0;
        mfhi_E<=0;
        mthi_E<=0;
        mflo_E<=0;
        mtlo_E<=0;
        mul_en_E<=0;
        BREAK_E<=0;

        //PCSrcD_E<=0;
        mfc0_E<=0;
        C0_E<=0;
        start_div_E <= 0;
        div_en_E <= 0 ; 
        Jump_Link_E<=0;
        jalr_rs_E<=0;

        i_hsize_E<=0;
        i_htrans_E<=0;

        take_shamt_E<=0;
        inst_R_E<=0;
        i_start_E<=0;

	end

    else if(~CLR) begin
        MemToReg_E<=MemToReg_D;
        MemWrite_E<=MemWrite_D;
        // Branch_E<=Branch_D;
        ALUSrc_E<=ALUSrc_D;
        RegDst_E<=RegDst_D;
        RegWrite_E<=RegWrite_D;
        ALUControl_E<=ALUControl_D;
        RsE<=RsD;
        RtE<=RtD;
        RdE<=RdD;
        Signimm_E<=Signimm_D;
        RD1_E<=RD1;
        RD2_E<=RD2;

        LOAD_BYTE_E<= LOAD_BYTE_D;
        LOAD_HW_E <= LOAD_HW_D;
        LOAD_WORD_E <= LOAD_WORD_D;
        LOAD_BYTE_UNSIGNED_E <= LOAD_BYTE_UNSIGNED_D;
        LOAD_HW_UNSIGNED_E <= LOAD_HW_UNSIGNED_D;
        STORE_BYTE_E <= STORE_BYTE_D;
        STORE_HW_E <= STORE_HW_D;
        STORE_WORD_E <= STORE_WORD_D;


        hi_write_en_E<=hi_write_en_D;
        lo_write_en_E<=lo_write_en_D;
        mfhi_E<=mfhi_D;
        mthi_E<=mthi_D;
        mflo_E<=mflo_D;
        mtlo_E<=mtlo_D;
        mul_en_E<=mul_en_D;
        BREAK_E<=BREAK_D;
        //PCSrcD_E<=PCSrcD;
        mfc0_E<= mfc0_D;
        C0_E<=C0_D;
        start_div_E <= start_div_D;
        div_en_E <= div_en_D ;
        Jump_Link_E<=Jump_Link_D;
        PCPlus4_E<=PCPlus4_D;
        jalr_rs_E<=jalr_rs_D;
        i_hsize_E<=i_hsize_D;
        i_htrans_E<=i_htrans_D;

        take_shamt_E<=take_shamt_D;
        inst_R_E<=inst_R_D;
        i_start_E<=i_start_D;
    end
end

always @(negedge clk or negedge rst_n) begin 
    if(~rst_n) begin
        PCSrcD_E <= 0;
    end else if (~CLR) begin
        PCSrcD_E <= PCSrcD;
    end
       else if(CLR)
        PCSrcD_E<=0;
end

endmodule
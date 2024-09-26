module TOP(
	input CLK,
	input  rst_n,
	// input enable,
	input ForwardAD, ForwardBD,
    input [1:0] ForwardAE, ForwardBE,
    input [1:0] forwardEXC,
    input EN0, EN1,
    input FlushE,
    input Interrupt,
    


	output [31:0] out,

    output [4:0]  RsD_out_D,
    output [4:0]  RtD_out_D,
    output [4:0]  RsD_out_E,
    output [4:0]  RtD_out_E,
    output [4:0]  WriteReg_out_E,
    output [4:0]  WriteReg_out_M,
    output [4:0]  WriteReg_out_W,
    output [2:0] Branch_D_out,
    output RegWrite_E_out,
    output RegWrite_M_out,
    output RegWrite_W_out,
    output MemToReg_E_out,
    output MemToReg_M_out,
    output Jump_D_out,
    output Jump_Link_D_out,
    output jr_rs_D_out,
    output jalr_rs_D_out,
    output jalr_rs_E_out,
    output jalr_rs_M_out,
    output jalr_rs_W_out,

    output OverFlow_M_OUT,OverFlow_E_out,OverFlow_W_out,Undefined_Instruction_out,BREAK_D_out,BREAK_E_out, DivByZero_out,
    output [3:0] reg_out,
    output [3:0] RD_OUT,
    output exception,
    output MISSED_BUF,HIT_BUF,PCSrc_D_E_out,PCSrc_D_out,
    output state,offset, mfc0_D_out, mfc0_E_out, mfc0_M_out, mfc0_W_out, start_div_D, start_div_E, done_div_E, mul_DONE, mul_en_D_out,
    //output o_hresp, o_hresp_0, o_hresp_1,
    //output [31:0]  i_hrdata_1, i_hrdata_0,
    //output  o_hreadyout_1, o_hreadyout_0,
    input o_hready,
    input [31:0] ReadData_W,
    output [31:0] ALUOut_M,DATA_TO_WRITE,DATA_TO_WRITE_W,
    output MemWrite_M,i_start_M,
    output [2:0] i_hsize_M,
    output [1:0] i_htrans_M

);

reg  [31:0] PCF;
wire [31:0] PCPlus4_E,PCPlus4_M,PCPlus4_W;  
wire [31:0] PCBranch_D, PC_dash, PC_Pre_dash, PCJump,jal_pc;
wire [31:0] Signimm_D, Signimm_E, Signimm_D_shifted, Result_W_OR_ALUOut_M;
wire [4:0]  RsD, RtD, RdD, RsE, RtE, RdE;
wire [31:0] RD1, RD2, ALUOut_E, out_muxRD1, out_muxRD2;

wire MemToReg_E, MemWrite_E, RegWrite_E;
wire MemToReg_M, RegWrite_M;
wire MemToReg_W, RegWrite_W;
wire MemToReg_D, MemWrite_D, ALUSrc_D, RegDst_D, RegWrite_D;
wire [2:0]   Branch_D;

wire PCSrcD;
wire [5:0] ALUControl_D, ALUControl_E;
wire [31:0] inst_R_F ,PCPlus4_F, inst_R_D, inst_R_E, PCPlus4_D;
wire [31:0]  RD1_E, RD2_E;
wire RegDst_E, ALUSrc_E;
wire [4:0] WriteReg_E, WriteReg_M, WriteReg_W;
wire [31:0] SrcAE, SrcBE, WriteData_E, WriteData_M;

wire [31:0] Result_W;
wire [31:0] ReadData_M, ALUOut_W;
wire  CLR;
wire Jump_D, Jump_Link_D,Jump_Link_E,Jump_Link_M,Jump_Link_W;
wire OverFlow_M,OverFlow_W, OverFlow_E;
wire [27:0]lable_after_extend_by_two;
wire [31:0] Data_To_Write_In_RegFile;
wire [4:0] Address_To_Write_Data_In_RegFile;

wire IsBiggerThanZero, IsLessThanZero, IsZero, EQUAL, NotEQUAL;
wire zero;

wire [31:0] Signimm, unsignimm;
wire unsign_ex_en_D;

wire LOAD_BYTE_D,LOAD_BYTE_E,LOAD_BYTE_M,LOAD_BYTE_W;
wire LOAD_HW_D, LOAD_HW_E, LOAD_HW_M, LOAD_HW_W;
wire LOAD_WORD_D,LOAD_WORD_E,LOAD_WORD_M,LOAD_WORD_W;
wire LOAD_BYTE_UNSIGNED_D,LOAD_BYTE_UNSIGNED_E,LOAD_BYTE_UNSIGNED_M,LOAD_BYTE_UNSIGNED_W;
wire LOAD_HW_UNSIGNED_D, LOAD_HW_UNSIGNED_E, LOAD_HW_UNSIGNED_M, LOAD_HW_UNSIGNED_W;
// ire [31:0] data_load_in;
wire [31:0] data_load_out;
wire [31:0] load_OR_result;
wire load_en;

wire STORE_BYTE_D ,STORE_BYTE_E ,STORE_BYTE_M ;
wire STORE_HW_D ,STORE_HW_E, STORE_HW_M ;
wire STORE_WORD_D ,STORE_WORD_E ,STORE_WORD_M ;

wire [31:0] data_store_out;
wire store_en ;

wire [31:0] HI_in,LO_in,HI_out,LO_out, HI_LO_OUT_E, HI_LO_OUT_M;
wire hi_write_en_D, lo_write_en_D, mfhi_D, mthi_D, mflo_D, mtlo_D, jr_rs_D, jalr_rs_D,jalr_rs_E,jalr_rs_M,jalr_rs_W, mul_en_D; 
wire hi_write_en_E, lo_write_en_E, mfhi_E, mthi_E, mflo_E, mtlo_E, mul_en_E, div_en_D, div_en_E; 
wire [31:0] ALUOut_pre_M,ALUOut_pre_E;
// wire [31:0] TO_HI, TO_LO;
wire mfhi_M , mflo_M;
wire [31:0] PRE_JMP;

wire Undefined_Instruction;
wire [31:0] OUT_JUMP_MUX;
wire [31:0] Jump_or_load_OR_result;

wire EPCWrite;
wire [1:0] IntCause;
wire mfc0_D, mfc0_E, mfc0_M, mfc0_W;
wire mtc0;
wire CauseWrite;

wire [31:0] C0_D, C0_E, C0_M, C0_W, OP1_after_EX;

wire [4:0] address_req;
wire [31:0] PC_PASS;
wire [31:0] handler;
wire SYSCALL, BREAK_D,BREAK_E, DivByZero;
wire [63:0] MULTI_OUT;
wire [31:0] DIV_OUT_Q, DIV_OUT_R, MUL_MUX_OUT_HI, MUL_MUX_OUT_LO;

wire [31:0] OUT_PC,PC_GO;
wire HIT,hit_buf,miss_buf;

wire PCSrcD_E;

wire mul_DONE_M, mul_DONE_W, mul_en_M, mul_en_W,LUI_IM,ORI_IM;
wire [2:0] i_hsize_D, i_hsize_E;

wire [1:0] i_htrans_D,i_htrans_E;


wire take_shamt_D,take_shamt_E;

wire i_start_D,i_start_E;

sign_extend #(.SIGN(1)) sign_ex (.in(inst_R_D[15:0]), .LUI_IM(LUI_IM),.ORI_IM(ORI_IM), .out(Signimm));
sign_extend #(.SIGN(0)) unsign_ex (.in(inst_R_D[15:0]), .LUI_IM(LUI_IM),.ORI_IM(ORI_IM),.out(unsignimm));

shifter shft_signimm (.in(Signimm), .out(Signimm_D_shifted)); //temp
shifter #(.SIZE_IN(26), .SIZE_OUT(28)) shft_jump (.in(inst_R_D[25:0]), .out(lable_after_extend_by_two));

Comparator comp (.out_muxRD1(OP1_after_EX), .out_muxRD2(out_muxRD2),.IsBiggerThanZero(IsBiggerThanZero),
 .IsLessThanZero(IsLessThanZero), .IsZero(IsZero), .EQUAL(EQUAL), .NotEQUAL(NotEQUAL));

Branch_unit branch_UN (.PCSrcD(PCSrcD), .Branch_D(Branch_D), .EQUAL(EQUAL), .NotEQUAL(NotEQUAL),
 .IsZero(IsZero), .IsLessThanZero(IsLessThanZero), .IsBiggerThanZero(IsBiggerThanZero));

control_unit cotrol_UN (.Branch_D(Branch_D), .ALUSrc_D(ALUSrc_D), .MemWrite_D(MemWrite_D), .MemToReg_D(MemToReg_D),
 .ALUControl_D(ALUControl_D),.RegDst_D(RegDst_D), .RegWrite_D(RegWrite_D), .OPCODE(inst_R_D[31:26]), .funct(inst_R_D[5:0]),
  .Jump_D(Jump_D), .RtD(RtD), .RsD(RsD), .LOAD_WORD(LOAD_WORD_D), .STORE_BYTE(STORE_BYTE_D),.STORE_WORD(STORE_WORD_D),
   .LOAD_BYTE_UNSIGNED(LOAD_BYTE_UNSIGNED_D), .Jump_Link_D(Jump_Link_D),.LOAD_BYTE(LOAD_BYTE_D),
    .LOAD_HW_UNSIGNED(LOAD_HW_UNSIGNED_D), .LOAD_HW(LOAD_HW_D), .STORE_HW(STORE_HW_D),.unsign_ex_en_D(unsign_ex_en_D),
     .mfhi(mfhi_D), .mflo(mflo_D), .hi_write_en(hi_write_en_D), .lo_write_en(lo_write_en_D), .mthi(mthi_D), .mtlo(mtlo_D), .jr_rs(jr_rs_D),
      .mul_en(mul_en_D), .jalr_rs(jalr_rs_D), .Undefined_Instruction(Undefined_Instruction), .mfc0(mfc0_D), .mtc0(mtc0),
       .SYSCALL(SYSCALL), .DivByZero(DivByZero), .BREAK_D(BREAK_D), .RD2(RD2), .div_en(div_en_D), .start_div(start_div_D), 
        .LUI_IM(LUI_IM),.ORI_IM(ORI_IM), .i_hsize_D(i_hsize_D), .i_htrans_D(i_htrans_D), .take_shamt(take_shamt_D),.i_start_D(i_start_D)); //temp

instr_mem inst_memory (.clk(CLK), .PC(PC_GO), .instrucion(inst_R_F));
register_file reg_file (.CLK(CLK), .RD1(RD1), .RD2(RD2), .A1(inst_R_D[25:21]), .A2(inst_R_D[20:16]), .A3(Address_To_Write_Data_In_RegFile),
 .WD3(Data_To_Write_In_RegFile), .WE3(((RegWrite_W && ( !mul_en_W)) | (RegWrite_W && ( mul_DONE_W) ) | (Jump_Link_W ) | mfc0_W) & !OverFlow_W),.REG_LED(reg_out)) ;

ALU ALU_UNIT (.ALUControl(ALUControl_E), .srcA(SrcAE), .srcB(SrcBE), .ALU_RESULT(ALUOut_pre_E), .OverFlow(OverFlow_E),
 .zero(zero), .LO(MULTI_OUT[31:0]));

Store_Unit data_store_unit (.STORE_HW(STORE_HW_M), .store_en(store_en), .STORE_BYTE(STORE_BYTE_M), .STORE_WORD(STORE_WORD_M),
 .data_store_in(WriteData_M), .data_store_out(data_store_out));


fetch_Decode F_D (.inst_R_D(inst_R_D), .inst_R_F(inst_R_F), .CLR(CLR), .EN1(EN1), .PCPlus4_D(PCPlus4_D), .PCPlus4_F(PCPlus4_F), .clk(CLK), .rst_n(rst_n));

decode_excute D_E (.Signimm_D(Signimm_D), .clk(CLK), .RsD(RsD), .RtD(RtD), .RdD(RdD), .RD1(RD1), .RD2(RD2),
 .ALUSrc_D(ALUSrc_D),.RegDst_D(RegDst_D), .MemToReg_D(MemToReg_D), .MemToReg_E(MemToReg_E), .MemWrite_D(MemWrite_D),
  .MemWrite_E(MemWrite_E),.RegWrite_D(RegWrite_D),.RegWrite_E(RegWrite_E),.ALUControl_D(ALUControl_D),
   .ALUControl_E(ALUControl_E), .rst_n(rst_n), .ALUSrc_E(ALUSrc_E), .RegDst_E(RegDst_E),.RsE(RsE),.RtE(RtE), .RdE(RdE),
    .Signimm_E(Signimm_E), .RD1_E(RD1_E), .RD2_E(RD2_E), .LOAD_HW_D(LOAD_HW_D), .LOAD_HW_E(LOAD_HW_E),
     .STORE_HW_D(STORE_HW_D), .STORE_HW_E(STORE_HW_E), .LOAD_BYTE_D(LOAD_BYTE_D), .LOAD_BYTE_E(LOAD_BYTE_E),
      .LOAD_WORD_D(LOAD_WORD_D),.LOAD_WORD_E(LOAD_WORD_E), .STORE_BYTE_D(STORE_BYTE_D), .STORE_BYTE_E(STORE_BYTE_E),
       .STORE_WORD_D(STORE_WORD_D), .STORE_WORD_E(STORE_WORD_E),.LOAD_HW_UNSIGNED_D(LOAD_HW_UNSIGNED_D),
        .LOAD_HW_UNSIGNED_E(LOAD_HW_UNSIGNED_E), .LOAD_BYTE_UNSIGNED_D(LOAD_BYTE_UNSIGNED_D),
         .LOAD_BYTE_UNSIGNED_E(LOAD_BYTE_UNSIGNED_E), .mfhi_E(mfhi_E), .mflo_E(mflo_E), .mul_en_E(mul_en_E),
          .mfhi_D(mfhi_D), .mflo_D(mflo_D), .mthi_D(mthi_D), .mtlo_D(mtlo_D), .jr_rs_D(jr_rs_D), .mul_en_D(mul_en_D),
           .jalr_rs_D(jalr_rs_D), .hi_write_en_D(hi_write_en_D), .hi_write_en_E(hi_write_en_E),
            .lo_write_en_D(lo_write_en_D), .lo_write_en_E(lo_write_en_E), .mthi_E(mthi_E), .mtlo_E(mtlo_E),
             .jr_rs_E(jr_rs_E), .jalr_rs_E(jalr_rs_E), .CLR(FlushE), .BREAK_D(BREAK_D), .BREAK_E(BREAK_E), .PCSrcD(PCSrcD),
              .PCSrcD_E(PCSrcD_E), .mfc0_D(mfc0_D), .mfc0_E(mfc0_E), .C0_D(C0_D), .C0_E(C0_E), .start_div_D(start_div_D), 
               .start_div_E(start_div_E),.div_en_D(div_en_D),.div_en_E(div_en_E),.Jump_Link_E(Jump_Link_E),.Jump_Link_D(Jump_Link_D), 
                .PCPlus4_D(PCPlus4_D),.PCPlus4_E(PCPlus4_E), .i_htrans_D(i_htrans_D), .i_htrans_E(i_htrans_E), .i_hsize_D(i_hsize_D),
                 .i_hsize_E(i_hsize_E), .take_shamt_D(take_shamt_D), .take_shamt_E(take_shamt_E), .inst_R_D(inst_R_D), .inst_R_E(inst_R_E),.i_start_D(i_start_D),.i_start_E(i_start_E));

ecxute_memory E_M (.rst_n(rst_n), .clk(CLK), .MemToReg_E(MemToReg_E), .MemWrite_E(MemWrite_E),
    .RegWrite_E(RegWrite_E), .WriteData_E(WriteData_E), .WriteReg_E(WriteReg_E), 
     .MemToReg_M(MemToReg_M), .MemWrite_M(MemWrite_M), .RegWrite_M(RegWrite_M), 
      .WriteData_M(WriteData_M), .WriteReg_M(WriteReg_M), .LOAD_HW_E(LOAD_HW_E), .LOAD_BYTE_E(LOAD_BYTE_E),
       .STORE_BYTE_E(STORE_BYTE_E), .STORE_WORD_E(STORE_WORD_E), .STORE_HW_E(STORE_HW_E),
        .LOAD_HW_UNSIGNED_E(LOAD_HW_UNSIGNED_E), .LOAD_WORD_E(LOAD_WORD_E), .LOAD_BYTE_UNSIGNED_E(LOAD_BYTE_UNSIGNED_E),
         .LOAD_HW_M(LOAD_HW_M), .STORE_HW_M(STORE_HW_M), .LOAD_BYTE_M(LOAD_BYTE_M), .LOAD_WORD_M(LOAD_WORD_M),
          .STORE_BYTE_M(STORE_BYTE_M),.STORE_WORD_M(STORE_WORD_M), .LOAD_HW_UNSIGNED_M(LOAD_HW_UNSIGNED_M),
           .LOAD_BYTE_UNSIGNED_M(LOAD_BYTE_UNSIGNED_M), .mfhi_E(mfhi_E), .mfhi_M(mfhi_M), .ALUOut_pre_E(ALUOut_pre_E),
            .ALUOut_pre_M(ALUOut_pre_M), .HI_LO_OUT_E(HI_LO_OUT_E), .HI_LO_OUT_M(HI_LO_OUT_M), .mflo_M(mflo_M),
             .mflo_E(mflo_E), .OverFlow_E(OverFlow_E), .OverFlow_M(OverFlow_M), .mfc0_E(mfc0_E), .mfc0_M(mfc0_M), 
              .C0_E(C0_E), .C0_M(C0_M), .mul_DONE_M(mul_DONE_M), .mul_DONE(mul_DONE), .mul_en_E(mul_en_E), .mul_en_M(mul_en_M),
              .Jump_Link_E(Jump_Link_E),.Jump_Link_M(Jump_Link_M),.PCPlus4_E(PCPlus4_E),.PCPlus4_M(PCPlus4_M), .jalr_rs_E(jalr_rs_E),
               .jalr_rs_M(jalr_rs_M), .i_hsize_E(i_hsize_E), .i_hsize_M(i_hsize_M), .i_htrans_E(i_htrans_E), .i_htrans_M(i_htrans_M),.i_start_E(i_start_E),.i_start_M(i_start_M));

memory_writeback M_W (.rst_n(rst_n), .clk(CLK), .ALUOut_M(ALUOut_M), .RegWrite_M(RegWrite_M), .WriteReg_M(WriteReg_M),
 .MemToReg_M(MemToReg_M), .MemToReg_W(MemToReg_W), .RegWrite_W(RegWrite_W), 
  .ALUOut_W(ALUOut_W), .WriteReg_W(WriteReg_W), .LOAD_BYTE_M(LOAD_BYTE_M), .LOAD_WORD_M(LOAD_WORD_M),
   .LOAD_BYTE_UNSIGNED_M(LOAD_BYTE_UNSIGNED_M), .LOAD_HW_UNSIGNED_M(LOAD_HW_UNSIGNED_M), .LOAD_HW_M(LOAD_HW_M),
    .LOAD_HW_W(LOAD_HW_W), .LOAD_BYTE_W(LOAD_BYTE_W), .LOAD_WORD_W(LOAD_WORD_W), .LOAD_HW_UNSIGNED_W(LOAD_HW_UNSIGNED_W),
     .LOAD_BYTE_UNSIGNED_W(LOAD_BYTE_UNSIGNED_W),.OverFlow_M(OverFlow_M), .OverFlow_W(OverFlow_W), .mfc0_M(mfc0_M), 
      .mfc0_W(mfc0_W), .C0_M(C0_M), .C0_W(C0_W), .mul_DONE_M(mul_DONE_M), .mul_DONE_W(mul_DONE_W), .mul_en_M(mul_en_M), .mul_en_W(mul_en_W),
      .Jump_Link_M(Jump_Link_M),.Jump_Link_W(Jump_Link_W),.PCPlus4_M(PCPlus4_M),.PCPlus4_W(PCPlus4_W),.jalr_rs_M(jalr_rs_M),.jalr_rs_W(jalr_rs_W),.DATA_TO_WRITE_M(DATA_TO_WRITE),
      .DATA_TO_WRITE_W(DATA_TO_WRITE_W));

Load_Unit data_load_unit (.LOAD_HW(LOAD_HW_W), .LOAD_BYTE(LOAD_BYTE_W), .LOAD_WORD(LOAD_WORD_W), .data_load_in(ReadData_W),
 .LOAD_HW_UNSIGNED(LOAD_HW_UNSIGNED_W), .LOAD_BYTE_UNSIGNED(LOAD_BYTE_UNSIGNED_W), .data_load_out(data_load_out), .load_en(load_en));




Mux_4X1 mux41_1 (.in0(RD1_E), .in1(Result_W), .in2(ALUOut_M), .out(Result_W_OR_ALUOut_M), .sel(ForwardAE));
Mux_4X1 mux41_2 (.in0(RD2_E), .in1(Result_W), .in2(ALUOut_M), .out(WriteData_E), .sel(ForwardBE));
MUX RD1_MUX (.in0(RD1), .in1(ALUOut_M), .out(out_muxRD1), .sel(ForwardAD));
MUX RD2_MUX (.in0(RD2), .in1(ALUOut_M), .out(out_muxRD2), .sel(ForwardBD));
Mux_4X1 EXC (.in0(out_muxRD1), .in1(C0_M), .in2(C0_E), .out(OP1_after_EX), .sel(forwardEXC));
MUX #(.SIZE(5)) m1 (.in0(RtE), .in1(RdE), .sel(RegDst_E), .out(WriteReg_E));
MUX m2 (.in0(WriteData_E), .in1(Signimm_E), .sel(ALUSrc_E), .out(SrcBE));
MUX x3 (.in0(Result_W_OR_ALUOut_M), .in1({27'b0,{inst_R_E[10:6]}}), .sel(take_shamt_E), .out(SrcAE));
MUX m3 (.in0(ALUOut_W), .in1(ReadData_W), .out(Result_W), .sel(MemToReg_W));

MUX m4 (.in0(PCPlus4_F), .in1(PCBranch_D), .out(PC_Pre_dash), .sel(PCSrcD)); 
MUX m5 (.in0(PC_Pre_dash), .in1(PRE_JMP), .out(OUT_JUMP_MUX), .sel(Jump_D | Jump_Link_D | jr_rs_D | jalr_rs_D)); ///////
MUX m6 (.in0(OUT_JUMP_MUX), .in1(handler), .sel(OverFlow_E | (Undefined_Instruction & OverFlow_M) | BREAK_D), .out(PC_dash)); //////////

MUX storing (.in0(WriteData_M), .in1(data_store_out), .out(DATA_TO_WRITE), .sel(store_en));
MUX loading (.in0(Result_W), .in1(data_load_out), .out(load_OR_result), .sel(load_en));
MUX data_in (.in0(load_OR_result), .in1(PCPlus4_W), .sel((Jump_Link_W | jalr_rs_W)), .out(Jump_or_load_OR_result));
MUX EXCEPTIONS_MUX (.in0(Jump_or_load_OR_result), .in1(C0_W), .out(Data_To_Write_In_RegFile), .sel(mfc0_W));/////////////////////////////////////////////

MUX #(.SIZE(5)) address_in (.in0(WriteReg_W), .in1(5'd31), .out(Address_To_Write_Data_In_RegFile), .sel((Jump_Link_W | jalr_rs_W)));

MUX sign_mux (.in0(Signimm), .in1(unsignimm), .sel(unsign_ex_en_D), .out(Signimm_D));


Mux_4X1 HI_LO (.in0(32'd0), .in1(LO_out), .in2(HI_out), .sel({mfhi_E, mflo_E}), .out(HI_LO_OUT_E));
MUX ALU_HI_LO (.in0(ALUOut_pre_M), .in1(HI_LO_OUT_M), .sel((mfhi_M | mflo_M)), .out(ALUOut_M));

MUX ALU_HI (.in0(SrcAE), .in1(MULTI_OUT[63:32]), .sel(mul_en_E), .out(MUL_MUX_OUT_HI));
MUX ALU_LO (.in0(SrcAE), .in1(MULTI_OUT[31:0]), .sel(mul_en_E), .out(MUL_MUX_OUT_LO));

MUX DIV_HI (.in0(MUL_MUX_OUT_HI), .in1(DIV_OUT_Q), .sel(div_en_E), .out(HI_in));
MUX DIV_LO (.in0(MUL_MUX_OUT_LO), .in1(DIV_OUT_R), .sel(div_en_E), .out(LO_in));

Regs HI_REG (.rst_n(rst_n), .clk(CLK), .enable(hi_write_en_E), .data_in(HI_in), .data_out(HI_out));
Regs LO_REG (.rst_n(rst_n), .clk(CLK), .enable(lo_write_en_E), .data_in(LO_in), .data_out(LO_out));

MUX ALL_JMP (.in0(PCJump), .in1(out_muxRD1), .out(PRE_JMP), .sel(jr_rs_D | jalr_rs_D));

CO_PROC_0 COPro_0 (.rst_n(rst_n), .CLK(CLK), .PC(PC_PASS), .C0(C0_D), .EPCWrite(EPCWrite), .IntCause(IntCause),
 .CauseWrite(CauseWrite), .mtc0(mtc0), .w_Addr(RdD), .d_in(RD2));

assign PC_PASS = (OverFlow_E)? (PCF-32'h4) : PCF;

multiplier MULTIPLIER (.clk(CLK), .start(mul_en_E), .Z(MULTI_OUT), .X(SrcAE), .Y(SrcBE), .DONE(mul_DONE), .rst_n(rst_n));

Div Dividor (.clk(CLK),.reset(rst_n),.start(start_div_E),.dividend(SrcAE),.divisor(SrcBE),.quotient(DIV_OUT_Q),.remainder(DIV_OUT_R),.done(done_div_E));

predictor BTB (.rst_n(rst_n), .clk(CLK), .PC_in(PCF), .Branch_Type(Branch_D), .taken_flag(PCSrcD), .HIT(HIT), .MISSED(MISSED), .OUT_PC(OUT_PC),
 .PC_BRANCH_DECODED(PCBranch_D), .hit_flag(hit_buf), .miss_flag(miss_buf), .offset(inst_R_D[15:0]), .state(state), .stallF(EN0), .instr_F(inst_R_F));

assign PC_GO=((hit_buf && !miss_buf) & (state & hit_buf))? OUT_PC : PCF;

assign PCPlus4_F = PCF+4;

assign PCJump = {PCF[31:28],(lable_after_extend_by_two)} ;

always@(posedge CLK) 
    if(~rst_n) 
    	PCF<=0;
    else if(EN0 & !Interrupt && o_hready)
        PCF <= PC_dash;

assign out= ReadData_W;

assign PCBranch_D = Signimm_D_shifted+PCPlus4_D;
wire mfc0;
assign CLR = Jump_Link_D | jr_rs_D | jalr_rs_D | (PCSrcD & !hit_buf) | Jump_D | BREAK_D | (PCSrcD & hit_buf & !state) | (!PCSrcD & hit_buf & offset);
assign RsD = inst_R_D [25:21];
assign RtD = inst_R_D [20:16];
assign RdD = inst_R_D [15:11];

assign RsD_out_D = RsD;
assign RtD_out_D = RtD;

assign RsD_out_E = RsE;
assign RtD_out_E = RtE;

assign WriteReg_out_E=WriteReg_E;
assign WriteReg_out_M=WriteReg_M;
assign WriteReg_out_W=WriteReg_W;

assign Branch_D_out = Branch_D;
assign RegWrite_E_out = RegWrite_E;
assign RegWrite_M_out = RegWrite_M;
assign RegWrite_W_out = RegWrite_W;
assign MemToReg_E_out = MemToReg_E;
assign MemToReg_M_out = MemToReg_M;

assign Jump_D_out= Jump_D;
assign Jump_Link_D_out= Jump_Link_D;
assign jr_rs_D_out= jr_rs_D;
assign jalr_rs_D_out=jalr_rs_D;
assign jalr_rs_E_out=jalr_rs_E;
assign jalr_rs_M_out=jalr_rs_M;
assign jalr_rs_W_out=jalr_rs_W;

assign IntCause = (Interrupt)? 0 :(BREAK_D | DivByZero)? 1 :(Undefined_Instruction)? 2 : 3 ;
assign EPCWrite = (Undefined_Instruction | OverFlow_E | BREAK_D | DivByZero | Interrupt)? 1 : 0;
assign CauseWrite = (Undefined_Instruction | OverFlow_E | BREAK_D | DivByZero | Interrupt)? 1 : 0;

assign exception = Undefined_Instruction | OverFlow_E | BREAK_D | DivByZero;
assign OverFlow_M_OUT = OverFlow_M;
assign OverFlow_E_out = OverFlow_E;
assign OverFlow_W_out = OverFlow_W;

assign Undefined_Instruction_out = Undefined_Instruction;
assign BREAK_D_out=BREAK_D;
assign BREAK_E_out=BREAK_E;
assign DivByZero_out = DivByZero;

assign PCSrc_D_E_out=PCSrcD_E;
assign PCSrc_D_out=PCSrcD;
assign handler = (((Undefined_Instruction | BREAK_D | DivByZero) & (OverFlow_M | OverFlow_E)))? 32'd36864 : 32'h8180;
//assign handler = 32'd2024;

assign MISSED_BUF=miss_buf;
assign HIT_BUF=hit_buf;
//assign jal_pc=Jump_Link_D?PCPlus4_D:0;
assign offset = (inst_R_D[15] && (Branch_D!=3'd7 && Branch_D!=3'd0))? 1 : 0 ;

assign mfc0_D_out=mfc0_D;
assign mfc0_E_out=mfc0_E;
assign mfc0_M_out=mfc0_M;
assign mfc0_W_out=mfc0_W;
assign mul_en_D_out= mul_en_D;
assign RD_OUT = ReadData_W [3:0];
endmodule
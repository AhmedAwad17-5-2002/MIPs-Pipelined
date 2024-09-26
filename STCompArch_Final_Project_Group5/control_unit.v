module control_unit (
    input [5:0] OPCODE,
    input [5:0] funct,
    input [4:0] RtD,
    input [4:0] RsD,
    input [31:0] RD2,
    output  MemToReg_D,MemWrite_D,ALUSrc_D,RegDst_D,RegWrite_D,Jump_D,Jump_Link_D, unsign_ex_en_D,
    output  LOAD_BYTE, LOAD_HW, LOAD_WORD, LOAD_BYTE_UNSIGNED, LOAD_HW_UNSIGNED,
    output  STORE_BYTE, STORE_HW, STORE_WORD,
    output  hi_write_en, lo_write_en, mfhi, mthi, mflo, mtlo, jr_rs, jalr_rs,mul_en,
    output  [2:0] Branch_D,
    output  [5:0] ALUControl_D,
    output  mfc0, mtc0,
    output  Undefined_Instruction,LUI_IM,ORI_IM,
    output  SYSCALL,BREAK_D,DivByZero, start_div, div_en,
    output  [2:0] i_hsize_D,
    output  [1:0] i_htrans_D,
    output take_shamt,i_start_D
);

wire [3:0] ALU_OP;


ALU_Decoder M1 (.ALUControl(ALUControl_D), .funct(funct), .ALU_OP(ALU_OP), .mfhi(mfhi), .mflo(mflo), .mthi(mthi), .mtlo(mtlo),
 .jr_rs(jr_rs), .mul_en(mul_en), .jalr_rs(jalr_rs), .hi_write_en(hi_write_en), .lo_write_en(lo_write_en), .SYSCALL(SYSCALL),
  .BREAK(BREAK_D), .DivByZero(DivByZero), .RD2(RD2), .div_en(div_en), .start_div(start_div), .take_shamt(take_shamt));

main_decoder M0 (.ALU_OP(ALU_OP), .OPCODE(OPCODE), .RtD(RtD), .RsD(RsD), .MemToReg_D(MemToReg_D), .MemWrite_D(MemWrite_D),
 .ALUSrc_D(ALUSrc_D), .RegDst_D(RegDst_D), .RegWrite_D(RegWrite_D), .Jump_D(Jump_D), .Jump_Link_D(Jump_Link_D), 
 .unsign_ex_en_D(unsign_ex_en_D), .LOAD_BYTE(LOAD_BYTE), .LOAD_HW(LOAD_HW), .LOAD_WORD(LOAD_WORD), .LOAD_BYTE_UNSIGNED(LOAD_BYTE_UNSIGNED),
  .LOAD_HW_UNSIGNED(LOAD_HW_UNSIGNED), .STORE_BYTE(STORE_BYTE), .STORE_HW(STORE_HW), .Branch_D(Branch_D), .STORE_WORD(STORE_WORD), .Undefined_Instruction(Undefined_Instruction),
   .mfc0(mfc0), .mtc0(mtc0),.LUI_IM(LUI_IM),.ORI_IM(ORI_IM), .i_hsize_D(i_hsize_D), .i_htrans_D(i_htrans_D),.i_start_D(i_start_D));

endmodule
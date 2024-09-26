module main_decoder (
    input [5:0] OPCODE,
    input [4:0] RtD,
    input [4:0] RsD,
    output reg MemToReg_D,MemWrite_D,ALUSrc_D,RegDst_D,RegWrite_D,Jump_D,Jump_Link_D, unsign_ex_en_D,
    output reg LOAD_BYTE, LOAD_HW, LOAD_WORD, LOAD_BYTE_UNSIGNED, LOAD_HW_UNSIGNED,
    output reg STORE_BYTE, STORE_HW, STORE_WORD,
    output reg [2:0] Branch_D,
    output reg Undefined_Instruction,
    output reg mfc0,LUI_IM,ORI_IM,
    output reg mtc0,i_start_D,
    output reg [2:0] i_hsize_D,
    output reg [1:0] i_htrans_D,


    output reg [3:0] ALU_OP
);
localparam Add=3'b000,
           Sub=3'b001,
           LookAtFunct=3'b010,
           NOP=3'b011;

localparam R_TYPE=6'b000000,
           BGEZ_BLTZ = 6'b000001,
           BLEZ = 6'b000110, 
           BGTZ = 6'b000111,
           J    = 6'b000010,
           JAL  = 6'b000011,
           BEQ  = 6'b000100,
           BNE  = 6'b000101,
           ADDI = 6'b001000,
           ADDIU= 6'b001001,
           SLTI = 6'b001010,
           SLTIU= 6'b001011,
           ANDI = 6'b001100,
           ORI  = 6'b001101,
           XORI = 6'b001110,
           LUI  = 6'b001111,
           MUL  = 6'b011100,  // With funct == 2 --> Rd=RsxRt
           LB   = 6'b100000,
           LH   = 6'b100001,
           LW   = 6'b100011,
           LBU  = 6'b100100,
           LHU  = 6'b100101,
           SB   = 6'b101000,
           SH   = 6'b101001,
           SW   = 6'b101011,
           MFC0_MTC0 = 6'b010000,//Rs=0 _ 4
           NO_operation=6'b111111; 



always @(*) begin : proc_R_Type
 MemToReg_D = 0;
 MemWrite_D = 0;
 LUI_IM=1'b0;
 Branch_D = 3'b000;
 ALUSrc_D = 0;
 RegDst_D = 0;
 RegWrite_D = 0;
 Jump_D = 0;
 Jump_Link_D=0;
 ORI_IM=0;
 unsign_ex_en_D=0;
 LOAD_BYTE=0;
 LOAD_HW=0;
 LOAD_WORD=0;
 STORE_BYTE=0;
 STORE_HW=0;
 STORE_WORD=0;
 LOAD_BYTE_UNSIGNED=0;
 LOAD_HW_UNSIGNED=0;
 ALU_OP = NOP;
 // IntCause=0;
 // EPCWrite=0;
 // CauseWrite=0;

 Undefined_Instruction = 0;
 mfc0=0;
 mtc0=0;

 i_hsize_D=3'b010;
 i_htrans_D=2'b00;
 i_start_D=0;


 case(OPCODE)
  NO_operation : ALU_OP=NOP;

  R_TYPE : begin
	RegDst_D = 1;
	RegWrite_D = 1;
	ALU_OP = LookAtFunct;
  end
 
  BGEZ_BLTZ : begin
	if(RtD==0)
	    Branch_D =3'b010 ;
	else if (RtD==1)
		Branch_D=3'b001;
	else 
		Branch_D=3'b000;
  end

  BEQ : Branch_D = 3'b011;

  BNE : Branch_D = 3'b100;

  BLEZ : Branch_D = 3'b101;

  BGTZ : Branch_D = 3'b110;
 
  J : Jump_D = 1;

  JAL : Jump_Link_D=1;


  ADDI : begin
  	ALUSrc_D=1;
  	RegWrite_D=1;
    ALU_OP=4'b0000;
  end


  ADDIU : begin
  	//unsign_ex_en_D=1;
  	ALUSrc_D=1;
  	RegWrite_D=1;
    ALU_OP=4'b0000;
  end

  SLTI : begin
  	ALU_OP=4'b0100;
  	ALUSrc_D=1;
  	RegWrite_D=1;
  end

  SLTIU : begin
  	unsign_ex_en_D=1;
  	ALUSrc_D=1;
  	RegWrite_D=1;
  	ALU_OP=4'b0100;
  end

  ANDI : begin 
  	ALU_OP=4'b0101;
  	ALUSrc_D=1;
  	RegWrite_D=1;
  end

  ORI : begin 
  	ALU_OP=4'b0110;
    ORI_IM=1;
  	ALUSrc_D=1;
  	RegWrite_D=1;
  end 

  XORI : begin 
  	ALU_OP=4'b0111;
  	ALUSrc_D=1;
  	RegWrite_D=1;
  end

  LUI : begin
  	ALU_OP=4'b0000;
    LUI_IM=1'b1;
  	//MemToReg_D=1;
    ALUSrc_D=1;
  	RegWrite_D=1;

  end

  MUL : begin
  	ALU_OP=4'b1000;
  	RegDst_D=1;
  	RegWrite_D=1;
  end

  LB : begin
  	ALU_OP=4'b0000;
  	ALUSrc_D=1;
  	MemToReg_D=1;
  	LOAD_BYTE=1;
  	RegWrite_D=1;
     i_hsize_D=3'b010;
     i_htrans_D=2'b10;
  end

  LH : begin
  	ALU_OP=4'b0000;
  	ALUSrc_D=1;
  	MemToReg_D=1;
  	LOAD_HW=1;
  	RegWrite_D=1;
    i_hsize_D=3'b010;
     i_htrans_D=2'b10;
  end

  LW : begin
  	ALU_OP=4'b0000;
  	ALUSrc_D=1;
  	MemToReg_D=1;
  	LOAD_WORD=1;
  	RegWrite_D=1;
    i_hsize_D=3'b010;
     i_htrans_D=2'b10;
  end

  LBU : begin
  	ALU_OP=4'b0000;
  	ALUSrc_D=1;
  	MemToReg_D=1;
  	LOAD_BYTE_UNSIGNED=1;
  	RegWrite_D=1;
    i_hsize_D=3'b010;
     i_htrans_D=2'b10;
  end

  LHU : begin
  	ALU_OP=4'b0000;
  	ALUSrc_D=1;
  	MemToReg_D=1;
  	LOAD_HW_UNSIGNED=1;
  	RegWrite_D=1;
    i_hsize_D=3'b010;
     i_htrans_D=2'b10;
  end


  SB : begin
  	STORE_BYTE=1;
  	ALU_OP=4'b000;
  	ALUSrc_D=1;
  	MemWrite_D=1;
  	MemToReg_D=1;
    i_hsize_D=3'b010;
     i_htrans_D=2'b10;
  end

  SH : begin
  	STORE_HW=1;
  	ALU_OP=4'b000;
  	ALUSrc_D=1;
  	MemWrite_D=1;
  	MemToReg_D=1;
    i_hsize_D=3'b010;
     i_htrans_D=2'b10;
  end

  SW : begin
  	STORE_WORD=1;
  	ALU_OP=4'b000;
  	ALUSrc_D=1;
  	MemWrite_D=1;
  	MemToReg_D=1;
    i_hsize_D=3'b010;
     i_htrans_D=2'b10;
  end
  MFC0_MTC0 : begin
    if (RsD==0)begin
      mfc0=1;
    end //MFC0
    if (RsD==4)begin
      mtc0=1;   
    end //MFC0
  end
  default :begin
               Undefined_Instruction = 1; 
           end
 endcase // OPCODE
end





endmodule
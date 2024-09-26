module ALU_Decoder (
	input [5:0] funct,
	input [3:0] ALU_OP,
	input [31:0] RD2,
	output reg [5:0] ALUControl,
	output reg  hi_write_en, lo_write_en, mfhi, mthi, mflo, mtlo, jr_rs, jalr_rs,mul_en,SYSCALL,BREAK,DivByZero,start_div, div_en,
	output reg take_shamt
);

always @(*) begin : proc_Decoder
    hi_write_en=0;
    lo_write_en=0;
    mfhi=0;
    mflo=0;
    mthi=0;
    mtlo=0;
    jr_rs=0;
    jalr_rs=0;
    mul_en=0;
    ALUControl=0;
    SYSCALL=0;
    BREAK=0;
    DivByZero=0;
    start_div = 0;
    div_en = 0 ;
    take_shamt=0;

	if(ALU_OP==4'b0000)
		ALUControl=6'b000010;
	else if(ALU_OP==4'b0001)
		ALUControl=6'b000110;

	else if(ALU_OP==4'b0010)begin
		if(funct==6'b100000)
			ALUControl=6'b000010;

		else if(funct==6'b100010)
			ALUControl=6'b000110;

		else if(funct==6'b100100)
			ALUControl=6'b000000;

		else if(funct==6'b100101)
			ALUControl=6'b000001;

		else if(funct==6'b101010)
			ALUControl=6'b000111;

		else if(funct==6'b000000) begin
		    ALUControl=6'b001001;
		    take_shamt=1;
		end

		else if(funct==6'b000010) begin
			ALUControl=6'b001010;
			take_shamt=1;
		end

		else if(funct==6'b000011) begin
			ALUControl=6'b001011;
			take_shamt=1;
		end

		else if(funct==6'b000100)
			ALUControl=6'b001101;

		else if(funct==6'b000110)
			ALUControl=6'd12;

		else if(funct==6'b000111)
			ALUControl=6'd14;

		else if(funct==6'b100001)
			ALUControl=6'd15;

		else if(funct==6'b100011)
			ALUControl=6'd16;

		else if(funct==6'b100111)
			ALUControl=6'd17;

		else if(funct==6'b101011)
			ALUControl=6'd18;

		else if(funct==6'b011000) begin  //mul
			hi_write_en=1'b1;
            	lo_write_en=1'b1;
           	mul_en=1;
		end
		else if(funct==6'b011001) begin
			hi_write_en=1'b1;
      		lo_write_en=1'b1;
         		mul_en=1;
		end
		else if(funct==6'b011010) begin //div
		   if(RD2!=0) begin
			start_div = 1;
			hi_write_en=1'b1;
      		lo_write_en=1'b1;
      		div_en=1;
           end
           else
           	DivByZero=1;
		end
		else if(funct==6'b011011) begin  //div
		   if(RD2!=0) begin
			start_div = 1;
			hi_write_en=1'b1;
      		lo_write_en=1'b1;
      		div_en=1;
           end
           else
           	DivByZero=1;
		end
		else if(funct==6'b010000) //mfhi
			mfhi = 1'b1;
		else if(funct==6'b010001)begin //mtho
			mthi = 1'b1;
		    hi_write_en=1;
		end	
		else if(funct==6'b010010) //mflo
			mflo = 1'b1;
		else if(funct==6'b010011) begin  //mtlo
			mtlo = 1'b1;
		    lo_write_en=1;
		end
		else if(funct==6'b001000)
			jr_rs = 1'b1;

		else if(funct==6'b001001)
			jalr_rs = 1'b1;

		else if (funct==6'b001100)
			SYSCALL=1;
		else if (funct==6'b001101)
			BREAK=1;
		else if(funct==6'b100110)
			ALUControl=6'b001000;
		

		else
			ALUControl=6'b000000;
	end

	else if(ALU_OP==4'b0100)   //SLTI
		ALUControl=6'b000111;

	else if(ALU_OP==4'b0101) // ANDI
		ALUControl=6'b000000;


	else if(ALU_OP==4'b0110) // ORI
		ALUControl=6'b000001;

	else if(ALU_OP==4'b0111) // XORI
		ALUControl=6'b001000;

	else if (ALU_OP==4'b1000)begin
		if (funct==6'd2) begin
			ALUControl=6'd23;
		     mul_en=1;
		end 
		else 
			ALUControl=6'd0;
	end

	else
	   ALUControl=6'b000000;
end

endmodule
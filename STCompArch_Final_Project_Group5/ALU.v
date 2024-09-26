module ALU (
	input signed [31:0] srcA ,
	input signed [31:0] srcB ,
	input [5:0] ALUControl,

	input  [31:0] LO,
	output reg signed [31:0] ALU_RESULT,
	output OverFlow,
	output zero
);
reg OverFlow_pos, OverFlow_neg, Carry;

always @(*) begin : proc_OverFlow
	OverFlow_neg=0;
	OverFlow_pos=0;

	if(srcA[31]==0 && srcB[31]==0 && OverFlow==1 && ALUControl==2)
		OverFlow_pos=1;

    else if (srcA[31]==0 && srcB[31]==1 && ALUControl==6 && OverFlow==1)
    	OverFlow_pos=1;

    else if (srcA[31]==1 && srcB[31]==0 && ALUControl==6 && OverFlow==1)
    	OverFlow_neg=1;

    else if (srcA[31]==1 && srcB[31]==1 && OverFlow==1 && ALUControl==2)
    	OverFlow_neg=1;
end

always @(*) begin
	Carry=0;
	case(ALUControl)
		0 : ALU_RESULT = srcA&srcB;
		1 : ALU_RESULT = srcA|srcB;
		2 : {Carry,ALU_RESULT} = srcA+srcB;
		6 : {Carry,ALU_RESULT} = srcA-srcB;
		7 : if(srcA<srcB) 
		       ALU_RESULT=32'd1;
		    else
		       ALU_RESULT=32'd0; 
		9 : ALU_RESULT = srcB << srcA;
		10: ALU_RESULT = srcB >> srcA;
		11: ALU_RESULT = srcB >>> srcA;
		12: ALU_RESULT = srcB >> srcA[4:0];
		13: ALU_RESULT = srcB << srcA[4:0];
		14: ALU_RESULT = srcB >>> srcA[4:0];
		15: {Carry,ALU_RESULT} = $unsigned(srcA) + $unsigned(srcB); //unsigned
		16: {Carry,ALU_RESULT} = $unsigned(srcA) - $unsigned(srcB); //unsigned
		17: ALU_RESULT = ~(srcA | srcB);
		18:  if($unsigned(srcA)< $unsigned(srcB)) 
		       ALU_RESULT=32'd1;
		    else
		       ALU_RESULT=32'd0;       //unsigned
		8 : ALU_RESULT = srcA^srcB;
		23 : ALU_RESULT = LO;
		default : ALU_RESULT = srcA+srcB;
	endcase
end
assign OverFlow = (ALUControl==2 || ALUControl==6)? Carry ^ ALU_RESULT[31] : 0;
assign zero=(~ALU_RESULT && !OverFlow)? 1 : 0;
endmodule 
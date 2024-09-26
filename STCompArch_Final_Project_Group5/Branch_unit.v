module Branch_unit (
    input EQUAL, IsBiggerThanZero, IsLessThanZero, IsZero, NotEQUAL,
    input [2:0] Branch_D,
    output reg PCSrcD
);

always @(*) begin : proc_Branch_Unit
	PCSrcD=0;
	case (Branch_D)
	    3'b001 : if (IsZero || IsBiggerThanZero)
	                 PCSrcD=1;

	    3'b010 : if(IsLessThanZero)
	                 PCSrcD=1;

	    3'b011 : if(EQUAL)
	                 PCSrcD=1;

	    3'b100 : if(NotEQUAL)
	                 PCSrcD=1;

	    3'b101 : if(IsLessThanZero || EQUAL)
	                PCSrcD=1;

	    3'b110 : if (IsBiggerThanZero)
	                PCSrcD=1;

		default : PCSrcD=0;
	endcase
end

endmodule
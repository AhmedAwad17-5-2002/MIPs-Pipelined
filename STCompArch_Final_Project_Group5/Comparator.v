module Comparator (
	input signed [31:0] out_muxRD1,out_muxRD2,
    output EQUAL, IsBiggerThanZero, IsLessThanZero, IsZero, NotEQUAL
);


assign IsZero=(out_muxRD1==0)? 1 : 0;
assign IsBiggerThanZero=(out_muxRD1[31]==0 && (|out_muxRD1[30:0]))? 1 : 0;
assign IsLessThanZero=(out_muxRD1[31]==1)? 1 : 0;
assign EQUAL = (out_muxRD1==out_muxRD2)? 1 : 0;
assign NotEQUAL = (out_muxRD1==out_muxRD2)? 0 : 1;

endmodule
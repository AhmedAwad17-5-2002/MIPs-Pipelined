module sign_extend (
input   [15:0] in,
input LUI_IM,ORI_IM,
output reg  [31:0] out
);

parameter SIGN=1;
always@(*)
begin
if(SIGN &!LUI_IM &!ORI_IM)
     out = {{16{in[15]}},in};
else if(LUI_IM & !ORI_IM)
	  out = {in,16'd0};
else
	out = {16'd0,in};
end
endmodule
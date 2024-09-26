module BiDirecPAD (oe, clk, inp1, inp2, mux_sel, outp, bidir);

// Port Declaration

input   oe;
input   clk;
input   inp1;
input   inp2;
input   mux_sel;
output  outp;
inout   bidir;

reg     a;
reg     b;
wire    in_after_mux;
assign in_after_mux = mux_sel? inp2 : inp1;
assign bidir = oe ? a : 1'bZ ;
assign outp  = b;

// Always Construct

always @ (posedge clk)
begin
    b <= bidir;
    a <= in_after_mux;
end

endmodule
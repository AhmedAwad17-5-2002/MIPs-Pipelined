module Load_Unit (
	input LOAD_BYTE, LOAD_HW, LOAD_WORD, LOAD_BYTE_UNSIGNED, LOAD_HW_UNSIGNED,
	input [31:0] data_load_in,

	output reg [31:0] data_load_out,
	output reg load_en
);
always @(*) begin
	load_en=1;
	data_load_out=0;
	if(LOAD_BYTE==1)
		data_load_out={{24{data_load_in[7]}}, data_load_in[7:0]};
	else if (LOAD_HW)
		data_load_out={{16{data_load_in[15]}}, data_load_in[15:0]};
	else if (LOAD_WORD)
		data_load_out=data_load_in;
	else if (LOAD_BYTE_UNSIGNED)
		data_load_out={24'd0, data_load_in[7:0]};
	else if (LOAD_HW_UNSIGNED)
		data_load_out={16'd0, data_load_out[15:0]};
	else begin
		data_load_out=0;
		load_en=0;
	end

end
endmodule
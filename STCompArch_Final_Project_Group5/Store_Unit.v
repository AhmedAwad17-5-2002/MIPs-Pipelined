module Store_Unit (
	input STORE_BYTE, STORE_HW, STORE_WORD,
	input [31:0] data_store_in,

	output reg [31:0] data_store_out,
	output reg store_en 
);

always @(*) begin
	store_en=1;
	data_store_out=0;
	if(STORE_BYTE)
		data_store_out={{24{data_store_in[7]}}, data_store_in[7:0]};
	else if(STORE_HW)
		data_store_out={{16{data_store_in[15]}}, data_store_in[15:0]};
	else if(STORE_WORD)
		data_store_out=data_store_in;
	else begin
		data_store_out=0;
		store_en=0;
	end

end

endmodule
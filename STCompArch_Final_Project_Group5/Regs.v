module Regs (
	input clk,    // Clock
	input enable, // write Enable
	input rst_n,  // Asynchronous reset active low
	input [31:0] data_in,
	output reg [31:0] data_out	
);

always @(posedge clk or negedge rst_n) begin 
	if(~rst_n) begin
		data_out <= 0;
	end else if(enable) begin
		data_out <= data_in ;
	end
end

endmodule 
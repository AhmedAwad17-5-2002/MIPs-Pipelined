module instr_mem ( 
  input  [31:0] PC,
  input  clk,
  output reg [31:0] instrucion
);
reg [31:0] PC_OPT, out1, out2;
(* rom_style = "block" *) reg  [7:0] instr [4095:0];
(* rom_style = "block" *) reg  [7:0] handler [1023:0];


initial begin
  $readmemh("Test3_v3.mem",instr); //Test2_v2
  $readmemh("handler.mem",handler);
end


always @(*) begin 
 if({PC[31:28],PC[11:0]}>= 16'h8180)
   PC_OPT=PC-32'h81000080;  
 else 
   PC_OPT=PC;
end


always @(negedge clk) begin
    out1 <=  {handler[PC_OPT+3],handler[PC_OPT+2],handler[PC_OPT+1],handler[PC_OPT]};
    out2 <=  {instr[PC_OPT+3],instr[PC_OPT+2],instr[PC_OPT+1],instr[PC_OPT]};
end
  
always @(*) begin
    if(PC>=32'h8180)
      instrucion = out1;
    else
      instrucion = out2;
end

endmodule
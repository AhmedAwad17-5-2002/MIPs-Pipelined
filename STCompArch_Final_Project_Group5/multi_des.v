module multiplier(Z, rst_n, X, Y, start,clk, DONE);
output [63:0] Z;
input [31:0] X, Y;
input rst_n;
input clk;
input start;
output  DONE;
reg [31:0] A, Q, M;
reg Q_1;
reg [5:0] count;
wire [31:0] sum, difference;
reg [1:0]  state;
    
    localparam IDLE     = 2'd0,
               EXECUTE  = 2'd1;

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        A <= 32'b0;
        M <= 0;
        Q <= 0;
        Q_1 <= 1'b0;
        count<=0;
        // DONE<=0;
        state <= IDLE;
    end
    else
     begin
        case (state)
            IDLE: begin
        if (start) begin
        A <= 32'b0;
        M <= X;
        Q <= Y;
        Q_1 <= 1'b0;
        count<=0;
        // DONE<= 0;
        state <= EXECUTE ;
       end
   end 
           EXECUTE: begin
        if(count<34) begin 
          if (count == 33)
            state <= IDLE ;
        else if (count<32) begin
        case ({Q[0], Q_1})
            2'b0_1 : {A, Q, Q_1} <= {sum[31], sum, Q};
            2'b1_0 : {A, Q, Q_1} <= {difference[31], difference, Q};
            default: {A, Q, Q_1} <= {A[31], A, Q};
        endcase
    end
        count<=count+1;
        
    end 

        end 
   endcase
    end
end

alu_t adder (sum, A, M, 1'b0);
alu_t subtracter (difference, A, ~M, 1'b1);
assign Z = {A, Q};
assign DONE = (count==32)? 1 : 0;
endmodule

module alu_t(out, a, b, cin);
output [31:0] out;
input [31:0] a;
input [31:0] b;
input cin;
assign out = a + b + cin;
endmodule
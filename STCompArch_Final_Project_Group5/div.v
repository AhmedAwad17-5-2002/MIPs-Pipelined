module Div (
    input clk,
    input reset,
    input start,
    input [31:0] dividend,
    input [31:0] divisor,
    output reg [31:0] quotient,
    output reg [31:0] remainder,
    output reg done
);
    reg [31:0] partial_remainder;
    reg [31:0] partial_quotient;
    reg [5:0]  count;
    reg [1:0]  state;
    
    localparam IDLE     = 2'd0,
               EXECUTE  = 2'd1;


    always @(posedge clk or negedge reset) 
      begin
        if (!reset) 
          begin
            quotient <= 32'b0;
            remainder <= 32'b0;
            partial_remainder <= 32'b0;
            partial_quotient <= 32'b0;
            count <= 6'b0;
            done <= 1'b0;
            state <= IDLE;
          end 
        else 
          begin
            case (state)
              IDLE: begin
                      if (start) 
                        begin
                              quotient <= 0;
                              remainder <= 0;
                              partial_remainder <= 32'b0;
                              partial_quotient <= dividend;
                              count <= 6'd32; // Initialize count to 32 for 32-bit division
                              done <= 1'b0;
                              state <= EXECUTE;
                      end
                    end
                EXECUTE: begin
                           if (count > 0 && done == 0) 
                             begin
                               // Shift partial_quotient left and bring down the next bit of the dividend
                               partial_remainder = {partial_remainder[30:0], partial_quotient[31]};
                               partial_quotient = partial_quotient << 1;
                               
                               if (partial_remainder >= divisor) 
                                 begin
                                   partial_remainder = partial_remainder - divisor;
                                   partial_quotient[0] = 1'b1;
                                 end 
                               else 
                                 begin
                                   partial_quotient[0] = 1'b0;
                                 end
                               count <= count - 1;
                             end 
                           else 
                             begin
                               quotient <= partial_quotient;
                               remainder <= partial_remainder;
                               done <= 1'b1;
                               state <= IDLE;
                             end
                         end
            endcase
        end
      end
endmodule

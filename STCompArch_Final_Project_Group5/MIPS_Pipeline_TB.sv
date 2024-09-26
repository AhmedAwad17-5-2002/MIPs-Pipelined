`timescale 1ns/1ns
module MIPS_Pipeline_TB(IO);
    bit EXTIN;
    bit  CLK;
    // logic  [31:0] w_data;
    // logic  [31:0] w_addr;
    logic  w_en;
    logic  rst_n;
    // logic  enable;
    logic Interrupt;

     logic [3:0] reg_led_out,RD_OUT;
    wire [31:0] hand;
    inout [19:0] IO;
    // assign  hand = 32'h8180-32'd28668;

    //clk, reset, pc, instr, aluout, writedata, memwrite, and readdata

    wrapper DUT (.*);

    assign IO[17]=1'b1;
    assign IO[18]=rst_n;
    assign IO[19]=1'b0;
    // generate clock
    always begin
        #1 CLK = ~CLK;
    end



    initial begin
        
        $dumpfile("MIPS.vcd") ;       
        $dumpvars;
       // IO[17]=1'b0;

        // enable=0;
        w_en=0;
        // w_data=0;
        // w_addr=0;
        rst_n=0;
        Interrupt=0;
        #20;
        rst_n=1;
        // initialize all variables
        for (int i = 0; i < 36864; i++) begin
            DUT.MIPS.reg_file.mem[i]=i;
            // DUT.MIPS.data_memory.d_mem[i]=0;
            // DUT.MIPS.inst_memory.instr[i]=0;
        end
        
        #300;
        $stop;

    end

endmodule

  
  

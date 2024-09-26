module wrapper (
input  CLK,   // Clock
    
    inout [19:0] IO
);
   parameter  PORTWIDTH                      = 16'b1000;
   parameter  ALTFUNC                        =  4;
    wire [31:0] out;
    wire FlushE,FCLK;
	wire ForwardAD, ForwardBD;
    wire [1:0] ForwardAE, ForwardBE;
    wire EN0, EN1;
    wire [4:0]  RsD_out_D;
    wire [4:0]  RtD_out_D;
    wire [4:0]  RsD_out_E;
    wire [4:0]  RtD_out_E;
    wire [4:0]  WriteReg_out_E;
    wire [4:0]  WriteReg_out_M;
    wire [4:0]  WriteReg_out_W;
    wire [2:0] Branch_D_out;
    wire RegWrite_E_out;
    wire RegWrite_M_out;
    wire RegWrite_W_out;
    wire MemToReg_E_out;
    wire MemToReg_M_out;
    wire Jump_D_out;
    wire Jump_Link_D_out;
    wire jr_rs_D_out;
    wire jalr_rs_D_out;
    wire jalr_rs_E_out;
    wire jalr_rs_M_out;

    // wire [31:0] C0;
    wire start_div_D, start_div_E, done_div_E;
  
    
    wire exception;
    wire OverFlow_M;
    wire OverFlow_E_OUT;
    wire Undefined_Instruction;
    wire BREAK_D,BREAK_E,DivByZero;
    wire OverFlow_W;
    wire MISSED_BUF, HIT_BUF;
    wire PCSrc_D_E, PCSrc_D;
    wire offset;
    wire mfc0_D,mfc0_E,mfc0_M,mfc0_W;
    wire [1:0] forwardEXC;
    wire mul_en_D_out, mul_DONE;
    wire  [3:0]      ECOREVNUM_gpio, ECOREVNUM_uart,ECOREVNUM_time;
    wire o_hresp, o_hresp_0, o_hresp_1;
    wire  [31:0] o_hrdata, i_hrdata_1, i_hrdata_0, o_hrdata_0,i_hrdata_2;
    wire  [4:0] o_sel;
    wire  o_hready, o_hreadyout_1, o_hreadyout_0;
    wire  i_hresp_2,i_hready_2;
    wire  [31:0] ReadData_W;
    wire [31:0] ALUOut_M,DATA_TO_WRITE,DATA_TO_WRITE_W,data_to_mips,timer_out,PRDATA_uart;
    wire  MemWrite_M,PREADY_TIMER,PREADY_UART;
    wire  [2:0] i_hsize_M;
    wire  [1:0] i_htrans_M, def_HTRANS;

    wire [15:0]                                   PORTOUT,PORTOUT_mux,data_out;    // GPIO output
    wire [15:0]                                   PORTEN,PORTEN_mux;    // GPIO output enable
    wire [15:0]                                   PORTFUNC;   // Alternate function control
    wire [PORTWIDTH*$clog2(ALTFUNC)-1:0]          ALT_FUNC;   // Alternate function selector
    wire [15:0]                                   GPIOINT;    // Interrupt output for each pin
    wire                                          COMBINT;

    //APB Bridge
    wire i_start_M,i_pready,i_pslverr,o_transfer_status,o_valid,o_ready,o_pwrite,o_penable;
    wire TIMERINT;
    wire [1:0] o_psel;
    wire [31:0] i_prdata,o_paddr,o_pwdata,o_data_out, def_HDATA;
    wire [3:0] RD_OUT;
    wire [3:0] reg_led_out;
    

//MIPS PROCESSOR (MASTER)
    TOP MIPS (.Branch_D_out(Branch_D_out), .CLK(CLK), .rst_n(rst_n), .out(out),
     .ForwardAD(ForwardAD), .ForwardBD(ForwardBD), .EN0(EN0), .EN1(EN1), .ForwardAE(ForwardAE), .ForwardBE(ForwardBE), .RsD_out_D(RsD_out_D),
      .RsD_out_E(RsD_out_E), .RtD_out_D(RtD_out_D), .RtD_out_E(RtD_out_E), .MemToReg_E_out(MemToReg_E_out), .MemToReg_M_out(MemToReg_M_out),
       .RegWrite_E_out(RegWrite_E_out), .RegWrite_M_out(RegWrite_M_out), .RegWrite_W_out(RegWrite_W_out), .WriteReg_out_E(WriteReg_out_E),
        .WriteReg_out_M(WriteReg_out_M), .WriteReg_out_W(WriteReg_out_W), .FlushE(FlushE), .jr_rs_D_out(jr_rs_D_out), .jalr_rs_D_out(jalr_rs_D_out),
         .Jump_D_out(Jump_D_out), .Jump_Link_D_out(Jump_Link_D_out), .exception(exception), .OverFlow_M_OUT(OverFlow_M), .OverFlow_E_out(OverFlow_E), 
          .Undefined_Instruction_out(Undefined_Instruction), .DivByZero_out(DivByZero), .BREAK_D_out(BREAK_D), .Interrupt(COMBINT|TIMERINT|TXINT|RXINT|TXOVRINT|RXOVRINT|UARTINT),
           .OverFlow_W_out(OverFlow_W),.BREAK_E_out(BREAK_E), .MISSED_BUF(MISSED_BUF), .PCSrc_D_E_out(PCSrc_D_E), .PCSrc_D_out(PCSrc_D), .HIT_BUF(HIT_BUF), .state(state), .offset(offset), 
            .mfc0_D_out(mfc0_D), .mfc0_E_out(mfc0_E), .mfc0_M_out(mfc0_M), .mfc0_W_out(mfc0_W), .forwardEXC(forwardEXC), .start_div_D(start_div_D),
             .start_div_E(start_div_E), .done_div_E(done_div_E), .mul_en_D_out(mul_en_D_out), .mul_DONE(mul_DONE),.reg_out(reg_led_out),.RD_OUT(RD_OUT),.jalr_rs_E_out(jalr_rs_E_out),
              .jalr_rs_M_out(jalr_rs_M_out),.jalr_rs_W_out(jalr_rs_W_out), .o_hready(o_hready),.ReadData_W(ReadData_W),.ALUOut_M(ALUOut_M),.DATA_TO_WRITE(DATA_TO_WRITE),
               .MemWrite_M(MemWrite_M),.i_hsize_M(i_hsize_M),.i_htrans_M(i_htrans_M),.DATA_TO_WRITE_W(DATA_TO_WRITE_W),.i_start_M(i_start_M));


// DECODER AND MUX (AHB INTERFACE )
AHB_IF IF (.i_hclk(CLK), .i_hreset(rst_n), .o_hresp(o_hresp), .o_hrdata(ReadData_W), .o_sel(o_sel), .o_hready(o_hready), .i_haddr(ALUOut_M), .i_htrans_in(i_htrans_M),
 .i_hresp_0(o_hresp_0), .i_hrdata_0(o_hrdata_0), .i_hready_0(o_hreadyout_0),
  .i_hresp_1(o_hresp_1), .i_hrdata_1(i_hrdata_1), .i_hready_1(o_hreadyout_1),.i_hrdata_2(data_to_mips),.i_hresp_2(i_hresp_2),.i_hready_2(PREADY_TIMER),
   .i_hresp_3  (PSLVERR_uart), .i_hrdata_3(data_to_mips), .i_hready_3(PREADY_uart), .i_hresp_4(def_HRESP), .i_hrdata_4(def_HDATA), .i_hready_4(def_HREADY));

//DATA MEMORY
AHB2BRAM SLAVE_0 (.HCLK(CLK), .HRESETn(rst_n), .HSEL(o_sel[0]), .HADDR(ALUOut_M), .HWRITE(MemWrite_M), .HSIZE(i_hsize_M),
 .HTRANS(i_htrans_M), .HREADY(o_hready), .HWDATA(DATA_TO_WRITE), .HREADYOUT(o_hreadyout_0), .HRESP(o_hresp_0), .HRDATA(o_hrdata_0));


 //tristate buffer 
assign PORTOUT_mux=PORTFUNC?ALT_FUNC:PORTOUT;
assign PORTEN_mux=PORTFUNC?ALT_FUNC:PORTEN;
// assign data_out = PORTEN_mux ? PORTOUT_mux : 1'bz;

// assign RX_in = IO[17];
wire mux_sel=1'b0;
genvar i;
generate
    for(i=0; i<16; i=i+1) begin
        if(i==0)
           BiDirecPAD UI_1 (.oe(1'b1), .clk(CLK), .inp1(PORTOUT[i]), .outp(data_out[i]), .bidir(IO[i]), .inp2(1'b0), .mux_sel(mux_sel));
        else
            BiDirecPAD UI_1 (.oe(1'b1), .clk(CLK), .inp1(PORTOUT[i]), .outp(data_out[i]), .bidir(IO[i]), .inp2(1'b0), .mux_sel(mux_sel));
    end       
endgenerate
BiDirecPAD UI_2 (.oe(1'b1), .clk(CLK), .inp1(1'b0), .outp(XX), .bidir(IO[16]), .inp2(1'b0), .mux_sel(1'b1));
BiDirecPAD UI_3 (.oe(1'b0), .clk(CLK), .inp1(1'b0), .outp(RX_in), .bidir(IO[17]), .inp2(1'b0), .mux_sel(1'b1));
BiDirecPAD UI_4 (.oe(1'b0), .clk(CLK), .inp1(1'b0), .outp(rst_n), .bidir(IO[18]), .inp2(1'b0), .mux_sel(1'b1));
BiDirecPAD UI_5 (.oe(1'b0), .clk(CLK), .inp1(1'b0), .outp(EXTIN), .bidir(IO[18]), .inp2(1'b0), .mux_sel(1'b1));

assign rst_n=IO[18];
assign EXTIN=IO[19];
//GPIO
cmsdk_ahb_gpio SLAVE_1(.HCLK(CLK),.HRESETn(rst_n),.FCLK(CLK),.HSEL(o_sel[1]),.HREADY(o_hready),.HTRANS(i_htrans_M),.HSIZE(i_hsize_M),.HWRITE(MemWrite_M),.HADDR(ALUOut_M[11:0]),
    .HWDATA(DATA_TO_WRITE),.ECOREVNUM(ECOREVNUM_gpio),.PORTIN(data_out),.HREADYOUT(o_hreadyout_1),.HRESP(o_hresp_1),.HRDATA(i_hrdata_1),.PORTOUT(PORTOUT),.PORTEN(PORTEN),
    .PORTFUNC(PORTFUNC),
    .ALT_FUNC(ALT_FUNC),.GPIOINT(GPIOINT),.COMBINT(COMBINT));

//AHB2APB BRIIDGE 
APB_Master SLAVE_2(.i_prstn(rst_n),.i_pclk(CLK),.i_command(MemWrite_M),.i_start(o_sel[2]),.i_data_in(DATA_TO_WRITE),.i_addr_in(ALUOut_M),.i_prdata(timer_out),.i_pready(i_pready),
    .i_pslverr(i_pslverr),.o_paddr(o_paddr),.o_pwrite(o_pwrite),.o_psel(o_psel),.o_penable(o_penable),.o_pwdata(o_pwdata),.o_data_out(o_data_out),.o_transfer_status(o_transfer_status),
    .o_valid(o_valid),.o_ready(o_ready));

assign data_to_mips=o_psel[1]?timer_out: o_psel[0]?PRDATA_uart :0;

//TIMER SLAVE
 cmsdk_apb_timer timer_SLAVE(.PCLK(CLK), .PCLKG(CLK), .PRESETn(rst_n),  .PSEL(o_psel[1]),.PADDR(o_paddr[11:2]),.PENABLE(o_penable),.PWRITE(o_pwrite), .PWDATA(o_pwdata),
                              .ECOREVNUM(ECOREVNUM_time),.PRDATA(timer_out),.PREADY(PREADY_TIMER),.PSLVERR(i_hresp_2),.EXTIN(EXTIN),.TIMERINT(TIMERINT)); 


cmsdk_apb_uart UART_SLAVE (.PCLKG(CLK),.PCLK(CLK),.PRESETn(rst_n),  .PSEL(o_psel[0]),  .PADDR(o_paddr[11:2]), .PENABLE(o_penable),.PWRITE(o_pwrite), .PWDATA(o_pwdata), 
                            .ECOREVNUM(ECOREVNUM_uart),.PRDATA(PRDATA_uart),.PREADY(PREADY_uart), .PSLVERR(PSLVERR_uart),.RXD(RX_in),.TXD(TX_out),.TXEN(TXEN),.BAUDTICK(BAUDTICK),
                             .TXINT(TXINT),.RXINT(RXINT),.TXOVRINT(TXOVRINT),.RXOVRINT(RXOVRINT),.UARTINT(UARTINT));

//HAZARD UNIT 
    Hazards_Control_Unit hazard_unit ( .BranchD(Branch_D_out), .RegWriteE(RegWrite_E_out), .RegWriteM(RegWrite_M_out), .RegWriteW(RegWrite_W_out),
     .MemtoRegE(MemToReg_E_out), .MemtoRegM(MemToReg_M_out), .rsD(RsD_out_D), .rsE(RsD_out_E), .rtD(RtD_out_D), .rtE(RtD_out_E), .WriteRegE(WriteReg_out_E),
      .WriteRegM(WriteReg_out_M), .WriteRegW(WriteReg_out_W), .forwardAE(ForwardAE), .forwardBE(ForwardBE), .forwardAD(ForwardAD), .forwardBD(ForwardBD),
       .StallD(EN1), .StallF(EN0), .FlushE(FlushE), .jr_rs(jr_rs_D_out), .jalr_rs(jalr_rs_D_out), .Jump_D(Jump_D_out), .Jump_Link_D(Jump_Link_D_out),
        .exception(exception), .OverFlow_M(OverFlow_M), .OverFlow_E(OverFlow_E), .Undefined_Instruction(Undefined_Instruction), 
         .BREAK_D(BREAK_D), .DivByZero(DivByZero), .Interrupt(Interrupt), .OverFlow_W(OverFlow_W), .BREAK_E(BREAK_E), .MISSED_BUF(MISSED_BUF),
          .PCSrc_D_E(PCSrc_D_E), .PCSrc_D(PCSrc_D), .HIT_BUF(HIT_BUF), .state(state), .offset(offset), .mfc0_D(mfc0_D), .mfc0_E(mfc0_E), 
           .mfc0_M(mfc0_M), .mfc0_W(mfc0_W), .forwardEXC(forwardEXC), .start_div_D(start_div_D), .start_div_E(start_div_E), .done_div_E(done_div_E),
            .mul_en_D_out(mul_en_D_out), .mul_DONE(mul_DONE),.jalr_rs_E_out(jalr_rs_E_out),.jalr_rs_M_out(jalr_rs_M_out),.jalr_rs_W_out(jalr_rs_W_out));

endmodule
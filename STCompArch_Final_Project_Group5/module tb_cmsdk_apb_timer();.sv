module tb_cmsdk_apb_timer();

  // Clock and reset signals
  reg PCLK, PCLKG, PRESETn;

  // APB interface signals
  reg PSEL, PENABLE, PWRITE;
  reg [11:2] PADDR;
  reg [31:0] PWDATA;
  wire [31:0] PRDATA;
  wire PREADY;
  wire PSLVERR;

  // External input and timer interrupt
  reg EXTIN;
  wire TIMERINT;

  // Engineering-change-order revision bits
  reg [3:0] ECOREVNUM;

  // Instantiate the DUT
  cmsdk_apb_timer uut (
    .PCLK(PCLK),
    .PCLKG(PCLKG),
    .PRESETn(PRESETn),
    .PSEL(PSEL),
    .PADDR(PADDR),
    .PENABLE(PENABLE),
    .PWRITE(PWRITE),
    .PWDATA(PWDATA),
    .ECOREVNUM(ECOREVNUM),
    .PRDATA(PRDATA),
    .PREADY(PREADY),
    .PSLVERR(PSLVERR),
    .EXTIN(EXTIN),
    .TIMERINT(TIMERINT)
  );

  // Clock generation
  initial begin
    PCLK = 0;
    forever #5 PCLK = ~PCLK;  // 100 MHz clock
  end

  // Gated clock generation
  initial begin
    PCLKG = 0;
    forever #7.5 PCLKG = ~PCLKG;  // Gated clock slightly off from PCLK for testing
  end

  // Reset generation
  initial begin
    PRESETn = 1'b0;
    #20 PRESETn = 1'b1;  // Apply reset
  end

  // APB tasks for write and read
  task apb_write(input [11:2] addr, input [31:0] data);
    begin
      @(posedge PCLK);
      PSEL = 1'b1;
      PADDR = addr;
      PWDATA = data;
      PWRITE = 1'b1;
      PENABLE = 1'b0;
      @(posedge PCLK);
      PENABLE = 1'b1;
      @(posedge PCLK);
      PSEL = 1'b0;
      PENABLE = 1'b0;
    end
  endtask

  task apb_read(input [11:2] addr);
    begin
      @(posedge PCLK);
      PSEL = 1'b1;
      PADDR = addr;
      PWRITE = 1'b0;
      PENABLE = 1'b0;
      @(posedge PCLK);
      PENABLE = 1'b1;
      @(posedge PCLK);
      PSEL = 1'b0;
      PENABLE = 1'b0;
    end
  endtask

  // Test stimulus
  initial begin
    // Initialize signals
    PSEL = 1'b0;
    PENABLE = 1'b0;
    PWRITE = 1'b0;
    PADDR = 10'b0;
    PWDATA = 32'b0;
    ECOREVNUM = 4'b0010;
    EXTIN = 1'b0;

    // Wait for reset to deassert
    wait (PRESETn == 1'b1);
    #10;

    // Write to control register (Enable timer, no external input, no interrupt)
    apb_write(10'h000, 32'h00000001);  // Control register

    // Write reload value
    apb_write(10'h002, 32'h0000000A);  // Reload value for the timer

    // Write current value
    apb_write(10'h001, 32'h0000000A);  // Set current value

    // Start decrementing the timer and monitor interrupt
    #50;
    apb_read(10'h001);  // Read current value
    #50;

    // Simulate external input to trigger interrupt
    EXTIN = 1'b1;
    #20;
    EXTIN = 1'b0;
    #50;

    // Write to clear interrupt
    apb_write(10'h003, 32'h00000001);  // Clear interrupt
    #50;

    $finish;
  end

  // Monitor signals
  initial begin
    $monitor("Time: %t | Current Value: %h | Timer Interrupt: %b | PSLVERR: %b",
              $time, PRDATA, TIMERINT, PSLVERR);
  end

endmodule
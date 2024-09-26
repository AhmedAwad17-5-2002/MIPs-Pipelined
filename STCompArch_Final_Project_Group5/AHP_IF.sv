module AHB_IF(i_hclk,i_hreset,i_haddr,
              i_hresp_0,i_hrdata_0,i_hready_0,
              i_hresp_1,i_hrdata_1,i_hready_1,
              o_sel,o_hrdata,o_hresp,o_hready,i_htrans_in,i_hrdata_2,i_hresp_2,i_hready_2, i_hresp_3,i_hrdata_3,i_hready_3,i_hresp_4,
              i_hrdata_4,i_hready_4);


//Parameters
parameter ADDR_WIDTH=32;                                     //Address bus width
parameter DATA_WIDTH=32;                                     //Data bus width
parameter SLAVE_COUNT=5;                                     //Number of connected AHB slaves

parameter REGISTER_SELECT_BITS=16;                           //Memory mapping - each slave's internal memory has maximum 2^REGISTER_SELECT_BITS-1 bytes (depends on MEMORY_DEPTH)
parameter SLAVE_SELECT_BITS=16;                              //Memory mapping - width of slave address
parameter [SLAVE_SELECT_BITS-1:0] ADDR_SLAVE_0 = 16'h0000;   //Address of slave 0
parameter [SLAVE_SELECT_BITS-1:0] ADDR_SLAVE_1 = 16'hA000;   //ADdress of slave 1 GPIO
parameter [SLAVE_SELECT_BITS-1:0] ADDR_SLAVE_2 = 16'hA400;   //UART
parameter [SLAVE_SELECT_BITS-1:0] ADDR_SLAVE_3 = 16'hAC00;   //TIMERS

localparam MUX_SELECT = $clog2(SLAVE_COUNT);                 //Number of bits required to select a single slave

//Inputs 
input logic i_hclk;                                          //All signal timings are related to the rising edge of hclk
input logic i_hreset;                                        //Active low bus reset
input logic [ADDR_WIDTH-1:0] i_haddr;                        //Input address from which both a slave is selected (MSBs) and internal memory slot (LSBs)

input logic i_hresp_0;                                       //Slave 0 transfer response
input logic [DATA_WIDTH-1:0] i_hrdata_0;                     //Slave 0 read data bus
input logic i_hready_0;                                      //Slave 0 'hreadyout' signal

input logic i_hresp_1;                                       //Slave 1 transfer response
input logic [DATA_WIDTH-1:0] i_hrdata_1;                     //Slave 1 read data bus
input logic i_hready_1;                                      //Slave 1 'hreadyout' signal

input logic i_hresp_2;                                       //Slave 2 transfer response
input logic [DATA_WIDTH-1:0] i_hrdata_2;                     //Slave 2 read data bus
input logic i_hready_2;                                      //Slave 2 'hreadyout' signal

input logic i_hresp_3;                                       //Slave 2 transfer response
input logic [DATA_WIDTH-1:0] i_hrdata_3;                     //Slave 2 read data bus
input logic i_hready_3;  

input logic i_hresp_4;                                       //Slave 2 transfer response
input logic [DATA_WIDTH-1:0] i_hrdata_4;                     //Slave 2 read data bus
input logic i_hready_4;  

input [1:0] i_htrans_in;

//Outpus
output logic [SLAVE_COUNT-1:0] o_sel;                        //Slave select bus 
output logic [DATA_WIDTH-1:0] o_hrdata;                      //read data bus (after multiplexer)
output logic o_hresp;                                        //slave transfer response (after multiplexer)
output logic o_hready;                                       //slave hreadyout signal (after multiplexer)

//Internal signals
logic [MUX_SELECT-1:0] mux_select;                           //'mux_select' signal selects a slave to provide the master with read data packet (hrdata,hresp and hready)


//HDL code
always @(*)
begin
if({i_haddr[ADDR_WIDTH-1:ADDR_WIDTH-4],i_haddr[11:0]}>=ADDR_SLAVE_0
  &{i_haddr[ADDR_WIDTH-1:ADDR_WIDTH-4],i_haddr[11:0]}<ADDR_SLAVE_1)
  o_sel=5'b00001;
else if({i_haddr[ADDR_WIDTH-1:ADDR_WIDTH-4],i_haddr[11:0]}>=ADDR_SLAVE_1
  &{i_haddr[ADDR_WIDTH-1:ADDR_WIDTH-4],i_haddr[11:0]}<ADDR_SLAVE_2)
   o_sel=5'b00010;
 else if({i_haddr[ADDR_WIDTH-1:ADDR_WIDTH-4],i_haddr[11:0]}>=ADDR_SLAVE_2
    &{i_haddr[ADDR_WIDTH-1:ADDR_WIDTH-4],i_haddr[11:0]}<ADDR_SLAVE_3)
   o_sel<=5'b00100;
 else if({i_haddr[ADDR_WIDTH-1:ADDR_WIDTH-4],i_haddr[11:0]}>=ADDR_SLAVE_3)
   o_sel<=5'b01000;
   else
   o_sel<=5'b00001;
end

always @(posedge i_hclk or negedge i_hreset)
  if (!i_hreset)
    mux_select<='b0;
  else if (o_hready)
  begin
  if({i_haddr[ADDR_WIDTH-1:ADDR_WIDTH-4],i_haddr[11:0]}>=ADDR_SLAVE_0
  &{i_haddr[ADDR_WIDTH-1:ADDR_WIDTH-4],i_haddr[11:0]}<ADDR_SLAVE_1)
  mux_select<='b000;
  else if({i_haddr[ADDR_WIDTH-1:ADDR_WIDTH-4],i_haddr[11:0]}>=ADDR_SLAVE_1
  &{i_haddr[ADDR_WIDTH-1:ADDR_WIDTH-4],i_haddr[11:0]}<ADDR_SLAVE_2)
   mux_select<='b001;
  else if({i_haddr[ADDR_WIDTH-1:ADDR_WIDTH-4],i_haddr[11:0]}>=ADDR_SLAVE_2
    &{i_haddr[ADDR_WIDTH-1:ADDR_WIDTH-4],i_haddr[11:0]}<ADDR_SLAVE_3)
   mux_select<='b010;
 else if({i_haddr[ADDR_WIDTH-1:ADDR_WIDTH-4],i_haddr[11:0]}>=ADDR_SLAVE_3)
   mux_select<='b011;
   else
   mux_select<='b000;
end


always @(*)
begin
  o_hrdata = 0;
  o_hresp =0;
  o_hready = 1;
  
  case (mux_select)
   0: begin
      o_hrdata = i_hrdata_0;
      o_hresp = i_hresp_0;
      o_hready = i_hready_0;
    end

   1: begin
      o_hrdata = i_hrdata_1;
      o_hresp = i_hresp_1;
      o_hready = i_hready_1;
    end
   2: begin
      o_hrdata = i_hrdata_2;
      o_hresp = i_hresp_2;
      o_hready = i_hready_2;
    end

    3: begin
      o_hrdata = i_hrdata_3;
      o_hresp = i_hresp_3;
      o_hready = i_hready_3;
    end

    default: begin
      o_hrdata = i_hrdata_4;
      o_hresp = i_hresp_4;
      o_hready = i_hready_4;
    end
  endcase 

end

endmodule
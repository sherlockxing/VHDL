////////////////////////////////////////////////////////////////////////////////
// Copyright (c) WSCEC, Inc. All rights reserved.                               
////////////////////////////////////////////////////////////////////////////////
//   _      ___ ___________  _____                                              
//  | | /| / /  __/ ___/ _ \/ ___/  Group of RNSS_RECORDPLAYBACK
//  | |/ |/ (__  ) /__/  __/ /__                                                
//  |__/|__/____/\___/\___/\___/    2012                                        
//______________________________________________________________________________
//                                                                              
// Engineer :                                                             
// E-Mail :                                                   
//                                                                              
// Create Date :      hh:mm:ss  mm/dd/yy                                         
// Design Name :                                                
// Project Name :                                                                 
// Description :                                                              
//                                                                              
// Revision :                                                                   
// Additional Comments :                                                       
////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
module   spi_interface_mosi(clk,
                            rst,
                            i_data,
                            i_data_rdy,
                            o_tran_busy,
                            i_sclk,
                            o_sclk,
                            o_cs_n,
                            o_sdi);
parameter DWIDTH = 16; // The bit-width of i_data
parameter CLOCK_EDGE = 0;// The valid clock edge slave edge 1 --> rise edge, 0 --> falling edge
localparam FRAMELEN = DWIDTH;
localparam LCNT = clogb2(FRAMELEN) - 1;

input clk;
input rst;
input [DWIDTH - 1 : 0] i_data;
input i_data_rdy;
output o_tran_busy;
input i_sclk;
output o_sclk;
output o_cs_n;
output o_sdi;

reg [LCNT : 0] fcnt;

reg sclk_l1;
wire sclk_r;
wire sclk_f;
wire tran_edge;
wire sample_edge;
reg tran_end;
always @(posedge clk)
begin
  sclk_l1 <= i_sclk;
end
assign sclk_r = i_sclk && (!sclk_l1);
assign sclk_f = (!i_sclk) && sclk_l1;
assign sample_edge = CLOCK_EDGE ? sclk_r : sclk_f;
assign tran_edge = CLOCK_EDGE ? sclk_f : sclk_r;


reg busy;
always @(posedge clk or posedge rst)
begin
  if(rst) busy <= 1'b0;
  else if(i_data_rdy) busy <= 1'b1;
  else if(tran_end) busy <= 1'b0;
end


always @(posedge clk or posedge rst)
begin
  if(rst) fcnt <= 'd0;
  else if(i_data_rdy) fcnt <= FRAMELEN;
  else if(tran_edge) fcnt <= ('d0 == fcnt) ? 'd0 : (fcnt - 'd1);
end

reg csb;
always @(posedge clk or posedge rst)
begin
  if(rst) csb <= 1'b0;
  else if(busy && tran_edge) csb <= 1'b1;
  else if(tran_end) csb <= 1'b0;
end

always @(posedge clk or posedge rst)
begin
  if(rst) tran_end <= 1'b0;
  else tran_end <= ('d0 == fcnt) && tran_edge;
end

reg [FRAMELEN : 0] data;
always @(posedge clk)
begin
  if(i_data_rdy) data <= {1'b0, i_data};
  else if(tran_edge) data <= {data[FRAMELEN - 1 : 0], 1'b0};
end


assign o_sdi = data[FRAMELEN];
assign o_cs_n = !csb;
assign o_tran_busy = busy || i_data_rdy;
assign o_sclk = sclk_l1;


function integer clogb2;
input integer depth;
integer i,result;
begin
  for (i = 0; depth >= 2 ** i; i = i + 1)
    result = i + 1;
  clogb2 = result;
end
endfunction

endmodule

////////////////////////////////////////////////////////////////////////////////
//    ______           __  __                    __                            
//   /_  __/___  _____/ /_/ /_  ___  ____  _____/ /_                           
//    / /  / _ \/ ___/ __/ __ \/ _ \/ __ \/ ___/ __ \                          
//   / /  /  __(__  ) /_/ /_/ /  __/ / / / /__/ / / /                          
//  /_/   \___/____/\__/_.___/\___/_/ /_/\___/_/ /_/                           
//                                                                             
////////////////////////////////////////////////////////////////////////////////
`ifdef SIMULATION

`timescale 1ns/1ps
module tb_spi_interface_mosi;

parameter DWIDTH = 40;
parameter CLOCK_EDGE = 0;
parameter FRAMELEN = 40;


parameter CYC = 100;

reg clk;
reg rst;
reg [DWIDTH - 1 : 0] i_data;
reg i_data_rdy;
wire o_tran_busy;
reg i_sclk;
wire o_sclk;
wire o_cs_n;
wire o_sdi;
reg i_sdo;



initial clk = 1'b0;
always #(CYC/2) clk = ~clk;
initial
begin
  rst = 1'b1;
  #(100 * CYC);
  rst = 1'b0;
end


initial
begin
 #(100_000 * CYC);
 $stop;
end

reg [7 : 0] cnt;
always @(posedge clk or posedge rst)
begin
  if(rst) cnt <= 'd0;
  else cnt <= cnt + 'd1;
end
always @(posedge clk)
begin
  i_sclk <= cnt[7];
end

always @(posedge clk or  posedge rst)
begin
  if(rst) i_data_rdy <= 1'b0;
  else if(!o_tran_busy) i_data_rdy <= $random;
  else i_data_rdy <= 1'b0;
end
always @(posedge clk)
begin
  if(rst) i_data <= $random;
  else if(i_data_rdy) i_data <= $random;
end


spi_interface_mosi #(.DWIDTH(DWIDTH),
                       .CLOCK_EDGE(CLOCK_EDGE))
                       Uspi_interface_mosi(.clk(clk),
                                           .rst(rst),
                                           .i_data(i_data),
                                           .i_data_rdy(i_data_rdy),
                                           .o_tran_busy(o_tran_busy),
                                           .i_sclk(i_sclk),
                                           .o_sclk(o_sclk),
                                           .o_cs_n(o_cs_n),
                                           .o_sdi(o_sdi));

initial
begin
  $fsdbDumpfile("Utb_spi_interface_mosi.fsdb");
  $fsdbDumpvars();
end
endmodule
`endif

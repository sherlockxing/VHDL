////////////////////////////////////////////////////////////////////////////////
// Copyright (c) WSCEC, Inc. All rights reserved.                               
////////////////////////////////////////////////////////////////////////////////
//   _      ___ ___________  _____                                              
//  | | /| / /  __/ ___/ _ \/ ___/  Group of Ad-Hoc Network
//  | |/ |/ (__  ) /__/  __/ /__                                                
//  |__/|__/____/\___/\___/\___/    2013                                        
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
module     chip_wr(clk,
                   rst,
                   i_afe7225_sclk,
                   i_afe7225_data,
                   i_afe7225_data_rdy,
                   i_afe7225_sleep,
                   i_afe7225_wakeup,
                   i_afe7225_config,
                   o_afe7225_tran_busy,
                   i_afe7225_pd,
                   //
                   o_afe7225_spi_clk,
                   o_afe7225_spi_mosi,
                   i_afe7225_spi_miso,
                   o_afe7225_spi_le,
                   o_afe7225_pd,
                   //////////////////
                   i_cdce62002_spi_clk,
                   i_cdce62002_config,
                   i_cdce62002_sleep,
                   i_cdce62002_wakeup,
                   o_cdce62002_tran_busy,
                   o_cdce62002_pll_lock,    
                   i_clk_sel,
                   i_cdce62002_pd_n,                   
                   //
                   o_clk_sel,
                   o_cdce62002_spi_clk,
                   o_cdce62002_spi_mosi,
                   i_cdce62002_spi_miso,
                   i_cdce62002_pll_lock,
                   o_cdce62002_spi_le,
                   o_cdce62002_pd_n);
                   
                   
                   

//////////////////////////////////
parameter LEN_CDCE62002_INSTR = 32;
parameter CDCE62002_ADDR_MAX = 5;
parameter CDCE62002_ADDR_PD = 0;
parameter CDCE62002_ADDR_CONFIG = 4;
parameter CDCE62002_ADDR_WAKEUP = 3;
/////////////////////////////////////////////
parameter LEN_AFE7225_INSTR = 20;
parameter AFE7225_ADDR_MAX = 18;
parameter AFE7225_ADDR_CONFIG = 17;
parameter AFE7225_ADDR_PD = 0;
parameter AFE7225_ADDR_WAKEUP = 14;





input clk;
input rst;
/////////////////////////
input i_afe7225_sclk;
input [LEN_AFE7225_INSTR - 1 : 0] i_afe7225_data;
input i_afe7225_data_rdy;
input i_afe7225_sleep;
input i_afe7225_wakeup;
output o_afe7225_tran_busy;
input i_afe7225_pd;
input i_afe7225_config;
//
output o_afe7225_spi_clk;
output o_afe7225_spi_mosi;
input i_afe7225_spi_miso;
output o_afe7225_spi_le;
output o_afe7225_pd;
//////////////////
input i_cdce62002_spi_clk;
input i_cdce62002_config;
input i_cdce62002_sleep;
input i_cdce62002_wakeup;
output o_cdce62002_tran_busy;
output o_cdce62002_pll_lock;
input i_clk_sel;
input i_cdce62002_pd_n;
 //
output o_clk_sel;
output o_cdce62002_spi_clk;
output o_cdce62002_spi_mosi;
input i_cdce62002_spi_miso;
input i_cdce62002_pll_lock;
output o_cdce62002_spi_le;
output o_cdce62002_pd_n;





////////////////////////// process of afe7225/////////
localparam AFE7225_IDLE = 2'd0;
localparam AFE7225_CONFIG = 2'd1;
localparam AFE7225_WAKEUP = 2'd2;
localparam AFE7225_SLEEP = 2'd3;
localparam BWIDTH_AFE7225_ADDR = clogb2(AFE7225_ADDR_MAX);

//
wire [LEN_AFE7225_INSTR - 1 : 0] afe7225_i_data;
reg afe7225_i_data_rdy;
wire afe7225_o_tran_busy;
//
reg [1 : 0] afe7225_state;
reg [1 : 0] afe7225_next_state;
wire afe7225_config_end;
wire afe7225_wakeup_end;
wire afe7225_sleep_end;
//
reg [BWIDTH_AFE7225_ADDR - 1 : 0] afe7225_addr;





always @(posedge clk or posedge rst)
begin
  if(rst) afe7225_state <= AFE7225_IDLE;
  else afe7225_state <= afe7225_next_state;
end
always @(*)
begin
  if(rst) afe7225_next_state = AFE7225_IDLE;
  else
  begin
    case(afe7225_state)
      AFE7225_IDLE: 
      begin
        case({i_afe7225_config, i_afe7225_sleep, i_afe7225_wakeup})
          3'b100: afe7225_next_state = AFE7225_CONFIG;
          3'b010: afe7225_next_state = AFE7225_SLEEP;
          3'b001: afe7225_next_state = AFE7225_WAKEUP;
          default: afe7225_next_state = AFE7225_IDLE;
        endcase
      end
      AFE7225_CONFIG: afe7225_next_state = afe7225_config_end ? AFE7225_IDLE : AFE7225_CONFIG;
      AFE7225_WAKEUP: afe7225_next_state = afe7225_wakeup_end ? AFE7225_IDLE : AFE7225_WAKEUP;
      AFE7225_SLEEP: afe7225_next_state = afe7225_sleep_end ? AFE7225_IDLE : AFE7225_SLEEP; 
      default: afe7225_next_state = AFE7225_IDLE;
    endcase
  end
end

always @(posedge clk)
begin
  case(afe7225_state)
    AFE7225_IDLE: 
      begin
        case({i_afe7225_config, i_afe7225_sleep, i_afe7225_wakeup})
          3'b100: afe7225_addr <= 'd0;
          3'b010: afe7225_addr <= AFE7225_ADDR_PD;
          3'b001: afe7225_addr <= AFE7225_ADDR_WAKEUP;
          default: afe7225_addr <= 'd0;
        endcase
      end
    default: afe7225_addr <= afe7225_i_data_rdy ? (afe7225_addr + 'd1) : afe7225_addr;
  endcase
end

always @(posedge clk or posedge rst)
begin
  if(rst) afe7225_i_data_rdy <= 1'b0;
  else 
  begin
    case(afe7225_state)
      AFE7225_CONFIG: afe7225_i_data_rdy <= !afe7225_o_tran_busy;
      AFE7225_WAKEUP: afe7225_i_data_rdy <= !afe7225_o_tran_busy;
      AFE7225_SLEEP: afe7225_i_data_rdy <= !afe7225_o_tran_busy;
      default: afe7225_i_data_rdy <= 1'b0;
    endcase
  end
end




assign afe7225_config_end = (AFE7225_ADDR_CONFIG == afe7225_addr) && ( !afe7225_o_tran_busy);
assign afe7225_wakeup_end = 1'b1;
assign afe7225_sleep_end = 1'b1; 







wire [LEN_AFE7225_INSTR - 1 : 0] afe7225_data;
wire afe7225_data_rdy;
reg afe_mux;

always @(posedge clk or posedge rst)
begin
  if(rst) afe_mux <= 1'b0;
  else if(afe7225_config_end) afe_mux <= 1'b1;
end
assign afe7225_data = afe_mux ? i_afe7225_data: afe7225_i_data;
assign afe7225_data_rdy = afe_mux ? i_afe7225_data_rdy : afe7225_i_data_rdy;

spi_interface_mosi #(.DWIDTH(LEN_AFE7225_INSTR),
                     .CLOCK_EDGE(1'b1))
                   Uafe7225_spi_interface(.clk(clk),
                                           .rst(rst),
                                           .i_data(afe7225_data),
                                           .i_data_rdy(afe7225_data_rdy),
                                           .o_tran_busy(afe7225_o_tran_busy),
                                           .i_sclk(i_afe7225_sclk),
                                           .o_sclk(o_afe7225_spi_clk),
                                           .o_cs_n(o_afe7225_spi_le),
                                           .o_sdi(o_afe7225_spi_mosi));
                                     




assign o_afe7225_tran_busy = (AFE7225_IDLE != afe7225_state) || i_afe7225_config ||
                              i_afe7225_data_rdy || afe7225_o_tran_busy || (!afe_mux);
assign o_afe7225_pd = i_afe7225_pd;


lut_rom_afe7225_config Ulut_rom_afe7225_config(.i_addr(afe7225_addr),	
                                               .o_data(afe7225_i_data));











////////////////////////// process of cdce62002/////////
localparam CDCE62002_IDLE = 2'd0;
localparam CDCE62002_CONFIG = 2'd1;
localparam CDCE62002_WAKEUP = 2'd2;
localparam CDCE62002_SLEEP = 2'd3;
localparam BWIDTH_CDCE62002_ADDR = clogb2(CDCE62002_ADDR_MAX);

//
wire [LEN_CDCE62002_INSTR - 1 : 0] cdce62002_i_data;
reg cdce62002_i_data_rdy;
wire cdce62002_o_tran_busy;
//
reg [1 : 0] cdce62002_state;
reg [1 : 0] cdce62002_next_state;
wire cdce62002_config_end;
wire cdce62002_wakeup_end;
wire cdce62002_sleep_end;
//
reg [BWIDTH_CDCE62002_ADDR - 1 : 0] cdce62002_addr;



always @(posedge clk or posedge rst)
begin
  if(rst) cdce62002_state <= CDCE62002_IDLE;
  else cdce62002_state <= cdce62002_next_state;
end
always @(*)
begin
  if(rst) cdce62002_next_state = CDCE62002_IDLE;
  else
  begin
    case(cdce62002_state)
      CDCE62002_IDLE: 
      begin
        case({i_cdce62002_config, i_cdce62002_sleep, i_cdce62002_wakeup})
          3'b100: cdce62002_next_state = CDCE62002_CONFIG;
          3'b010: cdce62002_next_state = CDCE62002_SLEEP;
          3'b001: cdce62002_next_state = CDCE62002_WAKEUP;
          default: cdce62002_next_state = CDCE62002_IDLE;
        endcase
      end
      CDCE62002_CONFIG: cdce62002_next_state = cdce62002_config_end ? CDCE62002_IDLE : CDCE62002_CONFIG;
      CDCE62002_WAKEUP: cdce62002_next_state = cdce62002_wakeup_end ? CDCE62002_IDLE : CDCE62002_WAKEUP;
      CDCE62002_SLEEP: cdce62002_next_state = cdce62002_sleep_end ? CDCE62002_IDLE : CDCE62002_SLEEP; 
      default: cdce62002_next_state = CDCE62002_IDLE;
    endcase
  end
end

always @(posedge clk)
begin
  case(cdce62002_state)
    CDCE62002_IDLE: 
      begin
        case({i_cdce62002_config, i_cdce62002_sleep, i_cdce62002_wakeup})
          3'b100: cdce62002_addr <= 'd0;
          3'b010: cdce62002_addr <= CDCE62002_ADDR_PD;
          3'b001: cdce62002_addr <= CDCE62002_ADDR_WAKEUP;
          default: cdce62002_addr <= 'd0;
        endcase
      end
    default: cdce62002_addr <= cdce62002_i_data_rdy ? (cdce62002_addr + 'd1) : cdce62002_addr;
  endcase
end

always @(posedge clk or posedge rst)
begin
  if(rst) cdce62002_i_data_rdy <= 1'b0;
  else 
  begin
    case(cdce62002_state)
      CDCE62002_CONFIG: cdce62002_i_data_rdy <= !cdce62002_o_tran_busy;
      CDCE62002_WAKEUP: cdce62002_i_data_rdy <= !cdce62002_o_tran_busy;
      CDCE62002_SLEEP: cdce62002_i_data_rdy <= !cdce62002_o_tran_busy;
      default: cdce62002_i_data_rdy <= 1'b0;
    endcase
  end
end

assign cdce62002_config_end = (CDCE62002_ADDR_CONFIG == cdce62002_addr) && ( !cdce62002_o_tran_busy);
assign cdce62002_wakeup_end = 1'b1; // (CDCE62002_WAKEUP == cdce62002_state) && ( !cdce62002_o_tran_busy);
assign cdce62002_sleep_end = 1'b1; //(CDCE62002_SLEEP == cdce62002_state) && ( !cdce62002_o_tran_busy);








spi_interface_mosi #(.DWIDTH(LEN_CDCE62002_INSTR),
                     .CLOCK_EDGE(1'b1))
                   Ucdce62002_spi_interface(.clk(clk),
                                            .rst(rst),
                                            .i_data(cdce62002_i_data),
                                            .i_data_rdy(cdce62002_i_data_rdy),
                                            .o_tran_busy(cdce62002_o_tran_busy),
                                            .i_sclk(i_cdce62002_spi_clk),
                                            .o_sclk(o_cdce62002_spi_clk),
                                            .o_cs_n(o_cdce62002_spi_le),
                                            .o_sdi(o_cdce62002_spi_mosi));
assign o_cdce62002_pd_n = i_cdce62002_pd_n;
assign o_cdce62002_pll_lock = i_cdce62002_pll_lock;
assign o_cdce62002_tran_busy = (CDCE62002_IDLE != cdce62002_state) || i_cdce62002_config ||
                               i_cdce62002_sleep || i_cdce62002_wakeup || cdce62002_o_tran_busy;

lut_rom_cdce62002_config Ulut_rom_cdce62002_config(.i_addr(cdce62002_addr),
                                                   .o_data(cdce62002_i_data));
assign o_clk_sel = i_clk_sel;














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


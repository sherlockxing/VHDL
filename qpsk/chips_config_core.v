`timescale 1ns/1ps
module  chips_config_core(
                     clk,// 100MHz
                     rst_n,
                     // interface to afe7225 spi
                     o_afe7225_spi_clk,
                     o_afe7225_spi_mosi,
                     i_afe7225_spi_miso,
                     o_afe7225_spi_le,
                     o_afe7225_pd,
                     // inferface to cdce62002
                     o_cdce62002_spi_clk,
                     o_cdce62002_spi_mosi,
                     i_cdce62002_spi_miso,
                     o_cdce62002_spi_le,
                     o_cdce62002_pd_n,
                     i_cdce62002_pll_lock,
                     //
                     o_clk_sel,
							i_ADCA_clk,
							i_ADCB_clk,
							i_DACP_clk,
							led);
parameter LEN = 43;                    

input clk;// 100MHz
input rst_n;
// inferface to cdce62002
output o_cdce62002_spi_clk;
output o_cdce62002_spi_mosi;
input i_cdce62002_spi_miso;
output o_cdce62002_spi_le;
output o_cdce62002_pd_n;
input i_cdce62002_pll_lock;

output o_clk_sel;
// interface to afe7225
output o_afe7225_spi_clk;
output o_afe7225_spi_mosi;
input i_afe7225_spi_miso;
output o_afe7225_spi_le;
output o_afe7225_pd;
//
input i_ADCA_clk;
input i_ADCB_clk;
output [3:1]led;
input i_DACP_clk;




// signal decalaration
wire o_afe7225_config;
wire i_afe7225_tran_busy;
wire o_afe7225_sclk;
wire afe_o_ack;
wire i_config;
//
reg [7 : 0] config_cnt;
////////////////////////////////
wire cc_i_cdce62002_sclk;
wire cc_i_cdce62002_config;
wire cc_i_cdce62002_sleep;
wire cc_i_cdce62002_wakeup;
wire cc_o_cdce62002_tran_busy;
wire cc_o_cdce62002_pll_lock;
wire cc_i_clk_sel;
wire cc_i_cdce62002_pd_n;
wire cc_o_afe7225_tran_busy;
////////////////////////////
wire spu_o_cdce62002_sclk;
wire spu_i_cdce62002_pll_lock;
wire spu_i_cdce62002_tran_busy;
wire spu_o_cdce62002_config;
wire spu_o_cdce62002_sleep;
wire spu_o_cdce62002_wakeup;
wire spu_o_clk_sel;
wire spu_o_cdce62002_pd_n;
//


wire rst;
assign rst = ~rst_n;


// Instantiate the module
clkdivled u40MHz_clkdivled (
    .rst_n(rst_n), 
    .clk(i_ADCA_clk), 
    .led(led[1])
    );

// Instantiate the module
clkdivled uU40MHz_clkdivled (
    .rst_n(rst_n), 
    .clk(i_ADCB_clk), 
    .led(led[2])
    );

// Instantiate the module
clkdiv2le u120MHz_clkdiv2le (
    .rst_n(rst_n), 
    .clk(i_DACP_clk), 
    .led(led[3])
    );


reg [7 : 0] sclk_cnt;
initial sclk_cnt = 'd0;
always @(posedge clk)
begin
  sclk_cnt <= sclk_cnt + 'd1;
end

always @(posedge clk or posedge rst)
begin
  if(rst) config_cnt <= 'd0;
  else config_cnt <= (8'hff == config_cnt) ? 8'hff : (config_cnt + 8'd1);
end
assign i_config = (8'hfe == config_cnt);
///////////////////////////////////////////////////





reg [15 : 0] timer0;
initial timer0 = 'd0;
always @(posedge clk)
begin
  timer0 <= timer0 + 'd1;
end
assign clk_en = (16'hfff1 == timer0);
cdce62002_ctrl  Ucdce62002_ctrl(.clk(clk),
					                      .rst(rst),
                                .clk_en(clk_en),
					                      .i_config(i_config), 
					                      .i_wakeup(1'b0),
					                      .i_powerdown(1'b0),
					                      .o_ack(),
					                      .i_sclk(sclk_cnt[4]),
					                      .o_cdce62002_config(spu_o_cdce62002_config),
					                      .o_cdce62002_sleep(spu_o_cdce62002_sleep),
					                      .o_cdce62002_wakeup(spu_o_cdce62002_wakeup),
					                      .i_cdce62002_tran_busy(spu_i_cdce62002_tran_busy),
					                      .i_cdce62002_pll_lock(spu_i_cdce62002_pll_lock),
					                      .i_cdce62002_pd_n(1'b1),
					                      .o_cdce62002_pd_n(spu_o_cdce62002_pd_n),
					                      .o_cdce62002_sclk(spu_o_cdce62002_sclk));
assign spu_i_cdce62002_pll_lock =  cc_o_cdce62002_pll_lock;
assign spu_i_cdce62002_tran_busy= cc_o_cdce62002_tran_busy;



reg pll_lock_r;
always @(posedge clk or posedge rst)
begin
  if(rst) pll_lock_r <= 1'b0;
  else pll_lock_r <= spu_i_cdce62002_pll_lock;
end

chip_wr     #(.AFE7225_ADDR_MAX(LEN),
              .AFE7225_ADDR_CONFIG(LEN))
               u_chip_wr(.clk(clk),
			                   .rst(rst),
                         ////////////////////////////////////////
                         .i_afe7225_sclk(sclk_cnt[3]),
                         .i_afe7225_data('d0),
                         .i_afe7225_data_rdy(1'b0),
                         .i_afe7225_sleep(1'b0),
                         .i_afe7225_wakeup(1'b0),
                         .o_afe7225_tran_busy(o_tranciver_busy),
                         .i_afe7225_pd(1'b0),
                         .i_afe7225_config(spu_i_cdce62002_pll_lock && (!pll_lock_r)),
                         //
                         .o_afe7225_spi_clk(o_afe7225_spi_clk),
                         .o_afe7225_spi_mosi(o_afe7225_spi_mosi),
                         .i_afe7225_spi_miso(i_afe7225_spi_miso),
                         .o_afe7225_spi_le(o_afe7225_spi_le),
                         .o_afe7225_pd(o_afe7225_pd),
			 ////////////////////
			                   .i_cdce62002_spi_clk(sclk_cnt[3]),
                         .i_cdce62002_config(cc_i_cdce62002_config),
                         .i_cdce62002_sleep(cc_i_cdce62002_sleep),
                         .i_cdce62002_wakeup(cc_i_cdce62002_wakeup),
                         .o_cdce62002_tran_busy(cc_o_cdce62002_tran_busy),
                         .o_cdce62002_pll_lock(cc_o_cdce62002_pll_lock),  
                         .i_clk_sel(1'b1),
                         .i_cdce62002_pd_n(cc_i_cdce62002_pd_n),                         
			                   //
                         .o_clk_sel(o_clk_sel),
                         .o_cdce62002_spi_clk(o_cdce62002_spi_clk),
                         .o_cdce62002_spi_mosi(o_cdce62002_spi_mosi),
                         .i_cdce62002_spi_miso(i_cdce62002_spi_miso),
                         .o_cdce62002_spi_le(o_cdce62002_spi_le),
                         .i_cdce62002_pll_lock(i_cdce62002_pll_lock),
                         .o_cdce62002_pd_n(o_cdce62002_pd_n));

assign cc_i_cdce62002_config = spu_o_cdce62002_config;
assign cc_i_cdce62002_sleep = spu_o_cdce62002_sleep;
assign cc_i_cdce62002_wakeup = spu_o_cdce62002_wakeup;
assign cc_i_cdce62002_pd_n = spu_o_cdce62002_pd_n;
assign cc_i_clk_sel = spu_o_clk_sel;


endmodule



`ifdef  SIMULATION
`timescale 1ns/1ps
module tb_chips_config;

localparam CYC = 10;
reg clk;// 100MHz
reg rst;
// inferface to cdce62002
wire o_cdce62002_spi_clk;
wire o_cdce62002_spi_mosi;
wire i_cdce62002_spi_miso;
wire o_cdce62002_spi_le;
wire o_cdce62002_pd_n;
wire i_cdce62002_pll_lock;
wire o_clk_sel;
// interface to afe7225
wire o_afe7225_spi_clk;
wire o_afe7225_spi_mosi;
wire i_afe7225_spi_miso;
wire o_afe7225_spi_le;
wire o_tranciver_busy;
reg [31 : 0] i_tranciver_din;
reg i_tranciver_din_rdy;



initial clk = 1'b0;
always #(CYC/2)  clk = ~clk;
initial
begin
  rst = 1'b1;
  #(10 * CYC);
  rst = 1'b0;
end


initial
begin
  i_tranciver_din_rdy = 1'B0;
  #(100*CYC);

  while(o_tranciver_busy)
  begin
    #(10*CYC);
  end
 
  @(posedge clk);
  i_tranciver_din_rdy = 1'b1;
  i_tranciver_din = $random;
  @(posedge clk);
  i_tranciver_din_rdy = 1'b0;
 
  # 1;
  @(negedge o_tranciver_busy);
  #(10*CYC);
  @(posedge clk);
  i_tranciver_din_rdy = 1'b1;
  i_tranciver_din = $random;
  @(posedge clk);
  i_tranciver_din_rdy = 1'b0;
  #(1);

  @(negedge o_tranciver_busy);
  #(10*CYC);
  @(posedge clk);
  i_tranciver_din_rdy = 1'b1;
  i_tranciver_din = $random;
  @(posedge clk);
  i_tranciver_din_rdy = 1'b0;
  #(1);

  @(negedge o_tranciver_busy);
  #(10000*CYC);
 $stop;

end




chips_config uchips_config(.clk(clk),// 100MHz
                     .rst(rst),
                     .o_tranciver_busy(o_tranciver_busy),
                     .i_tranciver_din(i_tranciver_din),
                     .i_tranciver_din_rdy(i_tranciver_din_rdy),
                     // interface to afe7225 spi
                     .o_afe7225_spi_clk(o_afe7225_sp_i_clk),
                     .o_afe7225_spi_mosi(o_afe7225_sp_i_mosi),
                     .i_afe7225_spi_miso(i_afe7225_sp_i_miso),
                     .o_afe7225_spi_le(o_afe7225_sp_i_le),
                     .o_afe7225_pd(o_afe7225_pd),
                     // inferface to cdce62002
                     .o_cdce62002_spi_clk(o_cdce62002_sp_i_clk),
                     .o_cdce62002_spi_mosi(o_cdce62002_sp_i_mosi),
                     .i_cdce62002_spi_miso(i_cdce62002_sp_i_miso),
                     .o_cdce62002_spi_le(o_cdce62002_sp_i_le),
                     .o_cdce62002_pd_n(o_cdce62002_pd_n),
                     .i_cdce62002_pll_lock(i_cdce62002_pll_lock),
                     //
                     .o_clk_sel(o_clk_sel));



initial
begin
  $fsdbDumpfile("Utb_chip_config.fsdb");
  $fsdbDumpvars();
end
endmodule





`endif

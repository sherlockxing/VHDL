`timescale 1ns/1ps
module cdce62002_ctrl(clk,
                      rst,
                      clk_en,
                      i_config,
                      i_wakeup,
                      i_powerdown,
                      o_ack,
                      i_sclk,
                      o_cdce62002_config,
                      o_cdce62002_sleep,
                      o_cdce62002_wakeup,
                      i_cdce62002_tran_busy,
                      i_cdce62002_pll_lock,
                      i_cdce62002_pd_n,
                      o_cdce62002_pd_n,
                      o_cdce62002_sclk);
input clk;
input rst;
input clk_en;
input i_config;
input i_wakeup;
input i_powerdown;
output o_ack;
input i_sclk;
output o_cdce62002_config;
output o_cdce62002_sleep;
output o_cdce62002_wakeup;
input i_cdce62002_tran_busy;
input i_cdce62002_pll_lock;
input i_cdce62002_pd_n;
output o_cdce62002_pd_n;
output o_cdce62002_sclk;

localparam IDLE = 3'd0;
localparam PROGRAMMING = 3'd1;
localparam CHECK = 3'd2;
localparam POWERDOWN = 3'D4;
localparam POWERUP = 3'd5;
localparam BWIDTH_TIMER = 8;

reg [2 : 0] state;
reg [2 : 0] next_state;
reg [2 : 0] state_l1;

reg i_cdce62002_tran_busy_l1;
wire tran_busy_end;
//
reg [BWIDTH_TIMER - 1 : 0] timer;
wire timeup;



always @(posedge clk or posedge rst)
begin
  if(rst) state_l1 <= IDLE;
  else state_l1 <= state;
end

always @(posedge clk or posedge rst)
begin
  if(rst) state <= IDLE;
  else state <= next_state;
end

always @(*)
begin
  if(rst) next_state = IDLE;
  else
  begin
    case(state)
      IDLE: 
      begin
        case({i_config, i_powerdown, i_wakeup})
          3'b100: next_state = PROGRAMMING;
          3'b010: next_state = POWERDOWN;
          3'b001: next_state = POWERUP;
          default: next_state = IDLE;
        endcase
      end
      PROGRAMMING: next_state = tran_busy_end ? CHECK : PROGRAMMING;
      CHECK:
      begin
        case({i_cdce62002_pll_lock, timeup})
          2'b01: next_state = PROGRAMMING;
          2'b10: next_state = IDLE;
          2'b11: next_state = IDLE;
          default: next_state = CHECK;
        endcase
      end
      POWERDOWN: next_state = tran_busy_end ? IDLE : POWERDOWN;
      POWERUP: next_state = tran_busy_end ? IDLE : POWERUP;
    endcase
  end
end




always @(posedge clk or posedge rst)
begin
  if(rst) timer <= 'd0;
  else if(PROGRAMMING == state) timer <= ~('d0);
  else if(clk_en) timer <= ('d0 == timer) ? 'd0 : (timer - 'd1); 
end
assign timeup = (CHECK == state) && ('d0 == timer);




assign tran_busy_end = i_cdce62002_tran_busy_l1 && (!i_cdce62002_tran_busy);
always @(posedge clk or posedge rst)
begin
  if(rst) i_cdce62002_tran_busy_l1 <= 1'b0;
  else i_cdce62002_tran_busy_l1 <= i_cdce62002_tran_busy;
end

assign o_cdce62002_sclk = i_sclk;
assign o_cdce62002_pd_n = i_cdce62002_pd_n;
assign o_ack = (state_l1 != IDLE) && (state == IDLE); 
assign o_cdce62002_config = i_config;
assign o_cdce62002_sleep = i_powerdown;
assign o_cdce62002_wakeup = i_wakeup;


endmodule

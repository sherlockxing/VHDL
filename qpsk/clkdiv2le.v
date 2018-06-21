`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:52:43 08/19/2013 
// Design Name: 
// Module Name:    clkdiv2le 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module clkdiv2le( rst_n,
						clk,
						led);

input rst_n;
input clk;
output led;

reg clk_1Hz;
reg [26:0] counter;

parameter N=120000000;

//
always @(posedge clk)
begin
   if(!rst_n)
		begin
		counter <= 27'd0;
		clk_1Hz <= 1'b0;
		end
	else
		if(counter < N)
			begin
			counter <= counter + 1'b1;
			end
		else
			begin
			clk_1Hz <= ~clk_1Hz;
			counter <= 27'd0;
			end
end

assign led = clk_1Hz;




endmodule

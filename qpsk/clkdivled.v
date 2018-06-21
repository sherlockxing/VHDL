`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:25:10 08/19/2013 
// Design Name: 
// Module Name:    clkdivled 
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
module clkdivled( rst_n,
						clk,
						led);

input rst_n;
input clk;
output led;

reg clk_1Hz;
reg [25:0] counter;

parameter N=40000000;

//
always @(posedge clk)
begin
   if(!rst_n)
		begin
		counter <= 26'd0;
		clk_1Hz <= 1'b0;
		end
	else
		if(counter < (N/2-1))
			begin
			counter <= counter + 1'b1;
			end
		else
			begin
			clk_1Hz <= ~clk_1Hz;
			counter <= 26'd0;
			end
end

assign led = clk_1Hz;


endmodule

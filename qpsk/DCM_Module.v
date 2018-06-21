`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:39:28 02/20/2012 
// Design Name: 
// Module Name:    DCM_Module 
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
module DCM_module(		CLK_40M,		//输入时钟频率为40MHz
						rst_n,			//复位
						CLK_4div,		//生成10MHz时钟
						CLK_8div,		//生成5MHz时钟
						CLK_16div		//生成2.5MHz时钟

);

	input           	CLK_40M;
	input          		rst_n;
	output reg         CLK_4div = 0;
	output reg         CLK_8div = 0;
	output reg         CLK_16div = 0;

	reg [2:0]      Count1 = 3'D0;
	reg [3:0]      Count2 = 4'D0;
	reg [4:0]      Count3 = 5'D0;
/* *******************产生4倍分频************************8 */
	always@(posedge CLK_40M or negedge rst_n)begin
		if(~rst_n)begin
			Count1 = 0;
			CLK_4div <= 0;
		end
		else begin
			Count1 = Count1 + 1;
			if(Count1 == 3'D2)begin
				Count1 = 3'D0;
				CLK_4div <= ~CLK_4div;
			end
		end
	end
/* *******************产生8倍分频************************8 */
	always@(posedge CLK_40M or negedge rst_n)begin
		if(~rst_n)begin
			Count2 = 0;
			CLK_8div <= 0;
		end
		else begin
			Count2 = Count2 + 1;
			if(Count2 == 4'D4)begin
				Count2 = 4'D0;
				CLK_8div <= ~CLK_8div;
			end
		end
	end
/* *******************产生16倍分频************************8 */
	always@(posedge CLK_40M or negedge rst_n)begin
		if(~rst_n)begin
			Count3 = 0;
			CLK_16div <= 0;
		end
		else begin
			Count3 = Count3 + 1;
			if(Count3 == 5'D8)
				begin
				Count3 = 5'D0;
				CLK_16div <= ~CLK_16div;
			end
		end
	end

endmodule

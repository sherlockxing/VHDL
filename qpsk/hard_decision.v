`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:22:46 02/23/2012 
// Design Name: 
// Module Name:    hard_decision 
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
module hard_decision(		//input
							clk_fs,			//时钟频率为10MHz
							rst_n,			//复位
							filter_in_I,	//I支路传输信号
							filter_in_Q,	//Q支路传输信号
							//output
							bit_out_I,		//I支路判决结果
							bit_out_Q,		//Q支路判决结果
							temp_I,			//I支路判决采样
							temp_Q			//Q支路判决采样
);

	input              		clk_fs;
	input              		rst_n;
	input		[35:0]		filter_in_I,filter_in_Q;
	output reg [1:0]  		bit_out_I,bit_out_Q;

	output	reg 		[35:0]  	temp_I;			//I支路暂存判决时刻的信号值
	output	reg 		[35:0]  	temp_Q;			//Q支路暂存判决时刻的信号值
	reg 	[3:0]	count1;
	reg		[3:0]	count2;
	reg			[35:0]		filter_in_tempI,filter_in_tempQ;
	/* ************************抽样判决****************************** */
//I route decision
	always @(posedge clk_fs or negedge rst_n)begin
		if(~rst_n)begin
			temp_I = 0;
			filter_in_tempI = 0;
			count1 = 0;
		end
		else begin
			count1 = count1 + 1;
			filter_in_tempI = filter_in_I; 
			if(count1 == 3)begin
				temp_I = filter_in_tempI;
				if(temp_I[35]==1)
					bit_out_I <= 2'b11;
				else
					bit_out_I <= 2'b01;
			end
			if(count1 == 4)
				count1 = 0;
		end
	end

//Q route decision
	always @(posedge clk_fs or negedge rst_n)begin
		if(~rst_n)begin
			temp_Q = 0;
			filter_in_tempQ = 0;
			count2 = 0;
		end
		else begin
			count2 = count2 + 1;
			filter_in_tempQ = filter_in_Q; 
			if(count2 == 3)begin
				temp_Q = filter_in_tempQ;
				if(temp_Q[35]==1)
					bit_out_Q <= 2'b11;
				else
					bit_out_Q <= 2'b01;
			end
			if(count2 == 4)
				count2 = 0;
		end
	end

endmodule

 

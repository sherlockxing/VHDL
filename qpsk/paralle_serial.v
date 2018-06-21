`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:15:15 02/23/2012 
// Design Name: 
// Module Name:    paralle_serial 
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
module paralle_serial(		clk_fs,				//时钟频率为10MHz
							rst_n,
							bit_in_I,			//I支路判决输出结果
							bit_in_Q,			//Q支路判决输出结果
							//output
							bit_rev				//解映射结果输出
);

	input               	clk_fs;				//时钟频率为2.5MHz
	input               	rst_n;
	input		[1:0]   	bit_in_I,bit_in_Q;
	output	reg	[1:0]   	bit_rev;

	reg  		[1:0]  		count = 2'b0;
	reg			[3:0]		count_bit = 4'd0;
	/* **********************解映射************************* */
	always @(posedge clk_fs or negedge rst_n)begin
		if(~rst_n)begin
			count <= 0;
			count_bit = 0;
		end
		else begin
			count_bit = count_bit + 1;
			if(count_bit%2==0)begin
				count[0] <= count[0]^1;
				if(count%2==0)
					bit_rev <= bit_in_I;
				else
					bit_rev <= bit_in_Q;
			end
		end
	end
  
endmodule

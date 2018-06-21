`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:00:31 02/22/2012 
// Design Name: 
// Module Name:    insert_zero 
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
module insert_zero(			//input
							clk_fs,			//时钟频率10MHz
							rst_n,			//复位
							data_I_in,		//I支路星座映射信号			
							data_Q_in,		//Q支路星座映射信号
							//input
							data_I_out,		//I支路插零输出信号
							data_Q_out		//Q支路插零输出信号
);
	input        	clk_fs;
	input        	rst_n;
	input  [1:0] 	data_I_in,data_Q_in;
	output [1:0] 	data_I_out,data_Q_out;

	reg   [1:0] 	data_I_out,data_Q_out;
	reg   [1:0]  	temp1,temp2;
	reg   [3:0]  	count = 4'd0;
	reg	  [3:0]		count_bit;
/* ********************I、Q支路插零**************************** */ 
	always @(posedge clk_fs or negedge rst_n)begin
		if(~rst_n)begin
			temp1 <= 0;
			temp2 <= 0;
			count_bit = 0;
		end
		else begin	
			count_bit = count_bit +1;
			if(count_bit%4 == 0)begin
				temp1 <= data_I_in;
				temp2 <= data_Q_in;
			end
		end
	end

	always @(posedge clk_fs or negedge rst_n)begin
		if(~rst_n)begin
			count = 0;
			data_I_out <= 0;
			data_Q_out <= 0;
		end
		else begin
			count = count+1;
			if(count==4'd4)
				 count = 0;
			else if(count%4==1)begin 
				data_I_out <= temp1;
				data_Q_out <= temp2;
			end
			else begin
				data_I_out <= 0;
				data_Q_out <= 0;
			end
		end 
	end

endmodule

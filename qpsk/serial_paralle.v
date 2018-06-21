`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:55:44 02/21/2012 
// Design Name: 
// Module Name:    serial_paralle 
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
module serial_paralle(		//input
							clk_fs,			//时钟频率10MHz
							rst_n,			//复位
							data_in,		//带13位巴克码的m序列
							//output
							data_out_I,		//I支路星座映射输出信号
							data_out_Q		//Q支路星座映射输出信号
);  
	input       	clk_fs;
	input       	rst_n;
	input 	[1:0] 	data_in;  
	output      	data_out_I,data_out_Q;

	reg  	[1:0] 	a,b;
	reg		[2:0]	count_bit1	= 3'd0;
	reg		[2:0]	count_bit2	= 3'd0;
	reg  	[1:0]  	count 		= 2'd0;
	reg  	[1:0]  	count1 		= 2'd0 ;
	reg  	[1:0]  	data_out_I 	= 2'b0;
	reg  	[1:0]  	data_out_Q 	= 2'b0;
/* ******************星座映射************************** */
	//I、Q支路暂存信号
	always@(posedge clk_fs or negedge rst_n)begin 
		if(~rst_n)begin
			count = 2'd0;
			count_bit1 = 3'd0;
		end
		else begin
			count_bit1 = count_bit1 + 1;
			if(count_bit1%2==0)begin
				count[0] = count[0]^1;
				if (count%2)begin
					a <= data_in;
				end
				else begin
					b <= data_in;
				end
			end
		end
	end
	//I、Q支路星座映射
	always@(negedge clk_fs or negedge rst_n)begin 
		if(~rst_n)begin
			count1 = 2'd0;
			count_bit2 = 3'd0;
			data_out_I <= 0;
			data_out_Q <= 0;
		end
		else begin
			count_bit2 = count_bit2 + 1;
			if(count_bit2%2 == 0)begin
				count1[0] = count1[0]^1;
				if(count1%2==0)begin
					data_out_I <= a;
					data_out_Q <= b;
				end	
			end
		end 
	end
	  
endmodule     
       
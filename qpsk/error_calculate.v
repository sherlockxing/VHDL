`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:40:31 02/23/2012 
// Design Name: 
// Module Name:    error_calculate 
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
module error_calculate(		//intput
							clk_fs,					//时钟频率为10MHz
							enable,					//当检测巴克码序列正确时，enable置为1
							count,					//count从0到1026,包含巴克码序列的m序列长度为1027
							bit_rev_delay,			//接收同步信号
							//output
							m_seq,					//接收端m序列对比信号
							count_frame,			//帧数计数
							error_cnt,				//20位宽，错误统计
							error_cnt_display		//20位宽，错误显示
);	  

	input               	clk_fs;				//时钟频率为10MHz
	input      [1:0]   	enable;
	input      [1:0]   	bit_rev_delay;
	input      [11:0]  	count; 

	output reg [19:0]  	error_cnt = 0;
	output reg [19:0]  	error_cnt_display = 0;
	output reg [1:0]   	m_seq;
	output reg [10:0]  	count_frame = 0;
	  
	reg      	[9:0]   	flow = 10'b0000000001;
	reg              		temp_m;

	reg      	[5:0]   	count2 = 0;
	reg			[3:0]		count_bit1 = 4'd0;
	reg			[3:0]		count_bit2 = 4'd0;

// generate m_sequence
	always @ (posedge clk_fs)begin
		count_bit1 = count_bit1 + 1;
		if(count_bit1%2==0)begin
			if (enable==1)begin
				if (count>=1&&count<=16'd1023)begin
					temp_m = flow[0];
					flow[8:0] <=  flow[9:1];
					flow[9] <= flow[7] ^ flow[0];
				end
			end		 
			else
				flow <= 10'b0000000001;
		end
	end
	
	always @ (temp_m)begin 
		if(temp_m==0)
			m_seq <= 2'b01;
		else
			m_seq <= 2'b11;
	end
  
// calculate the number of error bits,99 frames to display 
	always@(posedge clk_fs)begin
		count_bit2 = count_bit2 + 1;
		if(count_bit2%2==0)begin
			if(enable==1)begin
				if(count==0)
					error_cnt <= error_cnt;
				else if(count==1)
					error_cnt <= error_cnt;
				else if(count<=12'd1024&&count>=2)begin
					if (bit_rev_delay != m_seq )
					   error_cnt <= error_cnt+1;
				end
				else
					count_frame <= count_frame+1;
			end
			else if(count_frame==999)begin
				error_cnt_display <= error_cnt;
				count_frame <= 0;
				error_cnt <= 0;
			end
		end
	end
	
endmodule

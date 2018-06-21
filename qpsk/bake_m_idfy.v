`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:01:37 02/23/2012 
// Design Name: 
// Module Name:    bake_m_idfy 
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
module bake_m_idfy(		//input
						clk_fs,			//时钟频率为10MHz
						rst_n,			//复位
						bit_rev,		//解映射信号
						//output
						bit_delay,		//接收同步信号
						sum,			//用于检测巴克码序列是否正确，正确时sum = 13
						enable,			//当检测巴克码序列正确时，enable置为1
						count			//count从0到1026,包含巴克码序列的m序列长度为1027
    );

	input             	clk_fs;			//时钟频率为10MHz
	input             	rst_n;
	input   [1:0]     	bit_rev;
	output reg [1:0]  enable = 0;
	output reg [1:0]  bit_delay;
	output reg [4:0]  sum = 0;
	output reg [11:0] count = 0;
	
	reg	[3:0]	count_bit1 = 4'd0;
	reg	[3:0]	count_bit2 = 4'd0;
	reg [1:0]   mema [12:0];
	reg [1:0]   cnt12 = 0;
	reg [1:0]	cnt11 = 0;
	reg [1:0]	cnt10 = 0;
	reg [1:0]	cnt9  = 0;
	reg [1:0]	cnt8  = 0;
	reg [1:0]	cnt7  = 0;
	reg [1:0]	cnt6  = 0;
	reg [1:0]	cnt5  = 0;
	reg [1:0]	cnt4  = 0;
	reg [1:0]	cnt3  = 0;
	reg [1:0]	cnt2  = 0;
	reg [1:0]	cnt1  = 0;
	reg [1:0]	cnt0  = 0;

	always@(posedge clk_fs or negedge rst_n)begin
		if(~rst_n)begin
			mema[12] <= 0;
			mema[11] <= 0;
			mema[10] <= 0;
			mema[9] <= 0;
			mema[8] <= 0;
			mema[7] <= 0;
			mema[6] <= 0;
			mema[5] <= 0;
			mema[4] <= 0;
			mema[3] <= 0;
			mema[2] <= 0;
			mema[1] <= 0;
			mema[0] <= 0;
			count_bit1 = 0;
		end
		else begin
			count_bit1 = count_bit1 + 1;
			if(count_bit1%2==0)begin
				mema[12] <= mema[11];
				mema[11] <= mema[10];
				mema[10] <= mema[9];
				mema[9] <= mema[8];
				mema[8] <= mema[7];
				mema[7] <= mema[6];
				mema[6] <= mema[5];
				mema[5] <= mema[4];
				mema[4] <= mema[3];
				mema[3] <= mema[2];
				mema[2] <= mema[1];
				mema[1] <= mema[0];
				mema[0] <= bit_rev;
				bit_delay <= mema[2];
			end
		end
	end
			 
	//compare
	always @ (posedge clk_fs or negedge rst_n)begin
		if(~rst_n)begin
			cnt12 <= 0;
			cnt11 <= 0;
			cnt10 <= 0;
			cnt9 <= 0;
			cnt8 <= 0;
			cnt7 <= 0;
			cnt6 <= 0;
			cnt5 <= 0;
			cnt4 <= 0;
			cnt3 <= 0;
			cnt2 <= 0;
			cnt1 <= 0;
			cnt0 <= 0;
			count_bit2 = 0;
		end
		else begin   
			count_bit2 = count_bit2 + 1;
			if(count_bit2%2==0)begin
				cnt12 <= mema[12][1];//(mema[12][1]==1) ? 1:0;
				cnt11 <= mema[11][1];//(mema[11][1]==1) ? 1:0;
				cnt10 <= mema[10][1];//(mema[10][1]==1) ? 1:0;
				cnt9 <= mema[9][1];//(mema[9][1]==1) ? 1:0;
				cnt8 <= mema[8][1];//(mema[8][1]==1) ? 1:0;
				cnt7 <= ~mema[7][1];//(mema[7][1]==0)? 1:0;
				cnt6 <= ~mema[6][1];//(mema[6][1]==0) ? 1:0;
				cnt5 <= mema[5][1];//(mema[5][1]==1) ? 1:0;
				cnt4 <= mema[4][1];//(mema[4][1]==1) ? 1:0;
				cnt3 <= ~mema[3][1];//(mema[3][1]==0) ? 1:0;
				cnt2 <= mema[2][1];//(mema[2][1]==1) ? 1:0;
				cnt1 <= ~mema[1][1];//(mema[1][1]==0) ? 1:0;
				cnt0 <= mema[0][1];//(mema[0][1]==1) ? 1:0;
				sum <= cnt12[0]+cnt11[0]+cnt10[0]+cnt9[0]+cnt8[0]+cnt7[0]+cnt6[0]+cnt5[0]+cnt4[0]+cnt3[0]+cnt2[0]+cnt1[0]+cnt0[0]; 
				if (sum == 13)		//检测巴克码序列是否正确
					enable = 1;
				if (enable == 1)begin
					count = count+1;
					if (count == 12'd1026)begin
						enable = 0;
						count = 0;
					end
				end
			end
	    end
	end
	
endmodule

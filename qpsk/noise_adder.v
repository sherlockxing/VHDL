`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:37:36 02/23/2012 
// Design Name: 
// Module Name:    noise_adder 
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
module noise_adder(		//input
						clk_fs,			//时钟频率为10MHz
						SW,
						rst_n,			//复位
						I_filter,		//I支路成型滤波信号
						Q_filter,		//Q支路成型滤波信号
						I_noise,		//I支路噪声
						Q_noise,		//Q支路噪声
						//output
						I_noise_cut,	//I支路截断噪声
						Q_noise_cut,	//Q支路截断噪声
						I_rev,			//I支路添加噪声后输出信号
						Q_rev			//Q支路添加噪声后输出信号
);

	input                    	clk_fs;
	input                     	rst_n;
	input             	[3:0]   SW;
	input      signed [17:0]  I_filter;
	input      signed [17:0]  Q_filter;
	input      signed [19:0]  I_noise;
	input      signed [19:0]  Q_noise;

	output reg signed [18:0]  I_rev;
	output reg signed [18:0]  Q_rev;
	output reg signed [17:0]  I_noise_cut;
	output reg signed [17:0]  Q_noise_cut;

	wire  signed [17:0]  	I_noise_cut1,I_noise_cut2,I_noise_cut3,I_noise_cut4,
							I_noise_cut5,I_noise_cut6,I_noise_cut7,I_noise_cut8;
							
	wire  signed [17:0]  	Q_noise_cut1,Q_noise_cut2,Q_noise_cut3,Q_noise_cut4,
							Q_noise_cut5,Q_noise_cut6,Q_noise_cut7,Q_noise_cut8;
							
/* ******************截断噪声************************** */	
/* SNR = 6.02dB */
	assign      I_noise_cut1[17:0] = I_noise[19:2];	
	assign		Q_noise_cut1[17:0] = Q_noise[19:2];
	
/* SNR = 12.04dB */
	assign      I_noise_cut2[17:16] = {2{I_noise[19]}};
	assign		I_noise_cut2[15:0] = I_noise[18:3];	
	assign      Q_noise_cut2[17:16] = {2{Q_noise[19]}};
	assign		Q_noise_cut2[15:0] = Q_noise[17:2];			

/* SNR = 18.06dB */
	assign      I_noise_cut3[17:15] = {3{I_noise[19]}};
	assign      I_noise_cut3[14:0] = I_noise[18:4];
	assign      Q_noise_cut3[17:15] = {3{Q_noise[19]}};
	assign      Q_noise_cut3[14:0] = Q_noise[18:4];

/* SNR = 24.08dB */
	assign      I_noise_cut4[17:14] = {4{I_noise[19]}};
	assign		I_noise_cut4[13:0] = I_noise[18:5];
	assign      Q_noise_cut4[17:14] = {4{Q_noise[19]}};
	assign		Q_noise_cut4[13:0] = Q_noise[18:5];
		
/* SNR = 30.10dB */
	assign      I_noise_cut5[17:13] = {5{I_noise[19]}};
	assign		I_noise_cut5[12:0] = I_noise[18:6];
	assign      Q_noise_cut5[17:13] = {5{Q_noise[19]}};
	assign		Q_noise_cut5[12:0] = Q_noise[18:6];

/* SNR = 36.12dB */
	assign      I_noise_cut6[17:12] = {6{I_noise[19]}};
	assign      I_noise_cut6[11:0] = I_noise[18:7];
	assign      Q_noise_cut6[17:12] = {6{Q_noise[19]}};
	assign      Q_noise_cut6[11:0] = Q_noise[18:7];

/* SNR = 42.14dB */
	assign      I_noise_cut7[17:11] = {7{I_noise[19]}};
	assign      I_noise_cut7[10:0] = I_noise[18:8];
	assign      Q_noise_cut7[17:11] = {7{Q_noise[19]}};
	assign      Q_noise_cut7[10:0] = Q_noise[18:8];

/* SNR = 48.16dB */
	assign      I_noise_cut8[17:10] = {8{I_noise[19]}};
	assign		I_noise_cut8[9:0] = I_noise[18:9];
	assign      Q_noise_cut8[17:10] = {8{Q_noise[19]}};
	assign		Q_noise_cut8[9:0] = Q_noise[18:9];

	/* *********************添加噪声************************ */
	always@(posedge clk_fs or negedge rst_n)begin
		if(~rst_n)begin
			I_rev <= 0;
			Q_rev <= 0;
		end
		else begin
			case(SW)
				4'b0000: //  SNR =1.69dB
				  begin
					I_noise_cut <= I_noise_cut1+I_noise_cut2+I_noise_cut4;
					Q_noise_cut <= Q_noise_cut1+Q_noise_cut2+Q_noise_cut4;
					I_rev <= I_filter+I_noise_cut;
					Q_rev <= Q_filter+Q_noise_cut; 
				  end
				4'b0001: //  SNR = 2.48dB
				  begin
					I_noise_cut <= I_noise_cut1+I_noise_cut3+I_noise_cut5;
					Q_noise_cut <= Q_noise_cut1+Q_noise_cut3+Q_noise_cut5;
					I_rev <= I_filter+I_noise_cut;
					Q_rev <= Q_filter+Q_noise_cut; 
				  end	
				4'b0010: //  SNR = 3.30dB
				  begin
					I_noise_cut <= I_noise_cut1+I_noise_cut7+I_noise_cut8;
					Q_noise_cut <= Q_noise_cut1+Q_noise_cut7+Q_noise_cut8;
					I_rev <= I_filter+I_noise_cut;
					Q_rev <= Q_filter+Q_noise_cut; 
				  end
				4'b0011: //  SNR = 4.42dB
				  begin
					I_noise_cut <= I_noise_cut2+I_noise_cut5+I_noise_cut7;
					Q_noise_cut <= Q_noise_cut2+Q_noise_cut5+Q_noise_cut7;
					I_rev <= I_filter+I_noise_cut;
					Q_rev <= Q_filter+Q_noise_cut; 
				  end
				4'b0100: //  SNR = 5.84dB
				  begin
					I_noise_cut <= I_noise_cut3+I_noise_cut3+I_noise_cut4;
					Q_noise_cut <= Q_noise_cut3+Q_noise_cut3+Q_noise_cut4;
					I_rev <= I_filter+I_noise_cut;
					Q_rev <= Q_filter+Q_noise_cut; 
				  end	
				4'b0101: //  SNR = 6.56dB
				  begin
					I_noise_cut <= I_noise_cut3+I_noise_cut3+I_noise_cut5;
					Q_noise_cut <= Q_noise_cut3+Q_noise_cut3+Q_noise_cut5;
					I_rev <= I_filter+I_noise_cut;
					Q_rev <= Q_filter+Q_noise_cut; 
				  end
				4'b0110: //  SNR = 7.43dB
				  begin
					I_noise_cut <= I_noise_cut3+I_noise_cut4+I_noise_cut4;
					Q_noise_cut <= Q_noise_cut3+Q_noise_cut4+Q_noise_cut4;
					I_rev <= I_filter+I_noise_cut;
					Q_rev <= Q_filter+Q_noise_cut; 
				  end
				4'b0111: //  SNR = 8.50dB
				  begin
					I_noise_cut <= I_noise_cut3+I_noise_cut4+I_noise_cut5;
					Q_noise_cut <= Q_noise_cut3+Q_noise_cut4+Q_noise_cut5;
					I_rev <= I_filter+I_noise_cut;
					Q_rev <= Q_filter+Q_noise_cut; 
				  end
				4'b1000: //  SNR = 9.62dB
				  begin
					I_noise_cut <= I_noise_cut3+I_noise_cut4+I_noise_cut8;
					Q_noise_cut <= Q_noise_cut3+Q_noise_cut4+Q_noise_cut8;
					I_rev <= I_filter+I_noise_cut;
					Q_rev <= Q_filter+Q_noise_cut; 
				  end
				4'b1001: //  SNR = 10.54dB
				  begin
					I_noise_cut <= I_noise_cut3+I_noise_cut5+I_noise_cut6;
					Q_noise_cut <= Q_noise_cut3+Q_noise_cut5+Q_noise_cut6;
					I_rev <= I_filter+I_noise_cut;
					Q_rev <= Q_filter+Q_noise_cut; 
				  end
				
				
				4'b1010: //  SNR = 11.80dB
				  begin
					I_noise_cut <= I_noise_cut3+I_noise_cut6+I_noise_cut7;
					Q_noise_cut <= Q_noise_cut3+Q_noise_cut6+Q_noise_cut7;
					I_rev <= I_filter+I_noise_cut;
					Q_rev <= Q_filter+Q_noise_cut; 
				  end	
				4'b1011: //  SNR = 12.51dB
				  begin
					I_noise_cut <= I_noise_cut3+I_noise_cut7+I_noise_cut8;
					Q_noise_cut <= Q_noise_cut3+Q_noise_cut7+Q_noise_cut8;
					I_rev <= I_filter+I_noise_cut;
					Q_rev <= Q_filter+Q_noise_cut; 
				  end
				4'b1100: //  SNR = 13.29dB
				  begin
					I_noise_cut <= I_noise_cut4+I_noise_cut5+I_noise_cut5;
					Q_noise_cut <= Q_noise_cut4+Q_noise_cut5+Q_noise_cut5;
					I_rev <= I_filter+I_noise_cut;
					Q_rev <= Q_filter+Q_noise_cut; 
				  end
				4'b1101: //  SNR = 14.44dB
				  begin
					I_noise_cut <= I_noise_cut4+I_noise_cut5+I_noise_cut6;
					Q_noise_cut <= Q_noise_cut4+Q_noise_cut5+Q_noise_cut6;
					I_rev <= I_filter+I_noise_cut;
					Q_rev <= Q_filter+Q_noise_cut; 
				  end
				4'b1110: //  SNR = 15.43dB
				  begin
					I_noise_cut <= I_noise_cut4+I_noise_cut5+I_noise_cut8;
					Q_noise_cut <= Q_noise_cut4+Q_noise_cut5+Q_noise_cut8;
					I_rev <= I_filter+I_noise_cut;
					Q_rev <= Q_filter+Q_noise_cut; 
				  end
				4'b1111: //  SNR = 16.94dB
				  begin
					I_noise_cut <= I_noise_cut8;//I_noise_cut4+I_noise_cut6+
					Q_noise_cut <= Q_noise_cut8;//Q_noise_cut4+Q_noise_cut6+
					I_rev <= I_filter+I_noise_cut;
					Q_rev <= Q_filter+Q_noise_cut; 
				  end
			endcase
		end
	end
	
endmodule

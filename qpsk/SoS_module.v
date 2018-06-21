`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:56:55 03/04/2012 
// Design Name: 
// Module Name:    AWGN_module 
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
module SoS_module(		//input
						clk_fs,			//时钟频率为10MHz
						rst_n,			//复位
						omega_n_add,	//角频率
						//output
						gauss_I,		//I支路噪声
						gauss_Q			//Q支路噪声
);

	input 				clk_fs;			//时钟频率为10MHz
	input 				rst_n;
	input 	[13:0] 		omega_n_add;
	output	[19:0] 		gauss_I,gauss_Q;
	//I、Q支路16个频率点正弦信号
	wire 	[15:0] 		data_I1,data_I2,data_I3,data_I4,data_I5,data_I6,data_I7,data_I8,data_I9,data_I10,data_I11,data_I12,data_I13,data_I14,data_I15,data_I16;
	wire 	[15:0] 		data_Q1,data_Q2,data_Q3,data_Q4,data_Q5,data_Q6,data_Q7,data_Q8,data_Q9,data_Q10,data_Q11,data_Q12,data_Q13,data_Q14,data_Q15,data_Q16;
	
	reg  	[19:0] 		tmp_I,tmp_Q;


cos_module cos_u1 (
					.clk_fs(clk_fs), 			//时钟频率为1.25MHz
					.rst_n(rst_n),
					.omega_n_I(14'h333+omega_n_add), 
					.omega_n_Q(14'h00+omega_n_add), 
					.phi_n_I(0), 
					.phi_n_Q(0), 
					.data_I(data_I1), 
					.data_Q(data_Q1)
    );
	 
cos_module cos_u2 (
					.clk_fs(clk_fs), 			//时钟频率为1.25MHz
					.rst_n(rst_n),
					.omega_n_I(14'h2EC+omega_n_add), 
					.omega_n_Q(14'h14B+omega_n_add), 
					.phi_n_I(0), 
					.phi_n_Q(0), 
					.data_I(data_I2), 
					.data_Q(data_Q2)
    );
	 
cos_module cos_u3 (
					.clk_fs(clk_fs), 
					.rst_n(rst_n),
					.omega_n_I(14'h226+omega_n_add), 
					.omega_n_Q(14'h25E+omega_n_add), 
					.phi_n_I(0), 
					.phi_n_Q(0), 
					.data_I(data_I3), 
					.data_Q(data_Q3)
    );
	 
cos_module cos_u4 (
					.clk_fs(clk_fs), 
					.rst_n(rst_n),
					.omega_n_I(14'h101+omega_n_add), 
					.omega_n_Q(14'h309+omega_n_add), 
					.phi_n_I(0), 
					.phi_n_Q(0), 
					.data_I(data_I4), 
					.data_Q(data_Q4)
    );
	 
cos_module cos_u5 (
					.clk_fs(clk_fs), 
					.rst_n(rst_n),
					.omega_n_I(14'h3FAF+omega_n_add), 
					.omega_n_Q(14'h32F+omega_n_add), 
					.phi_n_I(0), 
					.phi_n_Q(0), 
					.data_I(data_I5), 
					.data_Q(data_Q5)
    );
	 
cos_module cos_u6 (
					.clk_fs(clk_fs), 
					.rst_n(rst_n),
					.omega_n_I(14'h3E6C+omega_n_add), 
					.omega_n_Q(14'h2C8+omega_n_add), 
					.phi_n_I(0), 
					.phi_n_Q(0), 
					.data_I(data_I6), 
					.data_Q(data_Q6)
    );
	 
cos_module cos_u7 (
					.clk_fs(clk_fs), 
					.rst_n(rst_n),
					.omega_n_I(14'h3D6E+omega_n_add), 
					.omega_n_Q(14'h1E8+omega_n_add), 
					.phi_n_I(0), 
					.phi_n_Q(0), 
					.data_I(data_I7), 
					.data_Q(data_Q7)
    );
	 
cos_module cos_u8 (
					.clk_fs(clk_fs), 
					.rst_n(rst_n),
					.omega_n_I(14'h3CE0+omega_n_add), 
					.omega_n_Q(14'hB3+omega_n_add), 
					.phi_n_I(0), 
					.phi_n_Q(0), 
					.data_I(data_I8), 
					.data_Q(data_Q8)
    );
	 
cos_module cos_u9 (
					.clk_fs(clk_fs), 
					.rst_n(rst_n),
					.omega_n_I(14'h3CDC+omega_n_add), 
					.omega_n_Q(14'h3F60+omega_n_add), 
					.phi_n_I(0), 
					.phi_n_Q(0), 
					.data_I(data_I9), 
					.data_Q(data_Q9)
    );
	 
cos_module cos_u10 (
					.clk_fs(clk_fs), 
					.rst_n(rst_n),
					.omega_n_I(14'h3D62+omega_n_add), 
					.omega_n_Q(14'h3E28+omega_n_add), 
					.phi_n_I(0), 
					.phi_n_Q(0), 
					.data_I(data_I10), 
					.data_Q(data_Q10)
    );
	 
cos_module cos_u11 (
					.clk_fs(clk_fs), 
					.rst_n(rst_n),
					.omega_n_I(14'h3E5A+omega_n_add), 
					.omega_n_Q(14'h3D41+omega_n_add), 
					.phi_n_I(0), 
					.phi_n_Q(0), 
					.data_I(data_I11), 
					.data_Q(data_Q11)
    );
	 
cos_module cos_u12 (
					.clk_fs(clk_fs), 
					.rst_n(rst_n),
					.omega_n_I(14'h3F9B+omega_n_add), 
					.omega_n_Q(14'h3CD2+omega_n_add), 
					.phi_n_I(0), 
					.phi_n_Q(0), 
					.data_I(data_I12), 
					.data_Q(data_Q12)
    );
	 
cos_module cos_u13 (
					.clk_fs(clk_fs), 
					.rst_n(rst_n),
					.omega_n_I(14'hED+omega_n_add), 
					.omega_n_Q(14'h3CEF+omega_n_add), 
					.phi_n_I(0), 
					.phi_n_Q(0), 
					.data_I(data_I13), 
					.data_Q(data_Q13)
    );
	 
cos_module cos_u14 (
					.clk_fs(clk_fs), 
					.rst_n(rst_n),
					.omega_n_I(14'h216+omega_n_add), 
					.omega_n_Q(14'h3D93+omega_n_add), 
					.phi_n_I(0), 
					.phi_n_Q(0), 
					.data_I(data_I14), 
					.data_Q(data_Q14)
    );
	 
cos_module cos_u15 (
					.clk_fs(clk_fs), 
					.rst_n(rst_n),
					.omega_n_I(14'h2E4+omega_n_add), 
					.omega_n_Q(14'h3EA1+omega_n_add), 
					.phi_n_I(0), 
					.phi_n_Q(0), 
					.data_I(data_I15), 
					.data_Q(data_Q15)
    );
	 
cos_module cos_u16 (
					.clk_fs(clk_fs), 
					.rst_n(rst_n),
					.omega_n_I(14'h332+omega_n_add), 
					.omega_n_Q(14'h3FEB+omega_n_add), 
					.phi_n_I(0), 
					.phi_n_Q(0), 
					.data_I(data_I16), 
					.data_Q(data_Q16)
    );
	 assign gauss_I = tmp_I;
	 assign gauss_Q = tmp_Q;
	always@(posedge clk_fs)begin	 
		tmp_I <= {{4{data_I1[15]}},data_I1}+{{4{data_I2[15]}},data_I2}+{{4{data_I3[15]}},data_I3}+{{4{data_I4[15]}},data_I4}
				  +{{4{data_I5[15]}},data_I5}+{{4{data_I6[15]}},data_I6}+{{4{data_I7[15]}},data_I7}+{{4{data_I8[15]}},data_I8}
					 +{{4{data_I9[15]}},data_I9}+{{4{data_I10[15]}},data_I10}+{{4{data_I11[15]}},data_I11}+{{4{data_I12[15]}},data_I12}
					 +{{4{data_I13[15]}},data_I13}+{{4{data_I14[15]}},data_I14}+{{4{data_I15[15]}},data_I15}+{{4{data_I16[15]}},data_I16};
					 
		tmp_Q <= {{4{data_Q1[15]}},data_Q1}+{{4{data_Q2[15]}},data_Q2}+{{4{data_Q3[15]}},data_Q3}+{{4{data_Q4[15]}},data_Q4}
				  +{{4{data_Q5[15]}},data_Q5}+{{4{data_Q6[15]}},data_Q6}+{{4{data_Q7[15]}},data_Q7}+{{4{data_Q8[15]}},data_Q8}
					 +{{4{data_Q9[15]}},data_Q9}+{{4{data_Q10[15]}},data_Q10}+{{4{data_Q11[15]}},data_Q11}+{{4{data_Q12[15]}},data_Q12}
					 +{{4{data_Q13[15]}},data_Q13}+{{4{data_Q14[15]}},data_Q14}+{{4{data_Q15[15]}},data_Q15}+{{4{data_Q16[15]}},data_Q16};
	end
			  
endmodule
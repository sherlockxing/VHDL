`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:20:57 02/23/2012 
// Design Name: 
// Module Name:    TOP_QPSK 
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
module TOP_QPSK(	
					CLK_40M,		//系统输入时钟频率为40MHz
					rst_n,			//复位
					SW2,			//选择开关
					DATA_OUT,
									//DA
					out_da0_wr,		//A端口DA输出时钟
					out_da1_wr,		//B端口DA输出时钟
					out_da0_data,	//A端口DA输出信号
					out_da1_data,	//B端口DA输出信号
					//LCD
					DCLK,
					HS,
					UD,
					LR,
					VS,
					DE,
					LCDR,
					LCDG,
					LCDB,
					out_lcdpwr_on,
				//interface to cdce62002
                  o_cdce62002_spi_clk,
                  o_cdce62002_spi_mosi,
                  i_cdce62002_spi_miso,
                  o_cdce62002_spi_le,
                  o_cdce62002_pd_n,
                  i_cdce62002_pll_lock,
                  o_clk_sel,
		 	         i_ADCA_clk,
					   i_ADCB_clk,
						i_DACP_clk,
						led
);
	
	input                 	CLK_40M;
	input                 	rst_n;
	input       	[3:0]   SW2;
	output wire		[15:0] 	DATA_OUT;
	/* ************************LCD********************************** */
	output DCLK;
	output HS;
	output VS;
	output DE;
	output UD;
	output LR;
	output [7:0] LCDR;
	output [7:0] LCDG;
	output [7:0] LCDB;
	output	out_lcdpwr_on;
	/* ************************************************************* */
	// inferface to cdce62002
	output o_cdce62002_spi_clk;
	output o_cdce62002_spi_mosi;
	input i_cdce62002_spi_miso;
	output o_cdce62002_spi_le;
	output o_cdce62002_pd_n;
	input i_cdce62002_pll_lock;

	output o_clk_sel;

	input i_ADCA_clk;
	input i_ADCB_clk;
	output [3:1]led;
	input i_DACP_clk;
	/* ************************************************************** */
	output			out_da0_wr;
	output			out_da1_wr;
	output	[11:0]	out_da0_data;
	output	[11:0]	out_da1_data;
	/* ************************************************************** */
	wire                  	rate_bit,fs_bit_div,fs_bit;		//分频输出时钟频率为2.5MHz,5MHz,10MHz
	wire     [1:0]        	bit_tran;						//带13位巴克码的m序列
	wire     [1:0]        	bake;							//13位巴克码
	wire     [1:0]        	I_bit,Q_bit;					//I、Q支路星座映射信号
	wire     [1:0]        	I_interp,Q_interp;				//I、Q支路插零信号
	wire     [17:0]       	I_filter,Q_filter;				//I、Q支路成型滤波信号
	wire     [19:0]       	I_noise,Q_noise;				//I、Q支路噪声
	wire     [17:0]       	I_noise_cut,Q_noise_cut;		//I、Q支路截断噪声
	wire     [18:0]       	I_rev,Q_rev;					//I、Q支路添加噪声后信号
	wire     [35:0]       	I_match,Q_match;				//I、Q支路匹配滤波信号
	wire     [35:0]       	temp_I,temp_Q;					//I、Q支路判决采样信号
	wire     [1:0]        	I_dec,Q_dec;					//I、Q支路判决结果
	wire     [1:0]        	bit_rev;						//星座解映射信号
	wire     [4:0]        	sum;							//巴克码检测计数求和
	wire     [1:0]        	enable;							//检测成功标志
	wire     [11:0]       	cnt;							//m序列检测计数
	wire     [1:0]        	bit_delay;						//m序列同步信号
	wire     [1:0]        	m_seq;							//m序列对比信号
	wire     [10:0]       	count_frame;					//发送帧数
	wire     [19:0]       	error_cnt;						//误码计数
	wire     [19:0]       	error_cnt_display;				//误码记录显示
	wire	 [11:0]			data_fir_I,data_fir_Q;			//DA输出前内插信号
	wire	 [11:0]			out_da_dataI;					//I支路内插滤波器输出信号
	wire	 [11:0]			out_da_dataQ;					//Q支路内插滤波器输出信号
	
	wire	 [35:0]       	CONTROL;
/* *********************************************************** */
chips_config_core u_sysclk (
    .clk(CLK_40M), 
    .rst_n(rst_n), 
    .o_afe7225_spi_clk(), 
    .o_afe7225_spi_mosi(), 
    .i_afe7225_spi_miso(), 
    .o_afe7225_spi_le(), 
    .o_afe7225_pd(), 
    .o_cdce62002_spi_clk(o_cdce62002_spi_clk), 
    .o_cdce62002_spi_mosi(o_cdce62002_spi_mosi), 
    .i_cdce62002_spi_miso(i_cdce62002_spi_miso), 
    .o_cdce62002_spi_le(o_cdce62002_spi_le), 
    .o_cdce62002_pd_n(o_cdce62002_pd_n), 
    .i_cdce62002_pll_lock(i_cdce62002_pll_lock), 
    .o_clk_sel(o_clk_sel), 
    .i_ADCA_clk(i_ADCA_clk), 
    .i_ADCB_clk(i_ADCB_clk), 
    .i_DACP_clk(i_DACP_clk), 
    .led(led)
    );
/* ********************************************************************8 */
	
DCM_module  DCM_module(
				  .CLK_40M(CLK_40M),			//系统输入时钟频率为40MHz
				  .rst_n(rst_n),				//复位
				  .CLK_4div(fs_bit),			//时钟频率为10MHz
				  .CLK_8div(rate_bit),			//时钟频率为5MHz
				  .CLK_16div(fs_bit_div)		//时钟频率为2.5MHz
				  );

bake_m_gen  bake_m_gen(
				  .clk_fs(fs_bit),				//时钟频率为10MHz
				  .rst_n(rst_n),				//复位
				  .bake_m_seq(bit_tran),		//带13位巴克码的m序列
				  .bake(bake)					//13位巴克码
				  );

serial_paralle  serial_paralle(
				  .clk_fs(fs_bit),				//时钟频率为10MHz
				  .rst_n(rst_n),				//复位
				  .data_in(bit_tran),			//带13位巴克码的m序列
				  .data_out_I(I_bit),			//I支路星座映射输出信号
				  .data_out_Q(Q_bit)			//Q支路星座映射输出信号
				  );

insert_zero  insert_zero(
				  .clk_fs(fs_bit),				//时钟频率为10MHz
				  .rst_n(rst_n),				//复位
				  .data_I_in(I_bit),			//I支路星座映射信号
				  .data_I_out(I_interp),		//I支路插零输出信号
				  .data_Q_in(Q_bit),			//Q支路星座映射信号
				  .data_Q_out(Q_interp)			//Q支路插零输出信号
				  );

FIR_LP_filter FIR_LP_filter_I(
				   .rfd(), 
				   .rdy(), 
				   .clk(fs_bit), 				//时钟频率为10MHz
				   .dout(I_filter), 			//I支路成型滤波信号
				   .din(I_interp)				//I支路插零信号
				   );
					   
FIR_LP_filter FIR_LP_filter_Q(
				   .rfd(), 
				   .rdy(), 
				   .clk(fs_bit), 				//时钟频率为10MHz
				   .dout(Q_filter), 			//Q支路成型滤波信号
				   .din(Q_interp)				//Q支路插零信号
				   );
					   
SoS_module AWGN_module_u(
				   .clk_fs(fs_bit),				//时钟频率为10MHz
				   .rst_n(rst_n),				//复位
				   .omega_n_add(0),				//角频率
				   .gauss_I(I_noise),			//I支路噪声
				   .gauss_Q(Q_noise)			//Q支路噪声
				   );
		 
noise_adder noise_adder(
					.clk_fs(fs_bit),				//时钟频率为10MHz
					.rst_n(rst_n),				//复位
					.SW(SW2),					//选择开关
					.I_filter(I_filter), 		//I支路成型滤波信号
					.Q_filter(Q_filter),		//Q支路成型滤波信号
					.I_noise(I_noise),  		//I支路噪声
					.Q_noise(Q_noise),			//Q支路噪声
					.I_rev(I_rev), 				//I支路添加噪声后信号
					.Q_rev(Q_rev),				//Q支路添加噪声后信号
					.I_noise_cut(I_noise_cut),  //I支路截断噪声
					.Q_noise_cut(Q_noise_cut)	//Q支路截断噪声
					);
		 
Match_filter Match_filter_I(
					.rfd(), 
					.rdy(), 
					.clk(fs_bit), 				//时钟频率为10MHz
					.dout(I_match), 			//I支路匹配滤波输出
					.din(I_rev) 				//I支路添加噪声后信号
					);

Match_filter Match_filter_Q(
					.rfd(), 
					.rdy(), 
					.clk(fs_bit), 				//时钟频率为10MHz
					.dout(Q_match), 			//Q支路匹配滤波输出
					.din(Q_rev)					//Q支路添加噪声后信号
					);

hard_decision hard_decision(
					.clk_fs(fs_bit),				//时钟频率为10MHz
					.rst_n(rst_n),				//复位
					.filter_in_I(I_match),		//I支路匹配滤波信号
					.filter_in_Q(Q_match),		//Q支路匹配滤波信号
					.bit_out_I(I_dec),			//I支路判决输出结果
					.bit_out_Q(Q_dec),			//Q支路判决输出结果
					.temp_I(temp_I),			//I支路判决采样信号
					.temp_Q(temp_Q)				//Q支路判决采样信号
					);	

paralle_serial paralle_serial(
					.clk_fs(fs_bit),				//时钟频率为10MHz
					.rst_n(rst_n),				//复位
					.bit_in_I(I_dec),			//I支路判决结果
					.bit_in_Q(Q_dec),			//Q支路判决结果
					.bit_rev(bit_rev)			//解映射输出结果
					);

bake_m_idfy bake_m_idfy(
					.clk_fs(fs_bit),				//时钟频率为10MHz
					.rst_n(rst_n),				//复位
					.bit_rev(bit_rev),			//星座解映射信号
					.bit_delay(bit_delay),		//m序列同步信号
					.sum(sum),					//用于检测巴克码序列是否正确，正确时sum = 13
					.enable(enable),			//当检测巴克码序列正确时，enable置为1
					.count(cnt)					//count从0到1026,包含巴克码序列的m序列长度为1027
					);

error_calculate error_calculate(
					.clk_fs(fs_bit),				//时钟频率为10MHz
					.enable(enable),			//当检测巴克码序列正确时，enable置为1
					.count(cnt),				//count从0到1026,包含巴克码序列的m序列长度为1027
					.bit_rev_delay(bit_delay),	//m序列同步信号
					.m_seq(m_seq),				//m序列对比信号
					.count_frame(count_frame),	//发送帧数
					.error_cnt(error_cnt),		//误码计数
					.error_cnt_display(error_cnt_display)   //误码记录显示
					);

LED_display LED_display(
					.clk_fs(fs_bit),					//时钟频率为10MHz
					.clk_bit_div(fs_bit_div),				//时钟频率为2.5MHz
					.SW(SW2[2:0]),							//选择开关
					.error_display(error_cnt_display),		//误码记录显示
					.DATA_OUT(DATA_OUT)						//数码管误码数显示
					);
/* ******************LCD_display**************** */
lcd_example lcd_example(//input
					.CLK(CLK_40M),							//时钟频率为40MHz
					.rst_n(rst_n),							//复位
					.sw2(SW2),								//选择开关
					.error_display(error_cnt_display),		//误码记录显示
					//output
					.DCLK(DCLK),
					.HS(HS),
					.UD(UD),
					.LR(LR),
					.VS(VS),
					.DE(DE),
					.LCDR(LCDR),
					.LCDG(LCDG),							
					.LCDB(LCDB),							
					.out_lcdpwr_on(out_lcdpwr_on)
);
/* ******************内插滤波********************** */
//内插
/* DA_insert_zeros	DA_insert_zeros(	
					.clk_40M(CLK_40M),				//时钟频率为10MHz
					.rst_n(rst_n),					//复位
					.in_da_data0(I_match[35:24]),	//内插输入信号1
					.in_da_data1(Q_match[35:24]),	//内插输入信号2
					.out_da_data0(out_da_dataI),	//内插输出信号1
					.out_da_data1(out_da_dataQ)		//内插输出信号1
); */

/* DA_FIR DA_FIR_I(
				   .rfd(), 
				   .rdy(), 
				   .clk(CLK_40M), 					//时钟频率为10MHz
				   .dout(data_fir_I), 				//DA输出前内插信号
				   .din(out_da_dataI)				//I支路内插滤波器输出信号
); */

/* DA_FIR DA_FIR_Q(
				   .rfd(), 
				   .rdy(), 
				   .clk(CLK_40M), 					//时钟频率为10MHz
				   .dout(data_fir_Q), 				//DA输出前内插信号
				   .din(out_da_dataQ)				//Q支路内插滤波器输出信号
); */		
		   
DA_out  signal_out_DA(
					.dac_clk(fs_bit), 				//时钟频率为10MHz
					.reset_n(rst_n), 				//复位
					.in_da0_data(I_match[35:24]),	//DA输入信号1
					.in_da1_data(Q_match[35:24]), 	//DA输入信号2
					.out_da0_wr(out_da0_wr), 		//DA输出时钟1
					.out_da1_wr(out_da1_wr), 		//DA输出时钟2
					.out_da0_data(out_da0_data), 	//DA输出信号1
					.out_da1_data(out_da1_data)		//DA输出信号2
);
/* ******************chipscope输出观察********************* */
ICON MYICON(
		.CONTROL0(CONTROL)
		);	
	
ILA MYILA(
		.CLK(CLK_40M),				//时钟频率为10MHz
		.CONTROL(CONTROL),
		.TRIG0(1'b1),
		.DATA({out_da0_data,out_da1_data})
		);						

endmodule

/* TFT LCD 7寸1024*600 FPGA点亮(2013-3-5 15:34)
花了一些时间去点亮7寸TFT，现在只能做自动切换画面的部分，按键切换还正在调试中。如下： */

 

`timescale 1ns / 1ps

module lcd_example(//input
					CLK,
					rst_n,
					sw2,
					error_display,
					//output
					DCLK,
					HS,
					UD,
					LR,
					VS,
					DE,
					LCDR,
					LCDG,
					LCDB,
					out_lcdpwr_on
);
input  CLK;
input  rst_n;
input [3:0] sw2;
input [19:0] error_display;
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

assign out_lcdpwr_on = 1'b1;

/*****************CMO 5D WVGA parameter*******************/
// Horizontal Signals:
parameter 
thpw = 11'd128,     //HS Pulse Width,1-40 DCLK
thb  = 11'd216,    //HS Blanking 46 DCLK = HS Pulse Width + HS Back Porch
thd  = 11'd800,    //Horizontal Display Area,800 DCLK
thfp = 11'd88,    //HS Front Porch,16-210-354 DCLK
th   = (thb+thd+thfp),  //One Horizontal Line = HS Blanking (thb) + Horizontal Display Area (thd) + HS Front Porch (thfp)

// Vertical Signals:
tvpw = 11'd2,     //Vs Pulse Width 1-20 TH
tvb  = 11'd35,    //Vs Blanking 23 TH = Vs Pulse Width + VS Back Porch
tvd  = 11'd480,    //Vertical Dsiplay Area 480 TH
tvfp = 11'd8,    //Vs Front Porch 7-22-147 TH
tv   = (tvb+tvd+tvfp);  //Vs Blanking (tvb) + Vertical Dsiplay Area (tvd) + Vs Front Porch (tvfp)

	wire [7:0] LCDR;
	wire [7:0] LCDG;
	wire [7:0] LCDB;
	wire [23:0] data;

	reg HS_R = 1'b1;
	reg VS_R = 1'b1;
	reg UD_R = 1'b1;
	reg LR_R = 1'b1;
	reg [12:0] hcount = th-1'b1;
	reg [12:0] vcount = tv-1'b1; 
	reg videoh = 1'b0;
	reg videov = 1'b0;
	wire DE;
	//reg [12:0] source = 12'b0; 
	//reg [12:0] gate = 12'b0;

	assign DCLK = CLK;
	assign HS = HS_R;
	assign VS = VS_R;
	assign UD = UD_R;
	assign LR = LR_R;
	assign DE = videoh && videov ;     //videoh逻辑与videov=videon
	assign LCDR = data[23:16] ;
	assign LCDG = data[15:8] ;
	assign LCDB = data[7:0] ;

	//TFT hcount, vcount siganl
	always @(posedge CLK or negedge rst_n)begin         //一直执行横向纵向数据的自加功能
		if(!rst_n)begin
				hcount <= 1'b0;
				vcount <= 1'b0;
		end
		else if(hcount==(th-1'b1))begin        //当hcount等于Total横向数据时执行下面操作
			hcount <= 1'b0;         //赋值给hcount为0
			if(vcount==(tv-1'b1))       //如果vcount的值等于纵向Total数据时执行下面操作
				vcount <= 1'b0;        //赋值给vcount为0
			else
				vcount <= vcount+ 1'b1;      //如果vcount的值未到Total数值时，执行vcount自动加1赋值
		end
		else
			hcount <= hcount+1'b1;				//如果hcount的值未到Total横向数据时，执行hcount自动加1赋值       
	end
	//videoh signal
	always @(hcount)begin          //横向数据函数
		if( (hcount>=thb) && (hcount<=(thb+thd)) )   //如果hcount大于等于HBP+HPW同时满足hcount小于等于HBP+HPW+HPD执行下面的操作
			videoh <= 1'b1;          //videoh赋值为1
		else
			videoh <= 1'b0;          //超过这个范围时videoh赋值为0
	end
	//videov signal
	always @(vcount)begin           //纵向数据显示函数
		if( (vcount>=tvb) && (vcount<=(tvb+tvd)) ) //如果vcount大于等于VBP+VPW同时满足vcount小于等于VBP+VPW+VPD执行下面操作
			videov <= 1'b1;          //videov赋值为1
		else
			videov <= 1'b0;          //videov赋值为0
	end

	/* always @(posedge CLK or negedge rst_n)begin
		if(!rst_n)begin
			source 	<= 0;
			gate	<= 0;
		end
		else if(videon==1'b1)begin             //当videoh和videov同时满足为正的时候，也就是在正常显示的区域内执行下面操作。
			source <= source+12'b1;       //source自动加1
			gate <= gate+12'b1;        //gate自动加1
		end
		else begin	 
			source <= 12'b0;         //否则source=0;gate=0;
			gate <= 12'b0;
		end
	end */

	always @(posedge CLK or negedge rst_n)begin
		if(!rst_n)begin
			VS_R 	<= 0;
		end
		else if((vcount>=tvpw)&&(vcount<=tv))
			VS_R<=1'b1; 
		else
			VS_R<=1'b0;
	end
	always @(posedge CLK or negedge rst_n)begin
		if(!rst_n)begin
			HS_R	<= 0;
		end
		else if((hcount>=thpw)&&(hcount<=th))
			HS_R<=1'b1;      
		else
			HS_R<=1'b0;
	end

error_LCD LCD_display(
				.clk(CLK),
				.rst_n(rst_n),
				.sw2(sw2),
				.error_display(error_display),
				.hcount(hcount),
				.vcount(vcount),
				.data(data)
);
	
	/* time_count U1(
				.clk(CLK),
				.rst_n(rst_n),
				.sw2(sw2),
				.button(button),
				.hcount(hcount),
				.vcount(vcount),
				.data(data)
); */
//display color style
/* select_col_sty	U2(	
				.clk(CLK),
				.rst_n(rst_n),
				.dismode(sw2),
				.hcount(hcount),
				.vcount(vcount),
				.data(data)
); */
/* hanzi_display	hanzi(
				.clk(CLK),
				.rst_n(rst_n),
				.hcount(hcount),
				.vcount(vcount),
				.data(data)
); */
endmodule
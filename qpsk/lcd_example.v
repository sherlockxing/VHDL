/* TFT LCD 7��1024*600 FPGA����(2013-3-5 15:34)
����һЩʱ��ȥ����7��TFT������ֻ�����Զ��л�����Ĳ��֣������л������ڵ����С����£� */

 

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
	assign DE = videoh && videov ;     //videoh�߼���videov=videon
	assign LCDR = data[23:16] ;
	assign LCDG = data[15:8] ;
	assign LCDB = data[7:0] ;

	//TFT hcount, vcount siganl
	always @(posedge CLK or negedge rst_n)begin         //һֱִ�к����������ݵ��Լӹ���
		if(!rst_n)begin
				hcount <= 1'b0;
				vcount <= 1'b0;
		end
		else if(hcount==(th-1'b1))begin        //��hcount����Total��������ʱִ���������
			hcount <= 1'b0;         //��ֵ��hcountΪ0
			if(vcount==(tv-1'b1))       //���vcount��ֵ��������Total����ʱִ���������
				vcount <= 1'b0;        //��ֵ��vcountΪ0
			else
				vcount <= vcount+ 1'b1;      //���vcount��ֵδ��Total��ֵʱ��ִ��vcount�Զ���1��ֵ
		end
		else
			hcount <= hcount+1'b1;				//���hcount��ֵδ��Total��������ʱ��ִ��hcount�Զ���1��ֵ       
	end
	//videoh signal
	always @(hcount)begin          //�������ݺ���
		if( (hcount>=thb) && (hcount<=(thb+thd)) )   //���hcount���ڵ���HBP+HPWͬʱ����hcountС�ڵ���HBP+HPW+HPDִ������Ĳ���
			videoh <= 1'b1;          //videoh��ֵΪ1
		else
			videoh <= 1'b0;          //���������Χʱvideoh��ֵΪ0
	end
	//videov signal
	always @(vcount)begin           //����������ʾ����
		if( (vcount>=tvb) && (vcount<=(tvb+tvd)) ) //���vcount���ڵ���VBP+VPWͬʱ����vcountС�ڵ���VBP+VPW+VPDִ���������
			videov <= 1'b1;          //videov��ֵΪ1
		else
			videov <= 1'b0;          //videov��ֵΪ0
	end

	/* always @(posedge CLK or negedge rst_n)begin
		if(!rst_n)begin
			source 	<= 0;
			gate	<= 0;
		end
		else if(videon==1'b1)begin             //��videoh��videovͬʱ����Ϊ����ʱ��Ҳ������������ʾ��������ִ�����������
			source <= source+12'b1;       //source�Զ���1
			gate <= gate+12'b1;        //gate�Զ���1
		end
		else begin	 
			source <= 12'b0;         //����source=0;gate=0;
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
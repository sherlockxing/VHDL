`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:15:56 02/23/2012 
// Design Name: 
// Module Name:    LED_display 
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
`define DIG_0		8'b1100_0000//0011_1111// 
`define DIG_1		8'b1111_1001//0000_0110//
`define DIG_2		8'b1010_0100//0101_1011//
`define DIG_3		8'b1011_0000//0100_1111//
`define DIG_4		8'b1001_1001//0110_0110//
`define DIG_5		8'b1001_0010//0110_1101//
`define DIG_6		8'b1000_0010//0111_1101//
`define DIG_7		8'b1111_1000//0000_0111//
`define DIG_8		8'b1000_0000//0111_1111//
`define DIG_9		8'b1001_0000//0110_1111//
`define DIG_A		8'b1000_1000//0111_0111//
`define DIG_B		8'b0000_0000//1111_1111//
`define DIG_C		8'b1100_0110//0011_1001//
`define DIG_D		8'b0100_0000//1011_1111//
`define DIG_E		8'b1000_0110//0111_1001//
`define DIG_F		8'b1000_1110//0111_0001//
`define DIG_1_dp	8'b0111_1001//1000_0110//
`define DIG_2_dp	8'b0010_0100//1101_1011//
`define DIG_3_dp	8'b0011_0000//1100_1111//
`define DIG_5_dp	8'b0001_0010//1110_1101//
`define DIG_6_dp	8'b0000_0010//1111_1101//
`define DIG_7_dp	8'b0111_1000//1000_0111//
`define DIG_8_dp	8'b0000_0000//1111_1111//
module LED_display(		clk_fs,				//时钟频率为10MHz
						clk_bit_div,		//时钟频率为2.5MHz
						SW,
						error_display,		//误码统计显示
						DATA_OUT			//误码数数码管显示信号
);
	input               clk_fs;				//时钟频率为10MHz
	input               clk_bit_div;		//时钟频率为2.5MHz
	input	[2:0]	   	SW;
	input   [19:0]     	error_display;
	output reg	[15:0]  DATA_OUT;


	reg     [7:0]     	data1,data2,data3,data4,data5,data6,data7,data8;
	reg     [3:0]     	cnt_scan = 0;
	reg 	[19:0]	  	diplay_data = 0;
//the first LED  error_display[19:16]
	always@(negedge clk_fs) begin
		diplay_data <= error_display;
		case(diplay_data[3:0])
			4'H0:    data1 <= `DIG_0;
			4'H1:    data1 <= `DIG_1;
			4'H2:    data1 <= `DIG_2;     
			4'H3:    data1 <= `DIG_3;
			4'H4:    data1 <= `DIG_4;     
			4'H5:    data1 <= `DIG_5;
			4'H6:    data1 <= `DIG_6;     
			4'H7:    data1 <= `DIG_7;
			4'H8:    data1 <= `DIG_8;     
			4'H9:    data1 <= `DIG_9;
			4'HA:    data1 <= `DIG_A;     
			4'HB:    data1 <= `DIG_B;
			4'HC:    data1 <= `DIG_C;     
			4'HE:    data1 <= `DIG_E;
			4'HF:    data1 <= `DIG_F;     
		endcase	    
		case(diplay_data[7:4])
			4'H0:    data2 <= `DIG_0;
			4'H1:    data2 <= `DIG_1;
			4'H2:    data2 <= `DIG_2;     
			4'H3:    data2 <= `DIG_3;
			4'H4:    data2 <= `DIG_4;     
			4'H5:    data2 <= `DIG_5;
			4'H6:    data2 <= `DIG_6;     
			4'H7:    data2 <= `DIG_7;
			4'H8:    data2 <= `DIG_8;     
			4'H9:    data2 <= `DIG_9;
			4'HA:    data2 <= `DIG_A;     
			4'HB:    data2 <= `DIG_B;
			4'HC:    data2 <= `DIG_C;     
			4'HE:    data2 <= `DIG_E;
			4'HF:    data2 <= `DIG_F;     
		endcase
		case(diplay_data[11:8])
			4'H0:    data3 <= `DIG_0;
			4'H1:    data3 <= `DIG_1;
			4'H2:    data3 <= `DIG_2;     
			4'H3:    data3 <= `DIG_3;
			4'H4:    data3 <= `DIG_4;     
			4'H5:    data3 <= `DIG_5;
			4'H6:    data3 <= `DIG_6;     
			4'H7:    data3 <= `DIG_7;
			4'H8:    data3 <= `DIG_8;     
			4'H9:    data3 <= `DIG_9;
			4'HA:    data3 <= `DIG_A;     
			4'HB:    data3 <= `DIG_B;
			4'HC:    data3 <= `DIG_C;     
			4'HE:    data3 <= `DIG_E;
			4'HF:    data3 <= `DIG_F;     
		endcase
		case(diplay_data[15:12])
			4'H0:    data4 <= `DIG_0;
			4'H1:    data4 <= `DIG_1;
			4'H2:    data4 <= `DIG_2;     
			4'H3:    data4 <= `DIG_3;
			4'H4:    data4 <= `DIG_4;     
			4'H5:    data4 <= `DIG_5;
			4'H6:    data4 <= `DIG_6;     
			4'H7:    data4 <= `DIG_7;
			4'H8:    data4 <= `DIG_8;     
			4'H9:    data4 <= `DIG_9;
			4'HA:    data4 <= `DIG_A;     
			4'HB:    data4 <= `DIG_B;
			4'HC:    data4 <= `DIG_C;     
			4'HE:    data4 <= `DIG_E;
			4'HF:    data4 <= `DIG_F;     
		endcase
		case(diplay_data[19:16])
			4'H0:    data5 <= `DIG_0;
			4'H1:    data5 <= `DIG_1;
			4'H2:    data5 <= `DIG_2;     
			4'H3:    data5 <= `DIG_3;
			4'H4:    data5 <= `DIG_4;     
			4'H5:    data5 <= `DIG_5;
			4'H6:    data5 <= `DIG_6;     
			4'H7:    data5 <= `DIG_7;
			4'H8:    data5 <= `DIG_8;     
			4'H9:    data5 <= `DIG_9;
			4'HA:    data5 <= `DIG_A;     
			4'HB:    data5 <= `DIG_B;
			4'HC:    data5 <= `DIG_C;     
			4'HE:    data5 <= `DIG_E;
			4'HF:    data5 <= `DIG_F;     
		endcase
		case(SW)
			3'b000:begin
				data8 = `DIG_1_dp;
				data7 = `DIG_8;
				data6 = `DIG_0;
			end
			3'b001:begin
				data8 = `DIG_2_dp;
				data7 = `DIG_6;
				data6 = `DIG_1;
			end
			3'b010:begin
				data8 = `DIG_3_dp;
				data7 = `DIG_3;
				data6 = `DIG_0;
			end
			3'b011:begin
				data8 = `DIG_3_dp;
				data7 = `DIG_9;
				data6 = `DIG_6;
			end
			3'b100:begin
				data8 = `DIG_5_dp;
				data7 = `DIG_2;
				data6 = `DIG_4;
			end
			3'b101:begin
				data8 = `DIG_6_dp;
				data7 = `DIG_1;
				data6 = `DIG_8;
			end
			3'b110:begin
				data8 = `DIG_7_dp;
				data7 = `DIG_4;
				data6 = `DIG_3;
			end
			3'b111:begin
				data8 = `DIG_8_dp;
				data7 = `DIG_5;
				data6 = `DIG_0;
			end
		endcase
	end
	 
	always@(posedge clk_bit_div)begin 
		if (cnt_scan == 4'h8)begin
			cnt_scan <= 0;
		end
		else begin
			cnt_scan <= cnt_scan + 1;
		end
	end
	 
	always@(posedge clk_bit_div)begin
		case(cnt_scan[2:0])
			3'b000:begin
				 DATA_OUT[15:8] <= 8'hFE;   // select the first LED
				 DATA_OUT[7:0]  <= data1;
			end
			3'b001:begin
				DATA_OUT[15:8] <= 8'hFD;   // select the second LED
				DATA_OUT[7:0] <= data2;
			end
			3'b010:begin
				 DATA_OUT[15:8] <= 8'hFB;   // select the third LED
				 DATA_OUT[7:0] <= data3;
			end
			3'b011:begin
				DATA_OUT[15:8] <= 8'hF7;  
				DATA_OUT[7:0] <= data4;
			end
			3'b100:begin
				DATA_OUT[15:8] <= 8'hEF; 
				DATA_OUT[7:0] <= data5;
			end
			3'b101:begin
				DATA_OUT[15:8] <= 8'hDF;  
			    DATA_OUT[7:0] <= data6;
			end
			3'b110:begin
				DATA_OUT[15:8] <= 8'hBF;   
				DATA_OUT[7:0] <= data7;
			end
			3'b111:begin
				DATA_OUT[15:8] <= 8'h7F; 
				DATA_OUT[7:0] <= data8;
			end			  
		endcase
	end
 
//always@(DATA_OUT[15:8])
//  begin
//    case(DATA_OUT[15:8])
//	   8'hFD:
//        DATA_OUT[7:0] <= data1;
//    8'hFB:		
//        DATA_OUT[7:0] <= data2;
//	   8'hF7:
//		  DATA_OUT[7:0] <= data3;
//		8'hEF:
//        DATA_OUT[7:0] <= data4;	
//      8'hDF:
//        DATA_OUT[7:0] <= data5;
//      8'hBF:		
//        DATA_OUT[7:0] <= `DIG_9;
//	   8'h7F:
//		  DATA_OUT[7:0] <= `DIG_9;
//		8'hFE:
//        DATA_OUT[7:0] <= `DIG_9;		  
//    endcase
//  end

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:25:24 11/20/2015 
// Design Name: 
// Module Name:    error_LCD 
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
module error_LCD(
					input 			clk,
					input 			rst_n,
					input	[3:0]	sw2,
					input	[19:0]	error_display,
					input 	[12:0]	hcount,
					input	[12:0] 	vcount,
					output 	[23:0]	data
    );
	
	wire [23:0] data;
	reg [23:0] 	data_temp;
	reg [23:0]	data_temp2;
	reg [23:0]	data_temp3;
	reg	[23:0]	data_title;
	reg	[23:0]	data_error;
	reg	[23:0]	data_db;
	reg [23:0]	data_nuaa;
	reg [23:0]	data_qpsk;
	
	reg	[16:0]	addra_title_count;
	reg	[16:0]	addra_error_count;
	reg	[16:0]	addra_db_count;
	reg [15:0]	qpsk_count;
	
	reg	[16:0]	addra_title;
	reg	[16:0]	addra_error;
	reg	[16:0]	addra_db;
	reg [16:0]	addra_nuaa;
	reg [15:0]	addra_qpsk;
	
	wire		douta_title;
	wire		douta_error;
	wire		douta_db;
	wire		douta_nuaa;
	wire		douta_qpsk;
	
	parameter thb  = 11'd216,thd  = 11'd800,tvb  = 11'd35,tvd  = 11'd480;
	
	assign data = data_temp3;
	/* ********************title_nuaa****************************** */
	always @(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			addra_nuaa 	<= 17'd0;
		end
		else begin
			if(hcount > (thb) && hcount <= (thb+thd) && vcount > (tvb) && vcount <= (tvb+tvd/3))
			begin
				addra_nuaa	 <= addra_nuaa+17'd1;
				data_nuaa <= {7'b1111111,douta_nuaa,{5{douta_nuaa}},3'b111,{2{douta_nuaa}},2'b11,{4{douta_nuaa}}};
				if(addra_nuaa>=17'd127999)begin
					addra_nuaa <= 17'd0;
				end
			end
			else begin
				addra_nuaa <= addra_nuaa;
			end
		end
	end
	/* ********************title_qpsk***************************** */
	reg [15:0] addra_qpsk1,addra_qpsk2;
	always @(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			addra_qpsk 	<= 16'd0;
			qpsk_count  <= 16'd0;
			addra_qpsk1 <= 16'd0;
			addra_qpsk2 <= 16'd0;
		end
		else begin
			if(hcount > (thb+3*thd/8) && hcount <= (thb+5*thd/8) && vcount > (tvb+3*tvd/6) && vcount <= (tvb+4*tvd/6))
			begin
				qpsk_count <= 16'd0;
				addra_qpsk1 <= addra_qpsk1+16'd1;
				addra_qpsk	<= addra_qpsk1;
				data_qpsk <= {7'b1111111,douta_qpsk,{5{douta_qpsk}},3'b111,{2{douta_qpsk}},2'b11,{4{douta_qpsk}}};
				if(addra_qpsk1>=16'd15999)begin
					addra_qpsk1 <= 16'd0;
				end
				if(addra_qpsk>=16'd15999)begin
					addra_qpsk <= 16'd0;
				end
			end
			else if(hcount > (thb+1*thd/8) && hcount <= (thb+7*thd/8) && vcount > (tvb+4*tvd/6) && vcount <= (tvb+5*tvd/6))
			begin
				qpsk_count <= 16'd16000;
				addra_qpsk2 <= addra_qpsk2+16'd1;
				addra_qpsk	<= addra_qpsk2;
				data_qpsk <= {7'b1111111,douta_qpsk,{5{douta_qpsk}},3'b111,{2{douta_qpsk}},2'b11,{4{douta_qpsk}}};
				if(addra_qpsk2>=16'd47999)begin
					addra_qpsk2 <= 16'd0;
				end
				if(addra_qpsk>=16'd47999)begin
					addra_qpsk <= 16'd0;
				end
			end
			else begin
				addra_qpsk <= addra_qpsk;
			end
		end
	end
	/* ***********************nuaa区域选择************************ */
	always @(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			data_temp2 <= {8'd255,8'd255,8'd255};
		end
		else begin
			if(hcount > (thb) && hcount <= (thb+thd) && vcount > (tvb) && vcount <= (tvb+tvd/3))
			begin//"南京航空航天大学"字
				data_temp2 <= data_nuaa;
			end
			else if(hcount > (thb+3*thd/8) && hcount <= (thb+5*thd/8) && vcount > (tvb+3*tvd/6) && vcount <= (tvb+4*tvd/6))
			begin//"QPSK"字
				data_temp2 <= data_qpsk;
			end
			else if(hcount > (thb+1*thd/8) && hcount <= (thb+7*thd/8) && vcount > (tvb+4*tvd/6) && vcount <= (tvb+5*tvd/6))
			begin //"调制解调系统试验"字
				data_temp2 <= data_qpsk;
			end
			else begin
				data_temp2 <= {7'b1111111,6'b0,3'b111,2'b0,2'b11,4'b0};
			end
		end
	end
	/* ********************title_show***************************** */
	reg [3:0]	title_sw;
	reg [16:0]	addra_title1,addra_title2,addra_title3,addra_title4;
	
	always @(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			title_sw	<= 4'b0;
		end
		else begin
			title_sw[0] <= (hcount > (thb+2*thd/8) && hcount <= (thb+4*thd/8) && vcount > (tvb) && vcount <= (tvb+tvd/4)) ? 1:0;
			title_sw[1] <= (hcount > (thb+4*thd/8) && hcount <= (thb+6*thd/8) && vcount > (tvb) && vcount <= (tvb+tvd/4)) ? 1:0;
			title_sw[2] <= (hcount > (thb) && hcount <= (thb+2*thd/8) && vcount > (tvb+tvd/4) && vcount <= (tvb+2*tvd/4)) ? 1:0;
			title_sw[3] <= (hcount > (thb) && hcount <= (thb+2*thd/8) && vcount > (tvb+2*tvd/4) && vcount <= (tvb+3*tvd/4)) ? 1:0;
		end
	end
	always @(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			addra_title_count 	<= 17'd0;
			addra_title 		<= 17'd0;
			addra_title1 		<= 17'd0;
			addra_title2 		<= 17'd0;
			addra_title3 		<= 17'd0;
			addra_title4 		<= 17'd0;
		end
		else begin
			case(title_sw)
				4'b0001:begin//"误码"字
					addra_title_count <= 17'd0;
					addra_title1 <= addra_title1+17'd1;
					addra_title	 <= addra_title1;
					data_title <= {7'b1111111,douta_title,{5{douta_title}},3'b111,{2{douta_title}},2'b11,{4{douta_title}}};
					if(addra_title1>=17'd23999)begin
						addra_title1 <= 17'd0;
					end
					if(addra_title>=17'd23999)begin
						addra_title <= 17'd0;
					end
				end
			
				4'b0010:begin//"显示"字
					addra_title_count <= 17'd24000;
					addra_title2 <= addra_title2+17'd1;
					addra_title	 <= addra_title2;
					data_title <= {7'b1111111,douta_title,{5{douta_title}},3'b111,{2{douta_title}},2'b11,{4{douta_title}}};
					if(addra_title2>=17'd23999)begin
						addra_title2 <= 17'd0;
					end
					if(addra_title>=17'd23999)begin
						addra_title <= 17'd0;
					end
				end
			
				4'b0100:begin//"error:"字
					addra_title_count <= 17'd48000;
					addra_title3 <= addra_title3+17'd1;
					addra_title  <= addra_title3;
					data_title <= {7'b1111111,douta_title,{5{douta_title}},3'b111,{2{douta_title}},2'b11,{4{douta_title}}};
					if(addra_title3>=17'd23999)begin
						addra_title3 <= 17'd0;
					end
					if(addra_title>=17'd23999)begin
						addra_title <= 17'd0;
					end
				end
			
				4'b1000:begin//"SNR:"字
					addra_title_count <= 17'd72000;
					addra_title4 <= addra_title4+17'd1;
					addra_title  <= addra_title4;
					data_title <= {7'b1111111,douta_title,{5{douta_title}},3'b111,{2{douta_title}},2'b11,{4{douta_title}}};
					if(addra_title4>=17'd23999)begin
						addra_title4 <= 17'd0;
					end
					if(addra_title>=17'd23999)begin
						addra_title <= 17'd0;
					end
				end
				default: begin
					addra_title <= addra_title;
				end
			endcase
		end
	end
	
	/* **********************error_show****************************** */
	reg [5:0] 	error_sw;
	reg [16:0]	addra_error1,addra_error2,addra_error3;
	reg [16:0]	addra_error4,addra_error5,addra_error6;
	always @(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			error_sw	<= 6'b0;
		end
		else begin
			error_sw[0] <= (hcount > (thb+8*thd/10) && hcount <= (thb+9*thd/10) && vcount > (tvb+tvd/4) && vcount <= (tvb+2*tvd/4)) ? 1:0;
			error_sw[1] <= (hcount > (thb+7*thd/10) && hcount <= (thb+8*thd/10) && vcount > (tvb+tvd/4) && vcount <= (tvb+2*tvd/4)) ? 1:0;
			error_sw[2] <= (hcount > (thb+6*thd/10) && hcount <= (thb+7*thd/10) && vcount > (tvb+tvd/4) && vcount <= (tvb+2*tvd/4)) ? 1:0;
			error_sw[3] <= (hcount > (thb+5*thd/10) && hcount <= (thb+6*thd/10) && vcount > (tvb+tvd/4) && vcount <= (tvb+2*tvd/4)) ? 1:0;
			error_sw[4] <= (hcount > (thb+4*thd/10) && hcount <= (thb+5*thd/10) && vcount > (tvb+tvd/4) && vcount <= (tvb+2*tvd/4)) ? 1:0;
			error_sw[5] <= (hcount > (thb+3*thd/10) && hcount <= (thb+4*thd/10) && vcount > (tvb+tvd/4) && vcount <= (tvb+2*tvd/4)) ? 1:0;
		end
	end	
	always @(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			addra_error <= 17'b0;
			addra_error1 <= 17'b0;
			addra_error2 <= 17'b0;
			addra_error3 <= 17'b0;
			addra_error4 <= 17'b0;
			addra_error5 <= 17'b0;
			addra_error6 <= 17'b0;
			addra_error_count <= 17'd0;
		end
		else begin
			case(error_sw)
				6'b000001:begin //error_ge
					case(error_display%10)
						20'd0: begin
							addra_error_count <= 17'd0;
							addra_error1 <= addra_error1+17'd1;
							addra_error <= addra_error1;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error1>=17'd9599)begin
								addra_error1 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd1: begin
							addra_error_count <= 17'd9600; //0+9600
							addra_error1 <= addra_error1+17'd1;
							addra_error <= addra_error1;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error1>=17'd9599)begin
								addra_error1 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd2: begin
							addra_error_count <= 17'd19200; //0+9600*2
							addra_error1 <= addra_error1+17'd1;
							addra_error <= addra_error1;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error1>=17'd9599)begin
								addra_error1 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd3: begin
							addra_error_count <= 17'd28800; //0+9600*3
							addra_error1 <= addra_error1+17'd1;
							addra_error <= addra_error1;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error1>=17'd9599)begin
								addra_error1 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd4: begin
							addra_error_count <= 17'd38400; //0+9600*4
							addra_error1 <= addra_error1+17'd1;
							addra_error <= addra_error1;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error1>=17'd9599)begin
								addra_error1 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd5: begin
							addra_error_count <= 17'd48000; //0+9600*5
							addra_error1 <= addra_error1+17'd1;
							addra_error <= addra_error1;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error1>=17'd9599)begin
								addra_error1 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd6: begin
							addra_error_count <= 17'd57600; //0+9600*6
							addra_error1 <= addra_error1+17'd1;
							addra_error <= addra_error1;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error1>=17'd9599)begin
								addra_error1 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd7: begin
							addra_error_count <= 17'd67200; //0+9600*7
							addra_error1 <= addra_error1+17'd1;
							addra_error <= addra_error1;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error1>=17'd9599)begin
								addra_error1 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						5'd8: begin
							addra_error_count <= 17'd76800; //0+9600*8
							addra_error1 <= addra_error1+17'd1;
							addra_error <= addra_error1;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error1>=17'd9599)begin
								addra_error1 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd9: begin
							addra_error_count <= 17'd86400; //0+9600*9
							addra_error1 <= addra_error1+17'd1;
							addra_error <= addra_error1;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error1>=17'd9599)begin
								addra_error1 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
					endcase
				end
				6'b000010:
				begin //error_shi
					case((error_display%100)/10)
						20'd0: begin
							addra_error_count <= 17'd0;
							addra_error2 <= addra_error2+17'd1;
							addra_error <= addra_error2;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error2>=17'd9599)begin
								addra_error2 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd1: begin
							addra_error_count <= 17'd9600; //0+9600
							addra_error2 <= addra_error2+17'd1;
							addra_error <= addra_error2;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error2>=17'd9599)begin
								addra_error2 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd2: begin
							addra_error_count <= 17'd19200; //0+9600*2
							addra_error2 <= addra_error2+17'd1;
							addra_error <= addra_error2;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error2>=17'd9599)begin
								addra_error2 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd3: begin
							addra_error_count <= 17'd28800; //0+9600*3
							addra_error2 <= addra_error2+17'd1;
							addra_error <= addra_error2;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error2>=17'd9599)begin
								addra_error2 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd4: begin
							addra_error_count <= 17'd38400; //0+9600*4
							addra_error2 <= addra_error2+17'd1;
							addra_error <= addra_error2;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error2>=17'd9599)begin
								addra_error2 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd5: begin
							addra_error_count <= 17'd48000; //0+9600*5
							addra_error2 <= addra_error2+17'd1;
							addra_error <= addra_error2;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error2>=17'd9599)begin
								addra_error2 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd6: begin
							addra_error_count <= 17'd57600; //0+9600*6
							addra_error2 <= addra_error2+17'd1;
							addra_error <= addra_error2;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error2>=17'd9599)begin
								addra_error2 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd7: begin
							addra_error_count <= 17'd67200; //0+9600*7
							addra_error2 <= addra_error2+17'd1;
							addra_error <= addra_error2;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error2>=17'd9599)begin
								addra_error2 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						5'd8: begin
							addra_error_count <= 17'd76800; //0+9600*8
							addra_error2 <= addra_error2+17'd1;
							addra_error <= addra_error2;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error2>=17'd9599)begin
								addra_error2 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd9: begin
							addra_error_count <= 17'd86400; //0+9600*9
							addra_error2 <= addra_error2+17'd1;
							addra_error <= addra_error2;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error2>=17'd9599)begin
								addra_error2 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
					endcase
				end
				6'b000100:
				begin //error_bai
					case((error_display%1000)/100)
						20'd0: begin
							addra_error_count <= 17'd0;
							addra_error3 <= addra_error3+17'd1;
							addra_error <= addra_error3;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error3>=17'd9599)begin
								addra_error3 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd1: begin
							addra_error_count <= 17'd9600; //0+9600
							addra_error3 <= addra_error3+17'd1;
							addra_error <= addra_error3;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error3>=17'd9599)begin
								addra_error3 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd2: begin
							addra_error_count <= 17'd19200; //0+9600*2
							addra_error3 <= addra_error3+17'd1;
							addra_error <= addra_error3;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error3>=17'd9599)begin
								addra_error3 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd3: begin
							addra_error_count <= 17'd28800; //0+9600*3
							addra_error3 <= addra_error3+17'd1;
							addra_error <= addra_error3;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error3>=17'd9599)begin
								addra_error3 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd4: begin
							addra_error_count <= 17'd38400; //0+9600*4
							addra_error3 <= addra_error3+17'd1;
							addra_error <= addra_error3;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error3>=17'd9599)begin
								addra_error3 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd5: begin
							addra_error_count <= 17'd48000; //0+9600*5
							addra_error3 <= addra_error3+17'd1;
							addra_error <= addra_error3;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error3>=17'd9599)begin
								addra_error3 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd6: begin
							addra_error_count <= 17'd57600; //0+9600*6
							addra_error3 <= addra_error3+17'd1;
							addra_error <= addra_error3;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error3>=17'd9599)begin
								addra_error3 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd7: begin
							addra_error_count <= 17'd67200; //0+9600*7
							addra_error3 <= addra_error3+17'd1;
							addra_error <= addra_error3;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error3>=17'd9599)begin
								addra_error3 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						5'd8: begin
							addra_error_count <= 17'd76800; //0+9600*8
							addra_error3 <= addra_error3+17'd1;
							addra_error <= addra_error3;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error3>=17'd9599)begin
								addra_error3 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd9: begin
							addra_error_count <= 17'd86400; //0+9600*9
							addra_error3 <= addra_error3+17'd1;
							addra_error <= addra_error3;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error3>=17'd9599)begin
								addra_error3 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
					endcase
				end
				6'b001000:
				begin //error_qian
					case((error_display%10000)/1000)
						20'd0: begin
							addra_error_count <= 17'd0;
							addra_error4 <= addra_error4+17'd1;
							addra_error <= addra_error4;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error4>=17'd9599)begin
								addra_error4 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd1: begin
							addra_error_count <= 17'd9600; //0+9600
							addra_error4 <= addra_error4+17'd1;
							addra_error <= addra_error4;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error4>=17'd9599)begin
								addra_error4 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd2: begin
							addra_error_count <= 17'd19200; //0+9600*2
							addra_error4 <= addra_error4+17'd1;
							addra_error <= addra_error4;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error4>=17'd9599)begin
								addra_error4 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd3: begin
							addra_error_count <= 17'd28800; //0+9600*3
							addra_error4 <= addra_error4+17'd1;
							addra_error <= addra_error4;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error4>=17'd9599)begin
								addra_error4 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd4: begin
							addra_error_count <= 17'd38400; //0+9600*4
							addra_error4 <= addra_error4+17'd1;
							addra_error <= addra_error4;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error4>=17'd9599)begin
								addra_error4 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd5: begin
							addra_error_count <= 17'd48000; //0+9600*5
							addra_error4 <= addra_error4+17'd1;
							addra_error <= addra_error4;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error4>=17'd9599)begin
								addra_error4 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd6: begin
							addra_error_count <= 17'd57600; //0+9600*6
							addra_error4 <= addra_error4+17'd1;
							addra_error <= addra_error4;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error4>=17'd9599)begin
								addra_error4 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd7: begin
							addra_error_count <= 17'd67200; //0+9600*7
							addra_error4 <= addra_error4+17'd1;
							addra_error <= addra_error4;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error4>=17'd9599)begin
								addra_error4 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						5'd8: begin
							addra_error_count <= 17'd76800; //0+9600*8
							addra_error4 <= addra_error4+17'd1;
							addra_error <= addra_error4;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error4>=17'd9599)begin
								addra_error4 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd9: begin
							addra_error_count <= 17'd86400; //0+9600*9
							addra_error4 <= addra_error4+17'd1;
							addra_error <= addra_error4;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error4>=17'd9599)begin
								addra_error4 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
					endcase
				end
				6'b010000:
				begin //error_wan
					case((error_display%100000)/10000)
						20'd0: begin
							addra_error_count <= 17'd0;
							addra_error5 <= addra_error5+17'd1;
							addra_error <= addra_error5;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error5>=17'd9599)begin
								addra_error5 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd1: begin
							addra_error_count <= 17'd9600; //0+9600
							addra_error5 <= addra_error5+17'd1;
							addra_error <= addra_error5;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error5>=17'd9599)begin
								addra_error5 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd2: begin
							addra_error_count <= 17'd19200; //0+9600*2
							addra_error5 <= addra_error5+17'd1;
							addra_error <= addra_error5;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error5>=17'd9599)begin
								addra_error5 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd3: begin
							addra_error_count <= 17'd28800; //0+9600*3
							addra_error5 <= addra_error5+17'd1;
							addra_error <= addra_error5;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error5>=17'd9599)begin
								addra_error5 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd4: begin
							addra_error_count <= 17'd38400; //0+9600*4
							addra_error5 <= addra_error5+17'd1;
							addra_error <= addra_error5;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error5>=17'd9599)begin
								addra_error5 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd5: begin
							addra_error_count <= 17'd48000; //0+9600*5
							addra_error5 <= addra_error5+17'd1;
							addra_error <= addra_error5;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error5>=17'd9599)begin
								addra_error5 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd6: begin
							addra_error_count <= 17'd57600; //0+9600*6
							addra_error5 <= addra_error5+17'd1;
							addra_error <= addra_error5;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error5>=17'd9599)begin
								addra_error5 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd7: begin
							addra_error_count <= 17'd67200; //0+9600*7
							addra_error5 <= addra_error5+17'd1;
							addra_error <= addra_error5;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error5>=17'd9599)begin
								addra_error5 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						5'd8: begin
							addra_error_count <= 17'd76800; //0+9600*8
							addra_error5 <= addra_error5+17'd1;
							addra_error <= addra_error5;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error5>=17'd9599)begin
								addra_error5 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd9: begin
							addra_error_count <= 17'd86400; //0+9600*9
							addra_error5 <= addra_error5+17'd1;
							addra_error <= addra_error5;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error5>=17'd9599)begin
								addra_error5 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
					endcase
				end
				6'b100000:
				begin //error_shiwan
					case(error_display/100000)
						20'd0: begin
							addra_error_count <= 17'd0;
							addra_error6 <= addra_error6+17'd1;
							addra_error <= addra_error6;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error6>=17'd9599)begin
								addra_error6 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd1: begin
							addra_error_count <= 17'd9600; //0+9600
							addra_error6 <= addra_error6+17'd1;
							addra_error <= addra_error6;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error6>=17'd9599)begin
								addra_error6 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd2: begin
							addra_error_count <= 17'd19200; //0+9600*2
							addra_error6 <= addra_error6+17'd1;
							addra_error <= addra_error6;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error6>=17'd9599)begin
								addra_error6 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd3: begin
							addra_error_count <= 17'd28800; //0+9600*3
							addra_error6 <= addra_error6+17'd1;
							addra_error <= addra_error6;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error6>=17'd9599)begin
								addra_error6 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd4: begin
							addra_error_count <= 17'd38400; //0+9600*4
							addra_error6 <= addra_error6+17'd1;
							addra_error <= addra_error6;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error6>=17'd9599)begin
								addra_error6 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd5: begin
							addra_error_count <= 17'd48000; //0+9600*5
							addra_error6 <= addra_error6+17'd1;
							addra_error <= addra_error6;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error6>=17'd9599)begin
								addra_error6 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd6: begin
							addra_error_count <= 17'd57600; //0+9600*6
							addra_error6 <= addra_error6+17'd1;
							addra_error <= addra_error6;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error6>=17'd9599)begin
								addra_error6 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd7: begin
							addra_error_count <= 17'd67200; //0+9600*7
							addra_error6 <= addra_error6+17'd1;
							addra_error <= addra_error6;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error6>=17'd9599)begin
								addra_error6 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						5'd8: begin
							addra_error_count <= 17'd76800; //0+9600*8
							addra_error6 <= addra_error6+17'd1;
							addra_error <= addra_error6;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error6>=17'd9599)begin
								addra_error6 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
						20'd9: begin
							addra_error_count <= 17'd86400; //0+9600*9
							addra_error6 <= addra_error6+17'd1;
							addra_error <= addra_error6;
							data_error <= {7'b1111111,douta_error,{5{douta_error}},3'b111,{2{douta_error}},2'b11,{4{douta_error}}};
							if(addra_error6>=17'd9599)begin
								addra_error6 <= 17'd0;
							end
							if(addra_error>=17'd9599)begin
								addra_error <= 17'd0;
							end
						end
					endcase
				end
				default: begin
					addra_error <= addra_error;
				end
			endcase
		end
	end
	/* *******************db_show*********************************** */
	reg [5:0]	db_sw;
	reg [16:0]	addra_db1,addra_db2,addra_db3;
	reg [16:0]	addra_db4,addra_db5,addra_db6;
	always @(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			db_sw <= 6'b0;
		end
		else begin
			db_sw[0] <= (hcount > (thb+3*thd/10) && hcount <= (thb+4*thd/10) && vcount > (tvb+2*tvd/4) && vcount <= (tvb+3*tvd/4)) ? 1:0;
			db_sw[1] <= (hcount > (thb+4*thd/10) && hcount <= (thb+5*thd/10) && vcount > (tvb+2*tvd/4) && vcount <= (tvb+3*tvd/4)) ? 1:0;
			db_sw[2] <= (hcount > (thb+5*thd/10) && hcount <= (thb+6*thd/10) && vcount > (tvb+2*tvd/4) && vcount <= (tvb+3*tvd/4)) ? 1:0;
			db_sw[3] <= (hcount > (thb+6*thd/10) && hcount <= (thb+7*thd/10) && vcount > (tvb+2*tvd/4) && vcount <= (tvb+3*tvd/4)) ? 1:0;
			db_sw[4] <= (hcount > (thb+7*thd/10) && hcount <= (thb+8*thd/10) && vcount > (tvb+2*tvd/4) && vcount <= (tvb+3*tvd/4)) ? 1:0;
			db_sw[5] <= (hcount > (thb+8*thd/10) && hcount <= (thb+thd) && vcount > (tvb+2*tvd/4) && vcount <= (tvb+3*tvd/4)) ? 1:0;
		end
	end	
	always @(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			addra_db <= 17'b0;
			addra_db1 <= 17'b0;
			addra_db2 <= 17'b0;
			addra_db3 <= 17'b0;
			addra_db4 <= 17'b0;
			addra_db5 <= 17'b0;
			addra_db6 <= 17'b0;
			addra_db_count <= 17'd0;
		end
		else begin
			case(db_sw)
				6'b000001:
				begin//shiwei
					case(sw2)
						4'b0000: begin
							addra_db_count <= 17'd0;//0*9600
							addra_db1 <= addra_db1+17'd1;
							addra_db <= addra_db1;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db1>=17'd9599)begin
								addra_db1 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b0001: begin
							addra_db_count <= 17'd0;//0*9600
							addra_db1 <= addra_db1+17'd1;
							addra_db <= addra_db1;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db1>=17'd9599)begin
								addra_db1 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b0010: begin
							addra_db_count <= 17'd0;//0*9600
							addra_db1 <= addra_db1+17'd1;
							addra_db <= addra_db1;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db1>=17'd9599)begin
								addra_db1 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b0011: begin
							addra_db_count <= 17'd0;//0*9600
							addra_db1 <= addra_db1+17'd1;
							addra_db <= addra_db1;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db1>=17'd9599)begin
								addra_db1 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b0100: begin
							addra_db_count <= 17'd0;//0*9600
							addra_db1 <= addra_db1+17'd1;
							addra_db <= addra_db1;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db1>=17'd9599)begin
								addra_db1 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b0101: begin
							addra_db_count <= 17'd0;//0*9600
							addra_db1 <= addra_db1+17'd1;
							addra_db <= addra_db1;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db1>=17'd9599)begin
								addra_db1 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b0110: begin
							addra_db_count <= 17'd0;//0*9600
							addra_db1 <= addra_db1+17'd1;
							addra_db <= addra_db1;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db1>=17'd9599)begin
								addra_db1 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b0111: begin
							addra_db_count <= 17'd0;//0*9600
							addra_db1 <= addra_db1+17'd1;
							addra_db <= addra_db1;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db1>=17'd9599)begin
								addra_db1 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b1000: begin
							addra_db_count <= 17'd0;//0*9600
							addra_db1 <= addra_db1+17'd1;
							addra_db <= addra_db1;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db1>=17'd9599)begin
								addra_db1 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b1001: begin
							addra_db_count <= 17'd9600;//1*9600
							addra_db1 <= addra_db1+17'd1;
							addra_db <= addra_db1;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db1>=17'd9599)begin
								addra_db1 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b1010: begin
							addra_db_count <= 17'd9600;//1*9600
							addra_db1 <= addra_db1+17'd1;
							addra_db <= addra_db1;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db1>=17'd9599)begin
								addra_db1 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b1011: begin
							addra_db_count <= 17'd9600;//1*9600
							addra_db1 <= addra_db1+17'd1;
							addra_db <= addra_db1;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db1>=17'd9599)begin
								addra_db1 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b1100: begin
							addra_db_count <= 17'd9600;//1*9600
							addra_db1 <= addra_db1+17'd1;
							addra_db <= addra_db1;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db1>=17'd9599)begin
								addra_db1 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b1101: begin
							addra_db_count <= 17'd9600;//1*9600
							addra_db1 <= addra_db1+17'd1;
							addra_db <= addra_db1;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db1>=17'd9599)begin
								addra_db1 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b1110: begin
							addra_db_count <= 17'd9600;//1*9600
							addra_db1 <= addra_db1+17'd1;
							addra_db <= addra_db1;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db1>=17'd9599)begin
								addra_db1 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b1111: begin
							addra_db_count <= 17'd38400;//4*9600
							addra_db1 <= addra_db1+17'd1;
							addra_db <= addra_db1;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db1>=17'd9599)begin
								addra_db1 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
					endcase
				end
				6'b000010:
				begin//gewei
					case(sw2)
						4'b0000: begin
							addra_db_count <= 17'd9600;//1*9600
							addra_db2 <= addra_db2+17'd1;
							addra_db <= addra_db2;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db2>=17'd9599)begin
								addra_db2 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b0001: begin
							addra_db_count <= 17'd19200;//2*9600
							addra_db2 <= addra_db2+17'd1;
							addra_db <= addra_db2;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db2>=17'd9599)begin
								addra_db2 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b0010: begin
							addra_db_count <= 17'd28800;//3*9600
							addra_db2 <= addra_db2+17'd1;
							addra_db <= addra_db2;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db2>=17'd9599)begin
								addra_db2 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b0011: begin
							addra_db_count <= 17'd38400;//4*9600
							addra_db2 <= addra_db2+17'd1;
							addra_db <= addra_db2;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db2>=17'd9599)begin
								addra_db2 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b0100: begin
							addra_db_count <= 17'd48000;//5*9600
							addra_db2 <= addra_db2+17'd1;
							addra_db <= addra_db2;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db2>=17'd9599)begin
								addra_db2 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b0101: begin
							addra_db_count <= 17'd57600;//6*9600
							addra_db2 <= addra_db2+17'd1;
							addra_db <= addra_db2;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db2>=17'd9599)begin
								addra_db2 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b0110: begin
							addra_db_count <= 17'd67200;//7*9600
							addra_db2 <= addra_db2+17'd1;
							addra_db <= addra_db2;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db2>=17'd9599)begin
								addra_db2 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b0111: begin
							addra_db_count <= 17'd76800;//8*9600
							addra_db2 <= addra_db2+17'd1;
							addra_db <= addra_db2;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db2>=17'd9599)begin
								addra_db2 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b1000: begin
							addra_db_count <= 17'd86400;//9*9600
							addra_db2 <= addra_db2+17'd1;
							addra_db <= addra_db2;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db2>=17'd9599)begin
								addra_db2 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b1001: begin
							addra_db_count <= 17'd0;//0*9600
							addra_db2 <= addra_db2+17'd1;
							addra_db <= addra_db2;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db2>=17'd9599)begin
								addra_db2 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b1010: begin
							addra_db_count <= 17'd9600;//1*9600
							addra_db2 <= addra_db2+17'd1;
							addra_db <= addra_db2;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db2>=17'd9599)begin
								addra_db2 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b1011: begin
							addra_db_count <= 17'd19200;//2*9600
							addra_db2 <= addra_db2+17'd1;
							addra_db <= addra_db2;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db2>=17'd9599)begin
								addra_db2 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b1100: begin
							addra_db_count <= 17'd28800;//3*9600
							addra_db2 <= addra_db2+17'd1;
							addra_db <= addra_db2;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db2>=17'd9599)begin
								addra_db2 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b1101: begin
							addra_db_count <= 17'd38400;//4*9600
							addra_db2 <= addra_db2+17'd1;
							addra_db <= addra_db2;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db2>=17'd9599)begin
								addra_db2 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b1110: begin
							addra_db_count <= 17'd48000;//5*9600
							addra_db2 <= addra_db2+17'd1;
							addra_db <= addra_db2;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db2>=17'd9599)begin
								addra_db2 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b1111: begin
							addra_db_count <= 17'd76800;//8*9600
							addra_db2 <= addra_db2+17'd1;
							addra_db <= addra_db2;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db2>=17'd9599)begin
								addra_db2 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
					endcase
				end
				6'b000100:
				begin//"."字
					addra_db_count <= 17'd96000;
					addra_db3 <= addra_db3+17'd1;
					addra_db <= addra_db3;
					data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
					if(addra_db3>=17'd9599)begin
						addra_db3 <= 17'd0;
					end
					if(addra_db>=17'd9599)begin
						addra_db <= 17'd0;
					end
				end
				6'b001000:
				begin//shifenwei
					case(sw2)
						4'b0000: begin
							addra_db_count <= 17'd76800;//8*9600
							addra_db4 <= addra_db4+17'd1;
							addra_db <= addra_db4;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db4>=17'd9599)begin
								addra_db4 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b0001: begin
							addra_db_count <= 17'd57600;//6*9600
							addra_db4 <= addra_db4+17'd1;
							addra_db <= addra_db4;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db4>=17'd9599)begin
								addra_db4 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b0010: begin
							addra_db_count <= 17'd28800;//3*9600
							addra_db4 <= addra_db4+17'd1;
							addra_db <= addra_db4;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db4>=17'd9599)begin
								addra_db4 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b0011: begin
							addra_db_count <= 17'd0;//0*9600
							addra_db4 <= addra_db4+17'd1;
							addra_db <= addra_db4;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db4>=17'd9599)begin
								addra_db4 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b0100: begin
							addra_db_count <= 17'd19200;//2*9600
							addra_db4 <= addra_db4+17'd1;
							addra_db <= addra_db4;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db4>=17'd9599)begin
								addra_db4 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b0101: begin
							addra_db_count <= 17'd9600;//1*9600
							addra_db4 <= addra_db4+17'd1;
							addra_db <= addra_db4;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db4>=17'd9599)begin
								addra_db4 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b0110: begin
							addra_db_count <= 17'd38400;//4*9600
							addra_db4 <= addra_db4+17'd1;
							addra_db <= addra_db4;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db4>=17'd9599)begin
								addra_db4 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b0111: begin
							addra_db_count <= 17'd48000;//5*9600
							addra_db4 <= addra_db4+17'd1;
							addra_db <= addra_db4;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db4>=17'd9599)begin
								addra_db4 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b1000: begin
							addra_db_count <= 17'd38400;//4*9600
							addra_db4 <= addra_db4+17'd1;
							addra_db <= addra_db4;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db4>=17'd9599)begin
								addra_db4 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b1001: begin
							addra_db_count <= 17'd48000;//5*9600
							addra_db4 <= addra_db4+17'd1;
							addra_db <= addra_db4;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db4>=17'd9599)begin
								addra_db4 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b1010: begin
							addra_db_count <= 17'd28800;//3*9600
							addra_db4 <= addra_db4+17'd1;
							addra_db <= addra_db4;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db4>=17'd9599)begin
								addra_db4 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b1011: begin
							addra_db_count <= 17'd48000;//5*9600
							addra_db4 <= addra_db4+17'd1;
							addra_db <= addra_db4;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db4>=17'd9599)begin
								addra_db4 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b1100: begin
							addra_db_count <= 17'd19200;//2*9600
							addra_db4 <= addra_db4+17'd1;
							addra_db <= addra_db4;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db4>=17'd9599)begin
								addra_db4 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b1101: begin
							addra_db_count <= 17'd38400;//4*9600
							addra_db4 <= addra_db4+17'd1;
							addra_db <= addra_db4;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db4>=17'd9599)begin
								addra_db4 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b1110: begin
							addra_db_count <= 17'd38400;//4*9600
							addra_db4 <= addra_db4+17'd1;
							addra_db <= addra_db4;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db4>=17'd9599)begin
								addra_db4 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b1111: begin
							addra_db_count <= 17'd48000;//5*9600
							addra_db4 <= addra_db4+17'd1;
							addra_db <= addra_db4;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db4>=17'd9599)begin
								addra_db4 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
					endcase
				end
				6'b010000:
				begin//baifenwei
					case(sw2)
						4'b0000: begin
							addra_db_count <= 17'd0;//0*9600
							addra_db5 <= addra_db5+17'd1;
							addra_db <= addra_db5;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db5>=17'd9599)begin
								addra_db5 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b0001: begin
							addra_db_count <= 17'd9600;//1*9600
							addra_db5 <= addra_db5+17'd1;
							addra_db <= addra_db5;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db5>=17'd9599)begin
								addra_db5 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b0010: begin
							addra_db_count <= 17'd0;//0*9600
							addra_db5 <= addra_db5+17'd1;
							addra_db <= addra_db5;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db5>=17'd9599)begin
								addra_db5 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b0011: begin
							addra_db_count <= 17'd0;//0*9600
							addra_db5 <= addra_db5+17'd1;
							addra_db <= addra_db5;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db5>=17'd9599)begin
								addra_db5 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b0100: begin
							addra_db_count <= 17'd38400;//4*9600
							addra_db5 <= addra_db5+17'd1;
							addra_db <= addra_db5;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db5>=17'd9599)begin
								addra_db5 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b0101: begin
							addra_db_count <= 17'd76800;//8*9600
							addra_db5 <= addra_db5+17'd1;
							addra_db <= addra_db5;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db5>=17'd9599)begin
								addra_db5 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b0110: begin
							addra_db_count <= 17'd28800;//3*9600
							addra_db5 <= addra_db5+17'd1;
							addra_db <= addra_db5;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db5>=17'd9599)begin
								addra_db5 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b0111: begin
							addra_db_count <= 17'd0;//0*9600
							addra_db5 <= addra_db5+17'd1;
							addra_db <= addra_db5;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db5>=17'd9599)begin
								addra_db5 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b1000: begin
							addra_db_count <= 17'd48000;//5*9600
							addra_db5 <= addra_db5+17'd1;
							addra_db <= addra_db5;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db5>=17'd9599)begin
								addra_db5 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b1001: begin
							addra_db_count <= 17'd38400;//4*9600
							addra_db5 <= addra_db5+17'd1;
							addra_db <= addra_db5;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db5>=17'd9599)begin
								addra_db5 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b1010: begin
							addra_db_count <= 17'd57600;//6*9600
							addra_db5 <= addra_db5+17'd1;
							addra_db <= addra_db5;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db5>=17'd9599)begin
								addra_db5 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b1011: begin
							addra_db_count <= 17'd9600;//1*9600
							addra_db5 <= addra_db5+17'd1;
							addra_db <= addra_db5;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db5>=17'd9599)begin
								addra_db5 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b1100: begin
							addra_db_count <= 17'd86400;//9*9600
							addra_db5 <= addra_db5+17'd1;
							addra_db <= addra_db5;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db5>=17'd9599)begin
								addra_db5 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b1101: begin
							addra_db_count <= 17'd38400;//4*9600
							addra_db5 <= addra_db5+17'd1;
							addra_db <= addra_db5;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db5>=17'd9599)begin
								addra_db5 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b1110: begin
							addra_db_count <= 17'd28800;//3*9600
							addra_db5 <= addra_db5+17'd1;
							addra_db <= addra_db5;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db5>=17'd9599)begin
								addra_db5 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
						4'b1111: begin
							addra_db_count <= 17'd0;//0*9600
							addra_db5 <= addra_db5+17'd1;
							addra_db <= addra_db5;
							data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
							if(addra_db5>=17'd9599)begin
								addra_db5 <= 17'd0;
							end
							if(addra_db>=17'd9599)begin
								addra_db <= 17'd0;
							end
						end
					endcase
				end
				6'b100000:
				begin//"dB"字
					addra_db_count <= 17'd105600;
					addra_db6 <= addra_db6+17'd1;
					addra_db <= addra_db6;
					data_db <= {7'b1111111,douta_db,{5{douta_db}},3'b111,{2{douta_db}},2'b11,{4{douta_db}}};
					if(addra_db6>=17'd19199)begin
						addra_db6 <= 17'd0;
					end
					if(addra_db>=17'd19199)begin
						addra_db <= 17'd0;
					end
				end
				default: begin
					addra_db <= addra_db;
				end
			endcase
		end
	end
	/* ************************区域选择******************************* */
	always @(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			data_temp <= {8'd255,8'd255,8'd255};
		end
		else begin
			if(hcount > (thb+2*thd/8) && hcount <= (thb+4*thd/8) && vcount > (tvb) && vcount <= (tvb+tvd/4))
			begin//"误码"字
				data_temp <= data_title;
			end
			else if(hcount > (thb+4*thd/8) && hcount <= (thb+6*thd/8) && vcount > (tvb) && vcount <= (tvb+tvd/4))
			begin//"显示"字
				data_temp <= data_title;
			end
			else if(hcount > (thb) && hcount <= (thb+2*thd/8) && vcount > (tvb+tvd/4) && vcount <= (tvb+2*tvd/4))
			begin //"error:"字
				data_temp <= data_title;
			end
			else if(hcount > (thb+3*thd/10) && hcount <= (thb+4*thd/10) && vcount > (tvb+tvd/4) && vcount <= (tvb+2*tvd/4))
			begin //error_count_shiwan
				data_temp <= data_error;
			end
			else if(hcount > (thb+4*thd/10) && hcount <= (thb+5*thd/10) && vcount > (tvb+tvd/4) && vcount <= (tvb+2*tvd/4))
			begin //error_count_wan
				data_temp <= data_error;
			end
			else if(hcount > (thb+5*thd/10) && hcount <= (thb+6*thd/10) && vcount > (tvb+tvd/4) && vcount <= (tvb+2*tvd/4))
			begin //error_count_qian
				data_temp <= data_error;
			end
			else if(hcount > (thb+6*thd/10) && hcount <= (thb+7*thd/10) && vcount > (tvb+tvd/4) && vcount <= (tvb+2*tvd/4))
			begin //error_count_bai
				data_temp <= data_error;
			end
			else if(hcount > (thb+7*thd/10) && hcount <= (thb+8*thd/10) && vcount > (tvb+tvd/4) && vcount <= (tvb+2*tvd/4))
			begin //error_count_shi
				data_temp <= data_error;
			end
			else if(hcount > (thb+8*thd/10) && hcount <= (thb+9*thd/10) && vcount > (tvb+tvd/4) && vcount <= (tvb+2*tvd/4))
			begin //error_count_ge
				data_temp <= data_error;
			end
			else if(hcount > (thb) && hcount <= (thb+2*thd/8) && vcount > (tvb+2*tvd/4) && vcount <= (tvb+3*tvd/4))
			begin //"SNR:"字
				data_temp <= data_title;
			end
			else if(hcount > (thb+3*thd/10) && hcount <= (thb+4*thd) && vcount > (tvb+2*tvd/4) && vcount <= (tvb++3*tvd/4))
			begin //db_shiwei
				data_temp <= data_db;
			end
			else if(hcount > (thb+4*thd/10) && hcount <= (thb+5*thd) && vcount > (tvb+2*tvd/4) && vcount <= (tvb++3*tvd/4))
			begin //db_gewei
				data_temp <= data_db;
			end
			else if(hcount > (thb+5*thd/10) && hcount <= (thb+6*thd) && vcount > (tvb+2*tvd/4) && vcount <= (tvb++3*tvd/4))
			begin //"."字
				data_temp <= data_db;
			end
			else if(hcount > (thb+6*thd/10) && hcount <= (thb+7*thd) && vcount > (tvb+2*tvd/4) && vcount <= (tvb++3*tvd/4))
			begin //db_shifenwei
				data_temp <= data_db;
			end
			else if(hcount > (thb+7*thd/10) && hcount <= (thb+8*thd) && vcount > (tvb+2*tvd/4) && vcount <= (tvb++3*tvd/4))
			begin //db_baifenwei
				data_temp <= data_db;
			end
			else if(hcount > (thb+8*thd/10) && hcount <= (thb+thd) && vcount > (tvb+2*tvd/4) && vcount <= (tvb++3*tvd/4))
			begin //"db"字
				data_temp <= data_db;
			end
			else begin
				data_temp <= {7'b1111111,6'b0,3'b111,2'b0,2'b11,4'b0};
			end
		end
	end
	/* ********************************* */
	reg [30:0] select = 31'd0;
	always @(posedge clk)begin
		select <= select + 31'd1;
		if(select<=31'd80000000)begin
			data_temp3 <= data_temp2;
		end
		else begin
			data_temp3 <= data_temp;
		end
		if(select == 31'd2000000000)
			select <= 31'd0;
	end
//title_nuaa
title_nuaa title_nuaa(
			.clka(clk),
			.addra(addra_nuaa),
			.douta(douta_nuaa)
);	
//title_qpsk
title_qpsk title_qpsk(
			.clka(clk),
			.addra(addra_qpsk+qpsk_count),
			.douta(douta_qpsk)
);	
//ber_title
title_BER title_BER(
			.clka(clk),
			.addra(addra_title+addra_title_count),
			.douta(douta_title)
);
//ber_error
error_BER error_BER(
			.clka(clk),
			.addra(addra_error+addra_error_count),
			.douta(douta_error)
);
//ber_db
db_BER db_BER(
			.clka(clk),
			.addra(addra_db+addra_db_count),
			.douta(douta_db)
);

endmodule

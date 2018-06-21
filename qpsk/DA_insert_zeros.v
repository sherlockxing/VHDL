`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:35:32 11/12/2015 
// Design Name: 
// Module Name:    DA_insert_zeros 
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
module DA_insert_zeros(		input	clk_40M,
								input	rst_n,
								//input data
								input	[11:0]	in_da_data0,
								input	[11:0]	in_da_data1,
								//output data
								output	[11:0]	out_da_data0,
								output	[11:0]	out_da_data1
);
	reg		[11:0]		out_da_data0;
	reg		[11:0]		out_da_data1;
	reg   	[11:0]  	temp0,temp1;
	reg   	[3:0]  		count1 = 4'd0;
	reg	  	[3:0]		count2 = 4'd0;
 
	always @(posedge clk_40M or negedge rst_n)begin
		if(~rst_n)begin
			temp0 <= 0;
			temp1 <= 0;
			count1 = 0;
		end
		else begin	
			count1 = count1 +1;
			if(count1 == 4'd4)begin
				temp0 <= in_da_data0;
				temp1 <= in_da_data1;
				count1 = 0;
			end
		end
	end

	always @(posedge clk_40M or negedge rst_n)begin
		if(~rst_n)begin
			out_da_data0 <= 0;
			out_da_data1 <= 0;
			count2 = 0;
		end
		else begin
			count2 = count2+1;
			if(count2==4'd4)begin 
				out_da_data0 <= temp0;
				out_da_data1 <= temp1;
				count2 = 0;
			end
			else begin
				out_da_data0 <= 0;
				out_da_data1 <= 0;
			end
		end 
	end
	
endmodule

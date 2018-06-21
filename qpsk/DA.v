`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:22:38 08/20/2013 
// Design Name: 
// Module Name:    DDS_DA 
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
module DA_out(
				dac_clk,
				reset_n,
				in_da0_data,
				in_da1_data,
//				out_da0_clk,
//				out_da1_clk,
				out_da0_wr,
				out_da1_wr,
				out_da0_data,
				out_da1_data 
    );

parameter Ndata=12;

input dac_clk;
input reset_n;
input  [11:0] in_da0_data;
input  [11:0] in_da1_data;
//output out_da0_clk,out_da1_clk ,
output out_da0_wr;
output out_da1_wr;
output [Ndata-1:0] out_da0_data;
output [Ndata-1:0] out_da1_data;

//wire out_da0_clk,out_da1_clk ,out_da0_wr,out_da1_wr;
//assign out_da0_clk=clk1;
//assign out_da1_clk=clk1;
assign out_da0_wr =dac_clk;
assign out_da1_wr =dac_clk;

reg [Ndata-1:0] out_da0_data;
reg [Ndata-1:0] out_da1_data;

always @ (posedge dac_clk)//modify
begin
	if(!reset_n)
		begin
			out_da0_data<=12'd0;
			out_da1_data<=12'd0;
		end
	else
		begin
			out_da0_data<={~in_da0_data[11],in_da0_data[10:0]};
			out_da1_data<={~in_da1_data[11],in_da1_data[10:0]};
		end
end
endmodule
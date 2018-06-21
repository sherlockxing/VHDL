`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:39:48 02/20/2012 
// Design Name: 
// Module Name:    bake_m_gen 
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
module bake_m_gen(				clk_fs,			//时钟频率10MHz
								rst_n,			//复位
								bake_m_seq,		//带13位巴克码的m序列
								bake			//13位巴克码
);
	input                   	clk_fs;
	input                   	rst_n;
	output reg   	[1:0]     	bake_m_seq 	= 2'b0;
	output reg		[1:0]		bake		= 2'b0;
  
	reg				[9:0]     	flow = 10'b0000000001;  
	reg				[3:0]    	count = 0;
	reg				[11:0]		count2 = 0;
	/* ************************************************* */
	always@(posedge clk_fs or negedge rst_n)begin
		if(~rst_n)begin
			flow <= 10'b0000000001;
			bake_m_seq 	<= 2'b0;
			bake		<= 2'b0;	   	
			count <= 0;
			count2 <= 0;
		end
		else begin  
			count <= count+1;
			if(count%2==0)begin
				count2 <=count2+1;
				if (count2==12'h40D)begin
					count2 <= 1;
					flow  <= 10'b0000000001;
				end
				else begin 
					case(count2)
						12'h001:begin
							bake_m_seq <= 2'b11;
							bake		<= 2'b11;
						end
						12'h002:begin
							bake_m_seq <= 2'b11;
							bake		<= 2'b11;
						end
						12'h003:begin
							bake_m_seq <= 2'b11;
							bake		<= 2'b11;
						end
						12'h004:begin
							bake_m_seq <= 2'b11;
							bake		<= 2'b11;
						end
						12'h005:begin
							bake_m_seq <= 2'b11;
							bake		<= 2'b11;
						end
						12'h006:begin
							bake_m_seq <= 2'b01;
							bake		<= 2'b01;
						end
						12'h007:begin
							bake_m_seq <= 2'b01;
							bake		<= 2'b01;
						end
						12'h008:begin
							bake_m_seq <= 2'b11;
							bake		<= 2'b11;
						end
						12'h009:begin
							bake_m_seq <= 2'b11;
							bake		<= 2'b11;
						end
						12'h00A:begin
							bake_m_seq <= 2'b01;
							bake		<= 2'b01;
						end
						12'h00B:begin
							bake_m_seq <= 2'b11;
							bake		<= 2'b11;
						end
						12'h00C:begin
							bake_m_seq <= 2'b01;
							bake		<= 2'b01;
						end
						12'h00D:begin
							bake_m_seq <= 2'b11;
							bake		<= 2'b11;
						end
						
					endcase
					if(count2>=12'h00E)begin
						bake_m_seq[0] <= 1;
						bake_m_seq[1] <= flow[0];
						bake		<= 2'b0;
						flow[8:0] <=  flow[9:1];
						flow[9] <= flow[7] ^ flow[0];
					end
				end
			end
		end
	 end
endmodule

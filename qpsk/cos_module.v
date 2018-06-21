`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:58:12 03/04/2012 
// Design Name: 
// Module Name:    cos_module 
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
module cos_module(		clk_fs,			//时钟频率为10MHz
						rst_n,			//复位
						omega_n_I,		//I支路角频率
						omega_n_Q,		//Q支路角频率
						phi_n_I,		//I支路相位
						phi_n_Q,		//Q支路相位
						data_I,			//I支路输出
						data_Q			//Q支路输出
);

	input 				  	clk_fs;
	input 				  	rst_n;
	input 		[13:0]  	omega_n_I; //can be lowered
	input 		[13:0]  	omega_n_Q; //can be lowered
	input 		[13:0]  	phi_n_I;
	input 		[13:0]  	phi_n_Q;
	output reg	[15:0]  	data_I;
	output reg	[15:0]  	data_Q;

	reg 		[13:0]  	phi_I;
	reg 		[9:0]   	addr_rom_I;
	reg 		[11:0]  	addr_I;
	reg 		[11:0]  	addr_reg_I;
	reg 		[11:0]  	addr_reg2_I;
	wire 		[14:0]  	data_rom_I;
	reg 	 		 		state_I = 0;
	//reg		 		 		c_I = 0;

	reg 		[13:0]  	phi_Q;
	reg 		[9:0]   	addr_rom_Q;
	reg 		[11:0]  	addr_Q;
	reg 		[11:0]  	addr_reg_Q;
	reg 		[11:0]  	addr_reg2_Q;
	wire 		[14:0]  	data_rom_Q;
	reg 	 				state_Q = 0;
	//reg		 			  	c_Q = 0;

cos_rom_table cos_rom_I(
						.clka(clk_fs),
						.addra(addr_rom_I),
						.douta(data_rom_I)
						);
						
cos_rom_table cos_rom_Q(
						.clka(clk_fs),
						.addra(addr_rom_Q),
						.douta(data_rom_Q)
						);
						
	always@(posedge clk_fs or negedge rst_n)begin
		if(!rst_n)begin
			state_I 	<= 0;
			phi_I   	<= 0;
			data_I  	<= 0;
			addr_reg2_I <= 0;
			addr_reg_I 	<= 0;
			addr_rom_I 	<= 0;
		end
		else begin
			if(state_I == 0)begin
				state_I <= 1;
				phi_I 	<= phi_n_I;
				data_I 	<= 0;
			end
			else if(state_I == 1)begin
				phi_I 		<= phi_I + omega_n_I;
				addr_reg2_I <= addr_reg_I;
				addr_reg_I 	<= addr_I;
				addr_I 		<= phi_I[13:2];
				
				if(addr_I <= 1023)
					addr_rom_I <= addr_I;
				else if(addr_I > 1023 && addr_I <= 2047)
					addr_rom_I <= 2047-addr_I;
				else if(addr_I > 2047 && addr_I <= 3071)
					addr_rom_I <= addr_I-2048;
				else if(addr_I > 3071)
					addr_rom_I <= 4095-addr_I;
					
				if(addr_reg2_I <= 1023)
					data_I <= {1'b0,data_rom_I};
				else if(addr_reg2_I > 1023 && addr_reg2_I <= 2047)
					data_I <= {1'b1,~data_rom_I+1};	
				else if(addr_reg2_I > 2047 && addr_reg2_I <= 3071)
					data_I <= {1'b1,~data_rom_I+1};	
				else if(addr_reg2_I > 3071)
					data_I <= {1'b0,data_rom_I};
			end
		end
	end

	always@(posedge clk_fs)begin
		if(!rst_n)begin
			state_Q <= 0;
			phi_Q 	<= 0;
			data_Q 	<= 0;
			addr_reg2_Q <= 0;
			addr_reg_Q 	<= 0;
			addr_rom_Q 	<= 0;
		end
		else begin
			if(state_Q == 0)begin
				state_Q <= 1;
				phi_Q 	<= phi_n_Q;
				data_Q 	<= 0;
			end
			
			else if(state_Q == 1)begin
				phi_Q 		<= phi_Q + omega_n_Q;
				addr_reg2_Q <= addr_reg_Q;
				addr_reg_Q 	<= addr_Q;
				addr_Q 	<= phi_Q[13:2];
				
				if(addr_Q <= 1023)
					addr_rom_Q <= 1023 - addr_Q;
				else if(addr_Q > 1023 && addr_Q <= 2047)
					addr_rom_Q <= addr_Q - 1024;
				else if(addr_Q > 2047 && addr_Q <= 3071)
					addr_rom_Q <= 3071 - addr_Q;
				else if(addr_Q > 3071)
					addr_rom_Q <= addr_Q - 3072;
					
				if(addr_reg2_Q <= 1023)
					data_Q <= {1'b0,data_rom_Q};
				else if(addr_reg2_Q > 1023 && addr_reg2_Q <= 2047)
					data_Q <= {1'b0,data_rom_Q};	
				else if(addr_reg2_Q > 2047 && addr_reg2_Q <= 3071)
					data_Q <= {1'b1,~data_rom_Q+1};	
				else if(addr_reg2_Q > 3071)
					data_Q <= {1'b1,~data_rom_Q+1};
			end
		end
	end	

endmodule


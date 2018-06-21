`timescale 1ns/1ps
module lut_rom_cdce62002_config(i_addr, o_data);
 
input [2 : 0] i_addr;
output [31 : 0] o_data;
reg [31 : 0] o_data;

always @(*)
begin
	 case(i_addr)
		 3'd0: o_data = 32'h40080000;
		 3'd1: o_data = 32'h0E400229;
		 3'd2: o_data = 32'h8006D1C1;
		 3'd3: o_data = 32'h40180000;
		 3'd4: o_data = 32'hf8000000;
		 3'd5: o_data = 32'h40080000;
		 default: o_data = 32'h00000;
	 endcase
end

endmodule
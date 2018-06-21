`timescale 1ns/1ps
module lut_rom_afe7225_config(i_addr, o_data);
 
input [5 : 0] i_addr;
output [19 : 0] o_data;
reg [19 : 0] o_data;

always @(*)
begin
	 case(i_addr)
     6'd0 : o_data = 20'h00002;
     6'd1 : o_data = 20'h00000;
     6'd2 : o_data = 20'h30B80;
     6'd3 : o_data = 20'h30C04;
     6'd4 : o_data = 20'h32102;
     6'd5 : o_data = 20'h32240;
     6'd6 : o_data = 20'h33A82;
     6'd7 : o_data = 20'h11D08;
     6'd8 : o_data = 20'h20A0C;
     6'd9 : o_data = 20'h23D84;
     6'd10: o_data = 20'h10606;
     6'd11: o_data = 20'h16503;
     6'd12: o_data = 20'h1174C;
     6'd13: o_data = 20'h118CC;
     6'd14: o_data = 20'h119CC;
     6'd15: o_data = 20'h11ACC;
     6'd16: o_data = 20'h17A0C;
     6'd17: o_data = 20'h17466;
     6'd18: o_data = 20'h17566;
     6'd19: o_data = 20'h17666;
     6'd20: o_data = 20'h17766;
     6'd21: o_data = 20'h16EF0;
     6'd22: o_data = 20'h16B10;
     6'd23: o_data = 20'h30B80;
     6'd24: o_data = 20'h30C04;
     6'd25: o_data = 20'h32102;
     6'd26: o_data = 20'h32240;
     6'd27: o_data = 20'h33A82;
     6'd28: o_data = 20'h11D08;
     6'd29: o_data = 20'h20A0C;
     6'd30: o_data = 20'h23D84;
     6'd31: o_data = 20'h10606;
     6'd32: o_data = 20'h16503;
     6'd33: o_data = 20'h1174C;
     6'd34: o_data = 20'h118CC;
     6'd35: o_data = 20'h119CC;
     6'd36: o_data = 20'h11ACC;
     6'd37: o_data = 20'h17A0C;
     6'd38: o_data = 20'h17466;
     6'd39: o_data = 20'h17566;
     6'd40: o_data = 20'h17666;
     6'd41: o_data = 20'h17766;
     6'd42: o_data = 20'h16EF0;
     6'd43: o_data = 20'h16B10;
		 default: o_data = 20'h00000;
		 
	 endcase
end

endmodule

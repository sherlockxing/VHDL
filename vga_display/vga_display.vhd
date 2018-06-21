----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:45:48 04/20/2018 
-- Design Name: 
-- Module Name:    vga_display - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.std_logic_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_display is
port(
		i_clk			 : in std_logic;
		i_rst			 :	in std_logic;
		i_start		 : in std_logic;
		o_vga_vsy	 : out std_logic;
		o_vga_hsy    : out std_logic;
		o_vga_red    : out std_logic_vector(4 downto 0);
		o_vga_green  : out std_logic_vector(4 downto 0);
		o_vga_blue   : out std_logic_vector(4 downto 0)
);
end vga_display;

architecture Behavioral of vga_display is

	signal 	cnt_hsy		 : std_logic_vector(10 downto 0);
	signal 	cnt_vsy		 : std_logic_vector(9 downto 0);
	signal 	data_valid1  : std_logic;
	signal 	data_valid2  : std_logic;
	signal 	data_valid3  : std_logic;
	
	signal 	cnt_hsy_next : std_logic_vector(10 downto 0);
	signal 	cnt_vsy_next : std_logic_vector(9 downto 0);
--	signal o_vga_vsy	  :  std_logic;
--	signal o_vga_hsy    :  std_logic;
--	signal o_vga_red    :  std_logic_vector(4 downto 0);
--	signal o_vga_green  :  std_logic_vector(4 downto 0);
--	signal o_vga_blue   :  std_logic_vector(4 downto 0);
	
   constant hsync_e      : integer := 1344;         	
	constant hsync_a      : integer := 136;
   constant hsync_b      : integer := 160;	
	constant hsync_c      : integer := 1024;
   constant hsync_d      : integer := 24;
   
   constant vsync_s      : integer := 806;	
	constant vsync_o      : integer := 6;
   constant vsync_p      : integer := 29;		
	constant vsync_q      : integer := 768;
   constant vsync_r      : integer := 3;
   constant vsync_q_div3 : integer := 256;  --768/3

begin

hsy:process(i_clk)
begin
	if (i_clk'EVENT and i_clk='1') then
			if (cnt_hsy = "10100111111") then
				cnt_hsy<="00000000000";
			else
				cnt_hsy<=cnt_hsy+'1';
			end if;
	else
		cnt_hsy<=cnt_hsy;
	end if;
end process;

vsy:process(i_clk)
begin
	if(i_clk'EVENT and i_clk='1') then
		if(cnt_vsy="1100100101") then
			cnt_vsy<="0000000000";
		else
			if(cnt_hsy = "10100111111") then
				cnt_vsy<=cnt_vsy+'1';
			else
				cnt_vsy<=cnt_vsy;
			end if;
		end if;
	else
		cnt_vsy<=cnt_vsy;
	end if;
end process;

valid1_en:process(cnt_hsy)
begin
	if(((cnt_hsy >= hsync_a + hsync_b - 1) and (cnt_hsy < hsync_e - hsync_d - 1))
	and (cnt_vsy >= vsync_o + vsync_p - 1 and cnt_vsy <= vsync_o + vsync_p + vsync_q_div3 - 1)) then
	data_valid1<='1';
	else
	data_valid1<='0';
	end if;
end process;

valid2_en:process(cnt_hsy)
begin
	if((cnt_hsy >= hsync_a + hsync_b - 1 and cnt_hsy < hsync_e - hsync_d - 1)
	and (cnt_vsy >= vsync_o + vsync_p + vsync_q_div3 - 1 and cnt_vsy <= vsync_s - vsync_r - vsync_q_div3 - 1)) then
	data_valid2<='1';
	else
	data_valid2<='0';
	end if;
end process;
	
valid3_en:process(cnt_hsy)
begin
	if((cnt_hsy >= hsync_a + hsync_b - 1 and cnt_hsy < hsync_e - hsync_d - 1)
	and (cnt_vsy >= vsync_s - vsync_r - vsync_q_div3 - 1 and cnt_vsy <= vsync_s - vsync_r - 1)) then
	data_valid3<='1';
	else
	data_valid3<='0';
	end if;
end process;

disp_red:process(cnt_hsy)
begin
	if(data_valid1 = '1') then
	o_vga_red<="11111";
	else
	o_vga_red<="00000";
	end if;
end process;

disp_green:process(cnt_hsy)
begin
	if(data_valid2 = '1') then
	o_vga_green<="11111";
	else
	o_vga_green<="00000";
	end if;
end process;

disp_blue:process(cnt_hsy)
begin
	if(data_valid3 = '1') then
	o_vga_blue<="11111";
	else
	o_vga_blue<="00000";
	end if;
end process;
			
end Behavioral;


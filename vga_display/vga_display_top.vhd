----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:44:34 04/20/2018 
-- Design Name: 
-- Module Name:    vga_display_top - Behavioral 
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

entity vga_display_top is
port(
	I_clk 		 : in std_logic;
	I_rst			 : in std_logic;
	I_start		 : in std_logic;
	O_vga_vsy	 : out std_logic;
	O_vga_hsy    : out std_logic;
	O_vga_red    : out std_logic_vector(4 downto 0);
	O_vga_green  : out std_logic_vector(4 downto 0);
	O_vga_blue   : out std_logic_vector(4 downto 0)
);
end vga_display_top;

architecture Behavioral of vga_display_top is

signal clk65:std_logic;

component vga_display_clk_rst is
port(
		CLK_IN1           : in     std_logic;
		-- Clock out ports
		CLK_OUT1          : out    std_logic;
		-- Status and control signals
		RESET             : in     std_logic
);
end component;

component vga_display is
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
end component;

begin
		clock:vga_display_clk_rst
		port map(
			CLK_IN1 => I_clk,
			CLK_OUT1 => clk65,
			RESET => I_rst
		);
		
		disp:vga_display
		port map(
			i_clk => clk65,
			i_rst => I_rst,
			i_start => I_start,
			o_vga_vsy => O_vga_vsy,
			o_vga_hsy => O_vga_hsy,
			o_vga_red => O_vga_red,
			o_vga_green => O_vga_green,
			o_vga_blue => O_vga_blue
		);

end Behavioral;


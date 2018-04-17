@@ -0,0 +1,80 @@
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:51:24 04/14/2018 
-- Design Name: 
-- Module Name:    light_flow_top - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity light_flow_top is
port(
		I_sys_clk_50M:in std_logic;
		I_start:in std_logic;
		I_stop:in std_logic;
		I_sys_rst_50M:IN STD_LOGIC;
		led_dout :out std_logic_vector(7 downto 0)
);
end light_flow_top;

architecture Behavioral of light_flow_top is
signal clk10:std_logic;
component  light_flow_clk_rst is
port(
		CLK_IN1           : in     std_logic;
		CLK_OUT1          : out    std_logic);
	--ESET             : in     std_logic;
--LOCKED            : out    std_logic);
end component;

component light_flow is
port( clk10:in std_logic;
		I_start:in std_logic;
		I_stop:in std_logic;
		I_sys_rst_50M:in std_logic;
		--O_row0_en:in std_logic;
		led_dout :out std_logic_vector(7 downto 0));
end component;

begin
		c:light_flow_clk_rst 
		port map
		(CLK_IN1 =>I_sys_clk_50M,
		CLK_OUT1=>clk10
		
		);
		
		u:light_flow 
		port map
		(clk10 =>clk10,
	I_start=>I_start,
	I_stop=>I_stop,
	I_sys_rst_50M=>I_sys_rst_50M,
	
	led_dout=>led_dout);


end Behavioral;

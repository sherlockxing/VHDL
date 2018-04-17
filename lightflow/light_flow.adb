----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:51:00 04/14/2018 
-- Design Name: 
-- Module Name:    light_flow - Behavioral 
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

entity light_flow is
port( clk10:in std_logic;
		I_start:in std_logic;
		I_stop:in std_logic;
		I_sys_rst_50M:in std_logic;
		--O_row0_en:in std_logic;
		led_dout :out std_logic_vector(7 downto 0));
end light_flow;

architecture Behavioral of light_flow is
shared variable cnt2:integer range 0 to 9999999;
signal O_led_out:std_logic_vector(7 downto 0);
signal clk_1Hz:std_logic;


begin



process (clk10)
begin 
	if(clk10'EVENT AND clk10='1') THEN
		if(cnt2=9999999) then
		cnt2:=0;
		clk_1Hz<=not clk_1Hz;
		else 
		cnt2:=cnt2+1;
		end if;
	end if;
end process;

process(clk_1Hz,I_sys_rst_50M)
begin
   if(I_sys_rst_50M='0') then
	O_led_out<="00010000";	
	elsif(clk_1Hz'EVENT AND clk_1Hz='1' ) then
	  if(I_start='1' and I_stop='0')then
     O_led_out<=O_led_out(6 downto 0)&O_led_out(7);
	  else
	  O_led_out<=O_led_out;
	  end if;
	end if;
end process;
led_dout<=O_led_out;
end Behavioral;


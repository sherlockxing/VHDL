----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:43:35 04/14/2018 
-- Design Name: 
-- Module Name:    light_flow_clk_rst - Behavioral 
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

entity light_flow_clk_rst is
port(
		CLK_IN1           : in     std_logic;
		CLK_OUT1          : out    std_logic);
--		RESET             : in     std_logic;
--		LOCKED            : out    std_logic);
end light_flow_clk_rst;

architecture Behavioral of light_flow_clk_rst is
component pll
port
 (-- Clock in ports
  CLK_IN1           : in     std_logic;
  -- Clock out ports
  CLK_OUT1          : out    std_logic;
  
  RESET             : in     std_logic;
  LOCKED            : out    std_logic
 );
end component;

signal RESET1:std_logic;
signal LOCKED1:std_logic;

begin
clk10m : pll
  port map
   (-- Clock in ports
    CLK_IN1 => CLK_IN1,
    -- Clock out ports
    CLK_OUT1 => CLK_OUT1,
    
    RESET  => RESET1,
    LOCKED => LOCKED1);

end Behavioral;



-- COMP_TAG_END ------ End COMPONENT Declaration ------------
-- The following code must appear in the VHDL architecture
-- body. Substitute your own instance name and net names.
------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG

-- INST_TAG_END ------ End INSTANTIATION Template ------------



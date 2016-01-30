----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:04:01 01/14/2016 
-- Design Name: 
-- Module Name:    nexys2 - Behavioral 
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

entity nexys2 is
    Port ( sw : in  STD_LOGIC_VECTOR (7 downto 0);
           btn : in  STD_LOGIC_VECTOR (3 downto 0);
           led : out  STD_LOGIC_VECTOR (7 downto 0));
end nexys2;

architecture Behavioral of nexys2 is

begin
				-- Buttons may be reversed; fix the ucf file if so
led <= 	 sw(0) & sw(7 downto 1) when btn(3) = '1' else	--rotate right one position
				(not sw) when btn(2) = '1' else
				sw(0)& sw(1)& sw(2)& sw(3)& sw(4)& sw(5)& sw(6)& sw(7) when btn(1) = '1' else
				sw(3 downto 0) & sw(7 downto 4) when btn(0) = '1' else
				sw;


end Behavioral;


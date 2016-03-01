----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:02:13 01/23/2016 
-- Design Name: 
-- Module Name:    homeworkch13 - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dec_counter is
	port(
		clk, reset : in std_logic;
		en: in std_logic;
		q: out std_logic_vector(3 downto 0);
		pulse: out std_logic
	);
end dec_counter;

architecture up_arch of dec_counter is
	signal r_reg: unsigned(3 downto 0);
	signal r_next: unsigned(3 downto 0);
	constant TEN: integer := 10;
begin

-- register
process(clk,reset)
begin
	if(reset='1') then
		r_reg <= (others=>'0');
	elsif(clk'event and clk='1') then
		r_reg <= r_next;
	end if;
end process;

-- next-state logic
process(en,r_reg)
begin
	r_next <= r_reg;
	if(en='1') then
		if r_reg=(TEN-1) then
			r_next <= (others=>'0');
		else
			r_next <= r_reg + 1;
		end if;
	end if;
end process;

-- output logic
q <= std_logic_vector(r_reg);
pulse <= '1' when r_reg=(TEN-1) else
			'0';
			
end up_arch;


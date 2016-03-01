-- Colt Thomas -- Problem 9.2 --
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity hw_9_2 is
	port(
		clk: in std_logic;
		y: out std_logic
	);
end hw_9_2;

architecture Behavioral of hw_9_2 is
	signal r_reg,r_next: unsigned(3 downto 0);
begin

	process(clk)
	begin
		if(clk'event and clk='1') then
			r_reg <= r_next;
		end if;
	end process;

	-- Next state logic
	r_next <= r_reg + 1 when (r_reg<16) else
				 "0000";
				 
	-- Output Logic
	y <= std_logic_vector(r_reg);
end Behavioral;


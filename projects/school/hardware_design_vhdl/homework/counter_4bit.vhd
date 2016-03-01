-- Colt Thomas -- Problem 8.7
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity counter_4bit is
	port(
		clk: in std_logic;
		d: in std_logic_vector(3 downto 0);
		q: out std_logic_vector(3 downto 0)
	);
end counter_4bit;

architecture Behavioral of counter_4bit is
	signal r_reg: unsigned(3 downto 0);
	signal r_next: unsigned(3 downto 0);
begin

	-- Register
	process(clk)
	begin
		if(clk'event and clk='1') then
			r_reg <= r_next;
		end if;
	end process;
	-- Next State Logic
	r_next <= r_reg + 1 when (r_reg>"0010" and r_reg<"1100") else
				 "0011";
	-- Output logic
	q <=std_logic_vector(r_reg);
end Behavioral;


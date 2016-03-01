-- Colt Thomas problem 8.5 - Universal Shift Register
--Consider a 4-bit counter that counts from 3 ("001 1") to 12 ("1 100") and then wraps
--around. If the counter enters an unused state (such as "0000") because of noise, it will
--restart from "001 1" at the next rising edge of the clock.
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity universal_sf is
	port(
		clk,reset: in std_logic;
		ctrl: in std_logic_vector(1 downto 0);
		d: in std_logic_vector(7 downto 0);
		q: out std_logic
	);
	
end universal_sf;

architecture Behavioral of universal_sf is
	signal r_reg: std_logic_vector(7 downto 0);
	signal r_next: std_logic_vector(7 downto 0);
begin
	-- register
	process(clk,reset)
	begin
		if(reset='1') then
			r_reg <=(others=>'0');
		elsif(clk'event and clk='1') then
			r_Reg <= r_next;
		end if;	
	end process;
	-- next-state logic
	with ctrl select
		r_next <= 	r_Reg when "00", -- pause
						d(3) & r_reg(7 downto 1) when "10", --shift right
						d when others; -- load
	-- output logic
	q <= r_reg(0);					
end Behavioral;


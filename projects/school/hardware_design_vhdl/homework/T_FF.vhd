-- Colt Thomas -- T FF with synchonous reset
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity T_FF is
	port(
		clk: in std_logic;
		reset, en: in std_logic;
		t: in std_logic;
		q: out std_logic
	);
end T_FF;

architecture Behavioral of T_FF is
	signal q_reg: std_logic;
	signal q_next: std_logic;
begin
	-- D Flip Flop
	process(clk,reset)
	begin
		if (clk'event and clk='0') then
			if(reset='1') then
				q_Reg<='0';
			elsif(en='1') then
				q_reg <= q_next;
			end if;
		end if;
	end process;
	-- next-state logic
	q_next <= q_reg when t='0' else
				 not(q_reg);
	-- output logic
	q <= q_reg;
end Behavioral;


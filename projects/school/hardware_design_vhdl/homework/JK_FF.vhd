-- Colt Thomas -- Problem 8.3
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity JK_FF is
	port(
		clk: in std_logic;
		j: in std_logic;
		k: in std_logic;
		q: out std_logic
	);
end JK_FF;

architecture Behavioral of JK_FF is
signal q_next: std_logic;
signal q_out: std_logic;
begin
	-- Register
	d_ff: entity work.D_FF(arch)
		port map(d=>q_next,clk=>clk,q=>q_out);

	-- Output logic
	q_next <= 	q_out when (j='0' and k='0') else
					'0' when (j='0' and k='1') else
					'1' when (j='1' and k='0')else
					not q_out;

	q<=q_out;
end Behavioral;


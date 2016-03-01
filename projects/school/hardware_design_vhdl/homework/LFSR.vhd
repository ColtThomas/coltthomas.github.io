-- Colt Thomas -- homework problem 9.5
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LFSR is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           q : out  STD_LOGIC_VECTOR (3 downto 0));
end LFSR;

architecture Behavioral of LFSR is
	signal r_Reg,r_next:std_logic_vector(3 downto 0);
	signal fb: std_logic;
	constant SEED: std_logic_vector(3 downto 0) := "0001";
begin
	-- register
	process(clk,reset)
	begin
		if (reset='1') then
			r_reg <= SEED;
		elsif (clk'event and clk='1') then
			r_reg <= r_next;
		end if;
	end process;
	
	-- next-state logic
	fb <= r_reg(1) xor r_reg(0);
	r_next <= fb & r_reg(3 downto 1);
	
	-- output logic
	-- When we return not r_reg, we have the possibility of having 0000 as an output and 
	-- at the same time exclude 1111
	q <= not r_reg; 

end Behavioral;


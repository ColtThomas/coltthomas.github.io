-- Homework problem 13.2 
-- Note that I have two architectures on this for the 
-- sake of space
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all ;

entity mod_n_counter is
    generic(
		N: natural;
		WIDTH: natural
	);
	 Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           en : in  STD_LOGIC;
           q : out  unsigned(WIDTH-1 downto 0) :=(others=>'0');
           pulse : out  STD_LOGIC);
end mod_n_counter;

architecture Behavioral of mod_n_counter is
	signal r_reg: unsigned(WIDTH-1 downto 0):= (others=>'0');
	signal r_next: unsigned(WIDTH-1 downto 0):= (others=>'0');
begin
-- register
process(clk,reset)
begin
	if(reset='1') then 
		r_Reg <= (others=>'0');
	elsif(clk'event and clk='1') then
		r_reg <= r_next;
	end if;
end process;

--next state logic
process(en,r_Reg)
begin
	r_next <= r_reg;
	if(en='1') then
		if r_reg=(N-1) then
			r_next <= (others=>'0');
		else
			r_next <= r_reg + 1;
		end if;
	end if;
end process;
-- output logic
q <= r_reg;
pulse <= '1' when r_reg=(N-1) else
			'0';
		
end Behavioral;

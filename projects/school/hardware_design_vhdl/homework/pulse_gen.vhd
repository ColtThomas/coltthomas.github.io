-- Colt Thomas -- Problem 8.10

-- For this problem we are writing code that assumes a 50hz clock.
-- We are to generate a 1hz pulse, or a pulse every 1 second.  This
-- requires 50,000,000 clock periods to pass before hitting 1 second. 
-- Since we are designing for a 50% duty cycle, and we want the pulse
-- to change every half second, we need a counter that goes up to 
-- 12,500,000 and that requires 26 bits.
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity prog_counter is

	generic(
		N: natural := 12500000;
		WIDTH: natural := 24
	);
	 Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           q : out  STD_LOGIC_VECTOR((WIDTH-1) downto 0)
           );
end prog_counter;

architecture variable_arch of prog_counter is
	signal r_reg:unsigned(width-1 downto 0);
	signal pulse: std_logic;
begin
	process(clk,reset)
		variable q_tmp: unsigned(3 downto 0);
	begin
		if(reset='1') then
			r_reg <= (others=>'0');
			pulse <= '0';
		elsif(clk'event and clk='1') then
			q_tmp := r_reg +1;
			if(q_tmp=to_unsigned(N,WIDTH)) then
				r_Reg <= (others=>'0');
				pulse <= not pulse;
			else
				r_reg<= q_tmp;
			end if;
		end if;
	end process;
	q<= std_logic_vector(r_reg);
end variable_arch;

-- Homework problem 14.1 round 2 using entity instantiation syntax
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


--architecture up_arch of dec_counter_a is
--	signal r_reg: unsigned(3 downto 0);
--	signal r_next: unsigned(3 downto 0);
--	constant TEN: integer := 10;
--begin
--
---- register
--process(clk,reset)
--begin
--	if(reset='1') then
--		r_reg <= (others=>'0');
--	elsif(clk'event and clk='1') then
--		r_reg <= r_next;
--	end if;
--end process;
--
---- next-state logic
--process(en,r_reg)
--begin
--	r_next <= r_reg;
--	if(en='1') then
--		if r_reg=(TEN-1) then
--			r_next <= (others=>'0');
--		else
--			r_next <= r_reg + 1;
--		end if;
--	end if;
--end process;
--
---- output logic
--q <= std_logic_vector(r_reg);
--pulse <= '1' when r_reg=(TEN-1) else
--			'0';
--			
--end up_arch;


entity thousand_counter is
   
	 Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           en : in  STD_LOGIC;
           q_ten, q_one, q_hundred: out  STD_LOGIC_VECTOR(3 downto 0);
           p1000: out  STD_LOGIC);
end thousand_counter;

architecture vhdl_93_arch of thousand_counter is
	signal p_one, p_ten, p_hundred: std_logic;
begin
	one_digit: entity work.dec_counter(up_arch)
		port map (clk=>clk, reset=>reset,en=>en, pulse=>p_one, q=>q_one);
	ten_digit: entity work.dec_counter(up_arch)
		port map (clk=>clk, reset=>reset, en=>p_one, pulse=>p_ten,q=>q_ten);
	hundred_digit: entity work.dec_counter(up_arch)
		port map (clk=>clk, reset=>reset, en=>p_ten, pulse=>p_hundred,q=>q_hundred);
	p1000<= p_one and p_ten and p_hundred;
end vhdl_93_arch;


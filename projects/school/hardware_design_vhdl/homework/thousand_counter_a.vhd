-- Homework problem 13.1
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity thousand_counter_a is
	port(
		clk, reset: in std_logic;
		en: in std_logic;
		q_hundred, q_ten, q_one : out std_logic_vector(4 downto 0);
		p1000: out std_logic
	);
end thousand_counter_a;

architecture Behavioral of thousand_counter_a is
	component dec_counter
	port(
		clk, reset: in std_logic;
		en: in std_logic;
		q: out std_logic_vector(3 downto 0);
		pulse: out std_logic
	);
	end component;
	signal p_one, p_ten, p_hundred: std_logic;
begin
	one_digit: dec_counter
		port map (clk=>clk, reset=>reset, en=>en,pulse=>p_one,q=>q_one);
	ten_digit: dec_counter
		port map (clk=>clk, reset=>reset,en=>p_one,pulse=>p_ten,q=>q_ten);
	hundred_digit: dec_counter
		port map (clk=>clk, reset=>reset,en=>p_ten,pulse=>p_hundred,q=>q_hundred);
	p1000 <= p_one and p_ten and p_hundred;


end Behavioral;


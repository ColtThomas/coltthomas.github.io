----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:51:19 01/25/2016 
-- Design Name: 
-- Module Name:    counter - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity modifiable_counter is
	Port ( clk, reset: in std_logic;
		en: in std_logic;
		q_hundred, q_ten, q_one : out std_logic_vector(4 downto 0)
			  );
end modifiable_counter;

architecture generic_arch of modifiable_counter is
	component mod_n_counter
		generic(
		N: natural;
		WIDTH: natural
	);
	 Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           en : in  STD_LOGIC;
           q : out  STD_LOGIC_VECTOR(WIDTH-1 downto 0);
           pulse : out STD_LOGIC
			  );
	end component;
	signal p_one, p_ten, p_hundred: std_logic;
begin
	one_digit: mod_n_counter
		generic map(N=>10, WIDTH=>4)
		port map(clk=>clk,reset=>reset,en=>en,pulse=>p_one,q=>q_one);
	ten_digit: mod_n_counter
		generic map(N=>10, WIDTH=>4)
		port map(clk=>clk,reset=>reset,en=>p_one,pulse=>p_ten,q=>q_ten);
	hundred_digit: mod_n_counter
		generic map(N=>10, WIDTH=>4)
		port map(clk=>clk,reset=>reset,en=>p_ten,pulse=>p_hundred,q=>q_hundred);	
end generic_arch;

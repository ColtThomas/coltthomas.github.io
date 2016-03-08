-- Colt Thomas problem 9.11 --
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity p9_14 is
    Port ( w_data : in  STD_LOGIC;
           r_data : out  STD_LOGIC;
           push : in  STD_LOGIC;
           pop : in  STD_LOGIC;
           full : in  STD_LOGIC;
           empty : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           reset : in  STD_LOGIC);
end p9_14;

architecture Behavioral of p9_14 is
	signal w_addr,r_addr: std_logic_vector(1 downto 0);
	signal w_en: std_logic;
begin

stack_control:entity work.stack_ctrl(enlarged_bin_arch)
	port map(clk=>clk, reset=>reset, wr=>push, rd=>pop, full=>full, mpty=>empty, w_addr=>w_addr, r_addr=>r_addr);
register_file:entity work.reg_file(prob)
	port map(clk=>clk, reset=>reset, wr_en=>w_en, w_addr=>w_addr, w_data=>w_data, r_addr0=>r_addr, r_data0=>r_data );

w_en <= push and (not full);
end Behavioral;


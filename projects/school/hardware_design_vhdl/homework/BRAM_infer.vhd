-- Colt Thomas 
-- Problem 2.2
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library unisim;
use unisim.VCOMPONENTS.all;

entity BRAM_infer is
	Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           wr : in  STD_LOGIC;
           rd : in  STD_LOGIC;
           full : out  STD_LOGIC;
           empty : out  STD_LOGIC;
			  data_in: in std_logic_vector(7 downto 0);
			  data_out: out std_logic_vector(7 downto 0)
           );
end BRAM_infer;

architecture Behavioral of BRAM_infer is
	type RAMB16_S9_S9 is array (2047 downto 0) of std_logic_vector(3 downto 0);
	signal w_addr,r_addr: std_logic_vector(1 downto 0);
	signal w_en,full_sig,empty_sig: std_logic;
	signal blank: std_logic_vector(7 downto 0) := "00000000";
	signal RAM: RAMB16_S9_S9;
begin

control:entity work.fifo_sync_ctrl4(enlarged_bin_arch) -- given on learningsuite
	port map(clk=>clk, reset=>reset, wr=>wr, rd=>rd, full=>full_sig, empty=>empty_sig, w_addr=>w_addr, r_addr=>r_addr);
w_en <= wr and (not full_sig);
full <= full_sig;
empty <= empty_sig;

data_out <= RAM(to_integer(unsigned(r_addr)));
end Behavioral;


-- Colt Thomas -- p1.1

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library unisim;
use unisim.VCOMPONENTS.all;

entity BRAM is
	Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           wr : in  STD_LOGIC;
           rd : in  STD_LOGIC;
           full : out  STD_LOGIC;
           empty : out  STD_LOGIC;
			  data_in: in std_logic_vector(7 downto 0);
			  data_out: out std_logic_vector(7 downto 0)
           );
end BRAM;

architecture Behavioral of BRAM is
----- component RAMB16_S9_S9 -----
component RAMB16_S9_S9
 port (
 DOA : out std_logic_vector(7 downto 0);
 DOB : out std_logic_vector(7 downto 0);
 DOPA : out std_logic_vector(0 downto 0);
 DOPB : out std_logic_vector(0 downto 0);
 ADDRA : in std_logic_vector(10 downto 0);
 ADDRB : in std_logic_vector(10 downto 0);
 CLKA : in std_logic;
 CLKB : in std_logic;
 DIA : in std_logic_vector(7 downto 0);
 DIB : in std_logic_vector(7 downto 0);
 DIPA : in std_logic_vector(0 downto 0);
 DIPB : in std_logic_vector(0 downto 0);
 ENA : in std_logic;
 ENB : in std_logic;
 SSRA : in std_logic;
 SSRB : in std_logic;
 WEA : in std_logic;
 WEB : in std_logic
 );
end component;


	signal w_addr,r_addr: std_logic_vector(1 downto 0);
	signal w_en,full_sig,empty_sig: std_logic;
	signal blank: std_logic_vector(7 downto 0) := "00000000";
begin

control:entity work.fifo_sync_ctrl4(enlarged_bin_arch) -- Given on learningsuite
	port map(clk=>clk, reset=>reset, wr=>wr, rd=>rd, full=>full_sig, empty=>empty_sig, w_addr=>w_addr, r_addr=>r_addr);
bram_thing:RAMB16_S9_S9
	port map(DOB=>data_out, ADDRA=>w_addr,  ADDRB=>r_addr, CLKA=>clk, CLKB=>clk, DIA=>data_in,  DIB=>blank,  DIPA=>open,ENA=>'1',  ENB=>'1', SSRA=>reset, SSRB=>reset, WEA=>wr, WEB=>'0');
w_en <= wr and (not full_sig);
full <= full_sig;
empty <= empty_sig;
end Behavioral;


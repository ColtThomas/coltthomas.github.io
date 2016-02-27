----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:58:07 02/24/2016 
-- Design Name: 
-- Module Name:    tx_top - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tx_top is
    Port ( clk : in  STD_LOGIC;
           sw : in  STD_LOGIC_VECTOR (7 downto 0);
           btn : in  STD_LOGIC_VECTOR (3 downto 0);
           seg : out  STD_LOGIC_VECTOR (6 downto 0);
           dp,tx_out,tx_busy : out  STD_LOGIC;
           an : out  STD_LOGIC_VECTOR (3 downto 0));
	function	log2c(n: integer) return integer is
	variable m, p : integer;
	begin
		m := 0;
		p := 1;
		while p < n loop
			m := m + 1;
			p := p * 2;
		end loop;
		return m;
	end log2c;
end tx_top;

architecture Behavioral of tx_top is
	constant DEBOUNCE_VAL: natural := 50; -- Counter for debouncing
	constant DEBOUNCE_BITS: natural := log2c(DEBOUNCE_VAL);
	signal debounce_en:std_logic;
	signal deb_reg,deb_next:std_logic :='0';
begin

--Debounce
debounce_counter: entity work.mod_n_counter(behavioral)
		generic map(n=>DEBOUNCE_VAL,width=>DEBOUNCE_BITS)
		port map(clk =>clk, reset=>btn(3) , pulse=> debounce_en);
	-- Debounce register
	process(clk)
	begin
		if(clk'event and clk='1') then
			deb_reg <= deb_next;
		end if;
	end process;
	-- Debounce next state
	process(debounce_en,deb_reg)
	begin
		deb_next <= deb_reg;
		if(debounce_en='1') then
			deb_next <= btn(0);
		end if;
	end process;
-- Transmitter 
transmitter: entity work.tx(behavioral)
		port map(clk =>clk,rst =>btn(3),data_in=>sw,send_character =>deb_reg,tx_out =>tx_out,tx_busy =>tx_busy);
-- Seg Ctrl
seven_seg_ctrl: entity work.seven_segment_control(behavioral)
	port map(clk=>clk,data_in=>sw,dp_in=>"0000",blank=>"0000",seg=>seg,dp=>dp,an=>an);
end Behavioral;


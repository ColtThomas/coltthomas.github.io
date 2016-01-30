----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:47:43 01/27/2016 
-- Design Name: 
-- Module Name:    seven_segment_top - Behavioral 
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
use ieee.numeric_std.all ;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity seven_segment_top is
    Generic(
				COUNTER_SIZE : NATURAL := 32
			);
	 Port ( clk : in  STD_LOGIC;
           btn : in  STD_LOGIC_VECTOR (3 downto 0);
           sw : in  STD_LOGIC_VECTOR (7 downto 0);
           seg : out  STD_LOGIC_VECTOR (6 downto 0);
           dp : out  STD_LOGIC;
           an : out  STD_LOGIC_VECTOR (3 downto 0));
end seven_segment_top;

architecture seven_seg of seven_segment_top is
	component seven_segment_control
			Generic(
				COUNTER_BITS : NATURAL
			);
			port(
				clk : in  STD_LOGIC;
				  data_in : in  STD_LOGIC_VECTOR (15 downto 0);
				  dp_in : in  STD_LOGIC_VECTOR (3 downto 0);
				  blank : in  STD_LOGIC_VECTOR (3 downto 0);
				  seg : out  STD_LOGIC_VECTOR (6 downto 0);
				  dp : out  STD_LOGIC;
				  an : out  STD_LOGIC_VECTOR (3 downto 0)
			);
	end component;	
	signal data_in: std_logic_vector(15 downto 0);
	signal dp_in,blank: std_logic_vector(3 downto 0);
	signal r_reg, r_next : UNSIGNED(COUNTER_SIZE-1 downto 0) := (others=>'0');
	signal counter_out_top, counter_out_bottom: std_logic_vector(15 downto 0);
	
	signal seg_out:  STD_LOGIC_VECTOR (6 downto 0);
	signal dp_out: STD_LOGIC;
	signal an_out: STD_LOGIC_VECTOR (3 downto 0);
begin

-- 32 bit counter
	-- register
	process(clk)
	begin
		if(clk'event and clk='1') then
			r_reg <= r_next;
		end if;
	end process;


	-- next state logic
	process(r_reg)
	begin
			r_next <= r_reg +1;
	end process;
	
	-- output logic
	counter_out_top <= std_logic_vector(r_reg(COUNTER_SIZE-1 downto COUNTER_SIZE-16));
	counter_out_bottom <= std_logic_vector(r_reg(15 downto 0));
-- Top Level Logic
	data_in <= "1011111011101111" when (btn(2)='1') else
				   "00000000" & sw when (btn(1)='1') else
--				  sw(3 downto 0)& sw(3 downto 0)& sw(3 downto 0)& sw(3 downto 0) when (btn(1)='1') else
				  counter_out_bottom when (btn(0)='1') else
				  counter_out_top;
	
	dp_in <= "0000" when (btn(2)='1') else
				"0010" when (btn(1)='1') else
				"1111" when (btn(0)='1') else
				"1000";
	
	blank <= "1111" when (btn(3)='1') else
				"0000" when (btn(2)='1') else
				"1100" when (btn(1)='1') else
				"0000";
	
	our_seven_seg_ctr: seven_segment_control
		generic map (COUNTER_BITS=>15)
		port map (clk=>clk, data_in=>data_in, dp_in=>dp_in, blank=>blank,seg=>seg_out, dp=>dp_out, an=>an_out);

	seg <= seg_out;
	dp	<= dp_out;
	an <= an_out;
end seven_seg;


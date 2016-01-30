library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all ;

entity seven_segment_control is
	 Generic(
			COUNTER_BITS : NATURAL := 15
			);
    Port ( clk : in  STD_LOGIC;
           data_in : in  STD_LOGIC_VECTOR (15 downto 0);
           dp_in : in  STD_LOGIC_VECTOR (3 downto 0);
           blank : in  STD_LOGIC_VECTOR (3 downto 0);
           seg : out  STD_LOGIC_VECTOR (6 downto 0);
           dp : out  STD_LOGIC;
           an : out  STD_LOGIC_VECTOR (3 downto 0));
--	 Signal counter_out : STD_LOGIC_VECTOR(14 downto 0);  -- change 14 to counter_bits?
	 
end seven_segment_control;

architecture Behavioral of seven_segment_control is
	signal r_reg, r_next : UNSIGNED(COUNTER_BITS-1 downto 0) := (others=>'0');
	Signal sevenSegDecodeIn : STD_LOGIC_VECTOR(3 downto 0);
	Signal anode_select : STD_LOGIC_VECTOR(1 downto 0);
	signal anode_var : STD_LOGIC_VECTOR(3 downto 0);
begin

-- Anode control --
anode_select <= std_logic_vector(r_reg(COUNTER_BITS-1 downto COUNTER_BITS-2));

-- The counter --

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
anode_select <= std_logic(r_reg(COUNTER_BITS-1)) & std_logic(r_reg(COUNTER_BITS-2));


-- The Anode logic --


--process(blank, anode_select)
--begin
----	if(blank/="0000") then
----		an <= blank;
--	if(anode_select="00" and blank(0)='0') then
--		an <= "1110";
--	elsif(anode_select="01" and blank(1)='0') then
--		an <= "1101";
--	elsif(anode_select="10" and blank(2)='0') then
--		an <= "1011";	
--	elsif(anode_select="10" and blank(3)='0') then
--		an <= "0111";
--	else
--		an <= "1111";
--	end if;
--end process;

anode_var <= "1110" when (anode_select="00")else
		"1101" when (anode_select="01")else
		"1011" when (anode_select="10")else
		"0111";
		

an <= anode_var or blank;

-- Seven Segment Decoder

sevenSegDecodeIn <= 	data_in(3 downto 0) when (anode_select="00") else
							data_in(7 downto 4) when (anode_select="01") else
							data_in(11 downto 8) when (anode_select="10") else
							data_in(15 downto 12);

seg <= 		"1000000" when (sevenSegDecodeIn="0000") else 
				"1111001" when (sevenSegDecodeIn="0001") else 
				"0100100" when (sevenSegDecodeIn="0010") else 
				"0110000" when (sevenSegDecodeIn="0011") else 
				"0011001" when (sevenSegDecodeIn="0100") else 
				"0010010" when (sevenSegDecodeIn="0101") else 
				"0000010" when (sevenSegDecodeIn="0110") else 
				"1111000" when (sevenSegDecodeIn="0111") else 
				"0000000" when (sevenSegDecodeIn="1000") else 
				"0010000" when (sevenSegDecodeIn="1001") else 
				"0001000" when (sevenSegDecodeIn="1010") else 
				"0000011" when (sevenSegDecodeIn="1011") else 
				"1000110" when (sevenSegDecodeIn="1100") else 
				"0100001" when (sevenSegDecodeIn="1101") else 
				"0000110" when (sevenSegDecodeIn="1110") else 
				"0001110";
-- DP logic

dp <= not dp_in(0) when anode_select="00" else
		not dp_in(1) when anode_select="01" else
		not dp_in(2) when anode_select="10" else
		not dp_in(3);
end Behavioral;


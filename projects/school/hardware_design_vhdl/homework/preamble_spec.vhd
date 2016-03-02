-- Problem 10.5.d - explicit encoding
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity preamble_spec is
    Port ( start,clk,reset : in  STD_LOGIC;
           data_out : out  STD_LOGIC);
end preamble_spec;

architecture Behavioral of preamble_spec is
	constant idle: std_logic_vector(1 downto 0) := "00";
	constant one: std_logic_vector(1 downto 0) := "01";
	constant zero: std_logic_vector(1 downto 0) := "11";
	signal state_reg , state_next: std_logic_vector(1 downto 0);
	
	signal v: unsigned(3 downto 0) := to_unsigned(7,4);
	signal v_next: unsigned(3 downto 0);
begin
	-- state register
	process(clk)
	begin
		if (clk'event and clk='1') then
			state_reg <= state_next;
		end if;
	end process;
	
	-- Next State 
	process(start)
	
	begin
		state_next <= idle;
		v<=v_next;
		case state_reg is
			when idle =>
				if(start='1') then
					state_next <= one;
					v_next<=to_unsigned(7,4);
				end if;
			when one =>
				state_next <=zero;
				v <= v_next -1;
			when zero =>
				if(v=0) then
					state_next <= idle;
				else
					state_next <= one;
					v <= v_next - 1;
				end if;
		end case;
	end process;
	-- Moore output
	data_out <= '1' when state_reg=one else
					'0';
end Behavioral;


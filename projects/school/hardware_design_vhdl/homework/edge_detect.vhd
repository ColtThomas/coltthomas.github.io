-- Colt Thomas -- problem 10.3
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity edge_detect is
    Port ( strobe ,clk: in  STD_LOGIC;
           p : out  STD_LOGIC);
end edge_detect;

architecture Behavioral of edge_detect is
	type state_type is
		(zero,to_zero,one,to_one);
	signal state_reg, state_next: state_type;
begin
	-- state register
	process(clk)
	begin
		if(clk'event and clk='1') then
			state_reg <= state_next;
		end if;
	end process;

	-- next state logic
	process(state_reg,strobe)
	begin
		p<='0';
		case state_reg is
			when zero =>
				if(strobe='1') then
					state_Reg <= to_one;
				else
					state_reg <= zero;
				end if;
			when to_zero =>
					state_Reg <= zero;
			when one =>
				if(strobe='1') then
					state_Reg <= one;
				else
					state_reg <= to_zero;
				end if;
			when to_one =>
					state_Reg <= one;
		end case;
	end process;
	
	-- Moore output logic
	process(state_reg)
	begin
		p <= '0';
		case state_reg is
			when zero =>
			when to_zero =>
				p<='1';
			when one =>
			when to_one =>
				p<='1';
		end case;
	end process;
end Behavioral;


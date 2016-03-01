-- Problem 12.1 --
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pulse_5clk is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           go : in  STD_LOGIC;
           stop : in  STD_LOGIC;
           pulse : out  STD_LOGIC);
end pulse_5clk;

architecture Behavioral of pulse_5clk is
	--For regular sequential circuit impl
--	constant P_WIDTH: natural := 5;
--	signal c_reg,c_next: unsigned(3 downto 0);
--	signal flag_reg, flag_next: std_logic;

	--FSMD implementation
	constant P_WIDTH: natural := 5;
	type fsmd_state_type is (idle,delay);
	signal state_reg, state_next: fsmd_state_type;
	signal c_reg,c_next:unsigned(3 downto 0);
begin
----------------------------------------
---------- FSMD Implementation----------
----------------------------------------

-- state and data registers
process(clk,reset)
begin
	if(reset='1') then
		state_reg <= idle;
		c_reg <= (others=>'0');
	elsif(clk'evernt and clk='1') then 
		state_reg<=state_next;
		c_reg <= c_next;
	end if;
end process;

-- next state logic & data path functional units/routing
process(state_reg,go,stop,c_reg)
begin
	pulse <='0';
	C_next<= c_reg;
	case state_reg is
		when delay =>
			if go='1' then
				if stop='1' then
					state_next <= idle;
				else
					if(c_reg=P_WIDTH-1) then
						state_next <= idle;
						c_next<= idle;
					else
						state_next<=delay;
						C_next <= c_reg+1;
					end if;
				end if;
				pulse<='1';
			else
				c_next<=(others=>'0');
			end if;
	end case;
end process;
end Behavioral;

---- state register
----process(clk,reset)
----begin
----	if(reset='1') then
----		state_Reg <= idle;
----	elsif(clk'event and clk='1') then
----		state_reg <= state_next;
----	end if;
----end process;
------------------------------------------
------------ FSM Implementation-----------
------------------------------------------
----next state logic & output logic
----process(state_reg, go, stop)
----begin
----	pulse <='0';
----	case state_reg is 
----		when idle =>
----			if go='1' then 
----				state_next <= delay1;
----			else
----				state_next <= idle;
----			end if;
----		when delay1 =>
----			if stop='1' then
----				state_nnext <= idle;
----			else
----				state_next <= delay2;
----			end if;
----			pulse <='1';
----		when delay2 =>
----			if stop='1' then
----				state_next <= idle;
----			else
----				state_next <= delay3;
----			end if;
----			pulse <='1';
----		when delay3 =>
----			if stop='1' then
----				state_next <= idle;
----			else
----				state_next <= delay4;
----			end if;
----			pulse <='1';
----		when delay4=>
----			if stop='1' then 
----				state_next <= idle;
----			else
----				state_next <= delay5;
----			end if;
----			pulse <='1';
----		when delay5 =>
----			state_next <= idle;
----			pulse <= '1';
----	end case;
----end process;
--
--------------------------------------------
------- Sequential Circuit Implementation---
--------------------------------------------
---- register
----process(clk,reset)
----begin
----	if(reset='1') then
----		c_reg<= (others=>'0');
----		flag_reg<='0';
----	elsif (clk'event and clk='1') then
----		c_reg <= c_next;
----		flag_reg <= flag_next;
----	end if;
----end process;
----
------ next state logic
----process(c_reg,flag_reg,go,stop)
----begin
----	c_next<= c_reg;
----	flag_next <= flag_reg;
----	if(flag_reg='0') and (go='1') then
----		flag_next<='1';
----		c_next <= (others=>'0');
----	elsif(flag_reg='1') and
----			((c_reg=P_WIDTH-1) or (stop='1')) then
----		flag_next <='0';
----	elsif(flag_reg='1') then
----		c_next <= c_reg + 1;
----	end if;
----end process;
--
---- output logic
----pulse <='1' when flag_reg='1' else '0';
--
------------------------------------------
------------ FSMD Implementation----------
------------------------------------------
--
---- state and data registers
--process(clk,reset)
--begin
--	if(reset='1') then
--		state_reg <= idle;
--		c_reg <= (others=>'0');
--	elsif(clk'evernt and clk='1') then 
--		state_reg<=state_next;
--		c_reg <= c_next;
--	end if;
--end process;
--
---- next state logic & data path functional units/routing
----process(state_reg,go,stop,c_reg)
----begin
----	pulse <='0';
----	C_next<= c_reg;
----	case state_reg is
----		when idle=>
----			if go='1' then
----				state_next <= delay;
----			else
----				state_next <= idle;
----			end if;
----			c_next <= (others=>'0');
----		when delay =>
----			if stop='1' then
----				state_next <= idle;
----			else
----				if(c_reg=P_WIDTH-1) then
----					state_next <= idle;
----					c_next<= idle;
----				else
----					state_next<=delay;
----					C_next <= c_reg+1;
----				end if;
----			end if;
----			pulse<='1';
----	end case;
----end process;
--
--
---- new and improved
---- next state logic & data path functional units/routing
--process(state_reg,go,stop,c_reg)
--begin
--	pulse <='0';
--	C_next<= c_reg;
--	case state_reg is
----		when idle=>
----			if go='1' then
----				state_next <= delay;
----			else
----				state_next <= idle;
----			end if;
----			c_next <= (others=>'0');
--		when delay =>
--			if go='1' then
--				if stop='1' then
--					state_next <= idle;
--				else
--					if(c_reg=P_WIDTH-1) then
--						state_next <= idle;
--						c_next<= idle;
--					else
--						state_next<=delay;
--						C_next <= c_reg+1;
--					end if;
--				end if;
--				pulse<='1';
--			else
--				c_next<=(others=>'0');
--			end if;
--	end case;
--end process;

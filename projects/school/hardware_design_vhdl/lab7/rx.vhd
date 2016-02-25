----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:32:32 02/24/2016 
-- Design Name: 
-- Module Name:    rx - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rx is
	generic( CLK_RATE: natural := 50_000_000;
				BAUD_RATE : natural := 19_200
	);
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           rx_in : in  STD_LOGIC;
           data_out : out  STD_LOGIC_VECTOR (7 downto 0);
           data_strobe : out  STD_LOGIC;
           rx_busy : out  STD_LOGIC);
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
end rx;

architecture Behavioral of rx is
	--FSM signals and stuff
	type state_type is
		(power_up,idle,start,data,stop);
	signal state_reg, state_next: state_type;
	signal rx_busy,data_strobe:std_logic;
	signal s_reg,s_next:unsigned(3 downto 0);
	signal bit_out:std_logic;  -- Consider making this a register rather than a moore output
	-- Counter signals and constants
	constant BIT_COUNTER_MAX_VAL: natural := CLK_RATE/BAUD_RATE -1; -- you may need to watch for off by one errors
	constant BIT_COUNTER_BITS: natural := log2c(BIT_COUNTER_MAX_VAL);
	signal full_count,half_count:std_logic;
begin
-- FSM Operations
	-- FSM state register
	process(clk)
	begin
		if(rst='1') then
			state_reg<= power_up;
		elsif(clk'event and clk='1') then
			state_reg <= state_next;
		end if;
	end process;
	-- next state logic
	process(state_next,rx_in,rst)
	begin
		case state_reg is
			when power_up=>
				if(rx_in='0') then
					state_next<=power_up;
				else
					state_next<=idle;
				end if;
			when idle=>
				if(rx_in<='0') then
					state_next<=start;
				else
					state_next<=idle;
				end if;
			when start=> 
				if(full_count='1') then
					state_next<=data;
				else
					state_next<=start;
				end if;
			when data=>
				if(s_reg=to_unsigned(7,4)) then
					state_next <= stop;
				else
					state_next <= data;
					s_next<=s_reg+1;	-- See if this can be assigned here
				end if;
			when stop=>
				if(rx_in='0') then
					state_next<=idle;
				else
					state_next<=stop;
				end if;
		end case;
	end process;
	--moore outputs
	process(state_reg)
	begin
		rx_busy<='1';
		case state_reg is
			when power_up=>
			when idle=>
				rx_busy<='0';
			when start=> 
			when stop=>
		end case;
	end process;
	--mealy outputs
	process(state_reg,tx_bit,send_character)
	begin 
		case state_reg is
			when power_up=>
			when idle=>
			when start=> 
			when data=>
				b_next<=
			when stop=>
		end case;
	end process;
end Behavioral;
--
--library ieee;
--use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;
--entity rx is 
--	port(
--		clk,reset:in std_logic;
--		rx: in std_logic;
--		ready: out std_logic;
--		ready: out std_logic;
--		pout: out std_logic_vector(7 downto 0)
--	);
--end rx;
--
--architecture arch of rx is
--	type state_type is(idle,start,data,stop)

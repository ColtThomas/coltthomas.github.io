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
	-- Consider having a state that is active for only one clk cycle that outputs the sample_flag as 
	-- a moore output, rather than figuring out the mealy output
	type state_type is
		(power_up,idle,start,prime,data,stop);
	signal state_reg, state_next: state_type := power_up;
	signal s_reg,s_next:unsigned(3 downto 0) := to_unsigned(0,4);
	signal bit_out:std_logic :='1';  -- Consider making this a register rather than a moore output
	signal clrTimerHalf,clrTimerFull:std_logic;
	signal sample_flag: std_logic :='0';
	
	-- Counter signals and constants
	constant BIT_COUNTER_MAX_VAL: natural := CLK_RATE/BAUD_RATE -1; -- you may need to watch for off by one errors
	constanT BIT_COUNTER_HALF_MAX_VALUE: natural := BIT_COUNTER_MAX_VAL / 2;
	constant BIT_COUNTER_BITS: natural := log2c(BIT_COUNTER_MAX_VAL);
	signal half_step,full_step,bit_reset,bit_half_reset:std_logic :='0';
	
	--Received Bit
	signal data_rx: STD_LOGIC_VECTOR (7 downto 0);
begin


-------------------------------------------------------------
-------------------- FSM Operations -------------------------
-------------------------------------------------------------
	-- FSM state register
	process(clk)
	begin
		if(rst='1') then
			state_reg<= power_up;
			s_reg<=to_unsigned(0,4);
		elsif(clk'event and clk='1') then
			state_reg <= state_next;
			s_reg<=s_next;
		end if;
	end process;
	
	-- next state logic
	process(state_next,rx_in,rst,half_step,full_step)
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
				if(rx_in='0') then
					if(half_step='1') then
						state_next<=prime;
					else
						state_next<=start;
					end if;
				else
					state_next<=idle;
				end if;
			when prime=> -- this is your first bit; consider state name change
				bit_out <= rx_in;  --Consider a register
				if(rx_in='0') then
					if(full_step='1') then
						state_next<=data;
						s_next<=to_unsigned(0,4);
					else
						state_next<=prime;
					end if;
				else
					state_next<=idle;
				end if;
			when data=>
				bit_out <= rx_in;  --Consider a register
				if(full_step='1') then
					if(s_reg=to_unsigned(7,4)) then
						state_next <= stop;
					else
						state_next <= data;
						s_next<=s_reg+1;	-- See if this can be assigned here
					end if;
				else
					state_next<=data;
				end if;
			when stop=>
				bit_out <= rx_in;
				if(rx_in='0') then
					state_next<=idle;
				elsif(full_step='1') then
					state_next<=idle;
				else
					state_next<=stop;
				end if;
		end case;
	end process;
		
	--moore outputs
	process(state_reg)
	begin
		clrTimerFull<='0';
		clrTimerHalf<='0';
		rx_busy<='1';
		case state_reg is
			when power_up=>
				rx_busy <= '1';
			when idle=>
				rx_busy<='0';
				clrTimerHalf<='1';
				clrTimerFull<='1';
			when start=>
				clrTimerFull<='1';
			when prime=>
			when data=>
			when stop=>
		end case;
	end process;
	
	--mealy outputs
	process(state_reg,full_step)
	begin 
		data_strobe<='0';
		sample_flag<='0';
		case state_reg is
			when power_up=>
			when idle=>
			when start=>
			when prime=>
			when data=>
				if(half_step='1') then
					sample_flag<='1';		-- ******Problem***** get this to work
				end if;
			when stop=>
				if(full_step='1') then
					data_strobe<='1';
				end if;
		end case;
	end process;
	
-------------------------------------------------------------
----------------------- Bit Timers --------------------------
-------------------------------------------------------------	
bit_counter_half: entity work.mod_n_counter(behavioral)
		generic map(n=>BIT_COUNTER_HALF_MAX_VALUE,width=>BIT_COUNTER_BITS)
		port map(clk =>clk, reset=>bit_half_reset , pulse=>half_step);
bit_counter_full: entity work.mod_n_counter(behavioral)
		generic map(n=>BIT_COUNTER_MAX_VAL,width=>BIT_COUNTER_BITS)
		port map(clk =>clk, reset=>bit_reset , pulse=>full_step);
	
bit_reset<= rst or clrTimerFull;
bit_half_reset<= rst or clrTimerHalf;
-------------------------------------------------------------
-------------------- Shift Registers -------------------------
-------------------------------------------------------------
shift_register: entity work.universal_sf(behavioral)
		port map(clk =>clk, reset=> rst,shift=>sample_flag,d=>bit_out,q=>data_out);
		

-------------------------------------------------------------
-------------------- Receive In -------------------------
-------------------------------------------------------------
--data_out <= data_rx when data_strobe='1' else
--				"00000000";
				
				
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

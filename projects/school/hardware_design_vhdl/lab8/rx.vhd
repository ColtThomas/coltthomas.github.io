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
           rx_busy : out  STD_LOGIC;
			  state_current: out std_logic_vector(5 downto 0));
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
		(power_up,idle,start,data,finish,stop);
	signal state_reg, state_next: state_type := power_up;
	signal n_reg,n_next:unsigned(3 downto 0) := to_unsigned(0,4); --counter for the data and prime states respectively
	signal byte_reg,byte_next:std_logic_vector(7 downto 0);
	signal clrTimer,clrTimerPrime,clrtimerhalf:std_logic;
	
	
	-- Counter signals and constants
	constant BIT_COUNTER_MAX_VAL: natural := CLK_RATE/BAUD_RATE-1; -- you may need to watch for off by one errors
	constanT BIT_COUNTER_PRIME_MAX_VALUE: natural := BIT_COUNTER_MAX_VAL + BIT_COUNTER_MAX_VAL / 2;
	constanT BIT_COUNTER_HALF_MAX_VALUE: natural := BIT_COUNTER_MAX_VAL / 2 + 84;  --There was a slight offset of timing that was affecting my receiver
	constant BIT_COUNTER_BITS: natural := log2c(BIT_COUNTER_MAX_VAL);
	signal prime_step,full_step,half_step,bit_reset,bit_PRIME_reset,bit_half_reset:std_logic :='0';
	
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
			byte_reg<="00000000";
			n_reg<=to_unsigned(0,4);
		elsif(clk'event and clk='1') then
			state_reg <= state_next;
			byte_reg<=byte_next;
			n_reg<=n_next;
		end if;
	end process;
	
-- 	next state logic
	process(state_reg,byte_reg,rx_in,prime_step,full_step,half_step) 
	begin
		byte_next<=byte_reg;
		n_next<=n_reg;
		data_strobe<='0';
		rx_busy<='1';
		clrTimer<='1';
		clrTimerHalf<='1';
		clrTimerPrime<='1';
		case state_reg is
			when power_up=>
				if(rx_in='0') then
					state_next<=power_up;
				else
					state_next<=idle;
				end if;
			when idle=>
				rx_busy<='0';
				if(rx_in='1') then
					state_next<=idle;
				else
					state_next<=start;
				end if;
			when start=> 
				clrTimerPrime<='0';
				if(prime_step='1') then
					state_next<=data;
					n_next<=to_unsigned(0,4);
					byte_next<= rx_in & byte_reg(7 downto 1)  ;  -- Hope this works
				else
					state_next<=start;
				end if;
			when data=>
				clrTimer<='0';
				if(full_step='1') then
					byte_next<= rx_in & byte_reg(7 downto 1)  ;  -- Hope this works
					if(n_reg=to_unsigned(6,4)) then
						state_next<=finish;
					else
						state_next<=data;
						n_next<=n_reg+1;
					end if;
				else
					state_next<=data;
				end if;
			when finish =>
				clrTimerHalf<='0'; --May want to distinguish the half
				if(half_step='1') then
					state_next<=stop;
				else
					state_next<=finish;
				end if;
			when stop =>
				clrTimer<='0';
				if(rx_in='1') then
					if(full_step='1') then
						data_strobe<='1';
						state_next<=idle;
					else
						state_next<=stop;
					end if;
				else
					state_next<=idle;
				end if;
		end case;
	end process;

-- Output
data_out<=byte_reg;
state_current<= 	"100000" when state_reg=power_up else
						"010000" when state_reg=idle else
						"001000" when state_reg=start else
						"000100" when state_reg=data else
						"000010" when state_reg=finish else
						"000001";
-------------------------------------------------------------
----------------------- Bit Timers --------------------------
-------------------------------------------------------------	
bit_counter_PRIME: entity work.mod_n_counter(behavioral)
		generic map(n=>BIT_COUNTER_PRIME_MAX_VALUE,width=>BIT_COUNTER_BITS)
		port map(clk =>clk, reset=>bit_prime_reset , pulse=>prime_step);
bit_counter_full: entity work.mod_n_counter(behavioral)
		generic map(n=>BIT_COUNTER_MAX_VAL,width=>BIT_COUNTER_BITS)
		port map(clk =>clk, reset=>bit_reset , pulse=>full_step);
bit_counter_half: entity work.mod_n_counter(behavioral)
		generic map(n=>BIT_COUNTER_HALF_MAX_VALUE,width=>BIT_COUNTER_BITS)
		port map(clk =>clk, reset=>bit_half_reset , pulse=>half_step);	
bit_reset<= rst or clrTimer;
bit_prime_reset<= rst or clrTimerPrime;
bit_half_reset<= rst or clrTimerHalf;

-------------------------------------------------------------
-------------------- Shift Registers -------------------------
-------------------------------------------------------------
--shift_register: entity work.universal_sf(behavioral)
--		port map(clk =>clk, reset=> rst,shift=>sample_flag,d=>bit_out,q=>data_out);
		

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
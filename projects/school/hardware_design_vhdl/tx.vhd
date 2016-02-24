-- tx.vhd a la Colt Thomas
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tx is
	generic( CLK_RATE: natural := 50_000_000;
				BAUD_RATE : natural := 19_200
	);
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           data_in : in  STD_LOGIC_VECTOR (7 downto 0);
           send_character : in  STD_LOGIC;
           tx_out : out  STD_LOGIC;
           tx_busy : out  STD_LOGIC);
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
end tx;
 
architecture Behavioral of tx is
	constant BIT_COUNTER_MAX_VAL: natural := CLK_RATE/BAUD_RATE -1; -- you may need to watch for off by one errors
	constant BIT_COUNTER_BITS: natural := log2c(BIT_COUNTER_MAX_VAL);
	
	-- FSM signals
	signal clrTimer,shift,load,start,stop: std_logic;
	type state_type is
		(idle,strt,b0,b1,b2,b3,b4,b5,b6,b7,stp,retrn);
	signal state_reg,state_next: state_type;
	-- Bit timer signals
	signal tx_bit,bit_reset: std_logic;
	signal bit_count_reg: std_logic_vector(BIT_COUNTER_BITS - 1 downto 0); 
	-- Shift register Signal
	signal ctrl: std_logic_vector(1 downto 0); 
	signal shift_out:std_logic;
	-- Transmit out signals
	signal t_reg, t_next: std_logic :='1';
	
begin
-- FSM
	-- state register
	process(clk)
	begin
		if(rst='1') then
			state_reg <= idle;
		elsif (clk'event and clk='1') then
			state_reg <= state_next;
		end if;
	end process;
	-- next state logic
	process(state_next,tx_bit,send_character)
	begin
		case state_reg is
			when idle=>
				if(send_character='1') then
					state_next<=strt;
				end if;
			when strt=> 
				if(tx_bit='1') then
					state_next<=b0;
				end if;
			when b0=>
				if(tx_bit='1') then
					state_next<=b1;
				end if;
			when b1=> 
				if(tx_bit='1') then
					state_next<=b2;
				end if;			
			when b2=> 
				if(tx_bit='1') then
					state_next<=b3;
				end if;
			when b3=> 
				if(tx_bit='1') then
					state_next<=b4;
				end if;
			when b4=> 
				if(tx_bit='1') then
					state_next<=b5;
				end if;
			when b5=> 
				if(tx_bit='1') then
					state_next<=b6;
				end if;
			when b6=> 
				if(tx_bit='1') then
					state_next<=b7;
				end if;
			when b7=> 
				if(tx_bit='1') then
					state_next<=stp;
				end if;
			when stp=>
				if(tx_bit='1') then
					state_next<=retrn;
				end if;			
			when retrn=>
				if(send_character='0') then
					state_next<=idle;
				end if;
		end case;
	end process;
	--moore outputs
	process(state_reg)
	begin
		tx_busy <= '1';
		stop<='0';
		start<='0';
		clrTimer<='0';
		case state_reg is
			when idle=> 
				tx_busy <='0';
				stop<='1';
				clrTimer<='1';
			when strt=>
				start<='1';
			when b0=> 
			when b1=> 
			when b2=> 
			when b3=> 
			when b4=> 
			when b5=> 
			when b6=> 
			when b7=> 
			when stp=> 
				stop<='1';
			when retrn=>
				stop<='1';
		end case;
	end process;
	--mealy outputs
	process(state_reg,tx_bit,send_character)
	begin 
		load <='0';
		shift <='0';
		case state_reg is
			when idle=> --make sure transition works, and turns off in strt
				if(send_character='1') then
					load<='1';
				end if;
			when strt=> 
			when b0=>
				if(tx_bit='1') then
					shift<='1';
				end if;
			when b1=> 
				if(tx_bit='1') then
					shift<='1';
				end if;
			when b2=> 
				if(tx_bit='1') then
					shift<='1';
				end if;
			when b3=> 
				if(tx_bit='1') then
					shift<='1';
				end if;
			when b4=> 
				if(tx_bit='1') then
					shift<='1';
				end if;
			when b5=> 
				if(tx_bit='1') then
					shift<='1';
				end if;
			when b6=> 
				if(tx_bit='1') then
					shift<='1';
				end if;
			when b7=> 
				if(tx_bit='1') then
					shift<='1';
				end if;
			when stp=> 
			when retrn=>
		end case;
	end process;
-- Bit Timer
	bit_counter: entity work.mod_n_counter(behavioral)
		generic map(n=>BIT_COUNTER_MAX_VAL,width=>BIT_COUNTER_BITS)
		port map(clk =>clk, reset=>bit_reset , q =>bit_count_reg, pulse=>tx_bit);
	bit_reset<= rst or clrTimer;
-- Shift Register
	shift_register: entity work.universal_sf(behavioral)
		port map(clk =>clk, reset=> rst,ctrl=>ctrl,d=>data_in,q=>shift_out);
		
	ctrl <= shift & load;
--Transmit Out
	--register
	process(clk)
	begin
		t_reg <= t_next;
	end process;
	-- next state logic
	t_next <= '0' when start='1' else
				 '1' when stop='1' else
				 shift_out;
	--output
	tx_out<= t_reg;
end Behavioral;


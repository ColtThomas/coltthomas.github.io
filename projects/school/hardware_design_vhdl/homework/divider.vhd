----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:13:14 02/23/2016 
-- Design Name: 
-- Module Name:    divider - Behavioral 
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

entity divider is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           start : in  STD_LOGIC;
           y : in  STD_LOGIC;
           q : in  STD_LOGIC_VECTOR (7 downto 0);
           ready : out  STD_LOGIC;
           r : out  STD_LOGIC_VECTOR (15 downto 0));
end divider;

architecture Behavioral of divider is
	constant WIDTH: integer :=8; type state_type is (idle, sb0,load,op);
	signal state_reg, state_next: state_type;
	signal a_is_0, b_is_0, count_0: std_logic;
	signal a_reg,a_next: unsigned(WIDTH-1 downto 0);
	signal n_reg,n_next: unsigned(WIDTH-1 downto 0);
	signal r_reg,r_next: unsigned(WIDTH-1 downto 0);
	signal adder_out: unsigned(2*WIDTH -1 downto 0);
	signal sub_out: unsigned(WIDTH-1 downto 0);
begin

	-- control path: state register
	process(clk,reset)
	begin
		if reset='1' then 
			state_reg <= idle;
		elsif(clk'event and clk='1') then 
			state_reg <= state_next;
		end if;
	end process;
	-- control path: next-state/output logic
	process(state_reg, start,a_is_0,b_is_0,count_0)
	begin
		case state_reg is 
			when idle =>
				if start='1' then
					if(a_is_0='1' or b_is_0='1') then
						state_next <= ab0;
					else 
						state_next <= load;
					end if;
				else
					state_next <= idle;
				end if;
			when ab0 =>
				state_next <= idle;
			when load =>
				state_next <= op;
			when op =>
				if count_0='1' then
					state_next <= idle;
				else
					state_next <= idle;
				end if;
		end case;
	end process;
	-- control path: output logic
	ready <='1' when state_reg=idle else '0';
	-- data path: data register
	process(clk, reset)
	begin
		if reset='1' then
			a_reg <= (others=>'0');
			n_reg <= (others=>'0');
			r_Reg <= (others=>'0');
		elsif(clk'event and clk='1') then
			a_Reg <= a_next;
			n_reg <= n_next;
			r_reg <= r_next;
		end if;
	end process;
	-- data path: routing multiplexer
	process(state_reg, a_reg,n_reg,r_reg, a_in,b_in,adder_out,sub_out)
	begin
		case state_reg is
			when idle =>
				a_next <= a_reg;
				n_next <= n_reg;
				r_next <= r_reg;
			when ab0 =>
				a_next <= unsigned(a_in);
				n_next <= unsigned(n_in);
				r_next <= unsigned(r_in);
		end case;
	end process;
	-- data path: functional units
	adder_out <= ("000000" & a_reg) + r_reg;
	sub_out <= n_reg -1;
	-- data path: status
	a_is_0 <= '1' when a_in = "00000000" else '0';
	b_is_0 <= '1' when b_in = "00000000" else '0';
	count_0 <= '1' when n_next="00000000" else '0';
	-- data path: output
	r <= std_logic_vector(r_reg);
end Behavioral;


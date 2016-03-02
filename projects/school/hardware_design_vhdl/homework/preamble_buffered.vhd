----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:06:51 02/23/2016 
-- Design Name: 
-- Module Name:    preamble - Behavioral 
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

entity preamble is
    Port ( start,clk,reset : in  STD_LOGIC;
           data_out : out  STD_LOGIC);
end preamble;

architecture Behavioral of preamble is
	-- Default state encoding
--	type state_type is (idle, one, zero) ;
--	signal state_reg , state_next: state_type;
	
	-- enumerated encoding
	type state_type is (idle, one, zero) ;
	attribute enum_code: string;
	attribute enum_code of state_type:
		type is "00 01 11";
	signal state_reg , state_next: state_type;
	
	signal v: unsigned(3 downto 0) := to_unsigned(7,4);
	signal v_next: unsigned(3 downto 0);
	signal output_buf_reg,output_buf_next: std_logic;
begin
	-- state register
	process(clk)
	begin
		if (clk'event and clk='1') then
			state_reg <= state_next;
			output_buf_reg <= output_buf_next;
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
	output_buf_next <= '1' when state_reg=one else
					'0';
	data_out <= output_buf_reg;				
	
end Behavioral;


-- Colt Thomas hw problem 9.4
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity hw_9_4 is
	port(
		clk, reset: in std_logic;
		q: out std_logic_vector(3 downto 0)
	);	
end hw_9_4;

architecture Behavioral of hw_9_4 is
	constant WIDTH: natural :=4;
	signal r_reg, r_next: std_logic_vector(WIDTH-1 downto 0);
	signal s_in: std_logic;
begin
	-- register
	process(clk,reset)
	begin
		if(reset='1') then
			r_reg <= (others=>'1');
		elsif (clk'event and clk='1') then
			r_reg <= r_next;
		end if;
	end process;
	
	--next state logic
	s_in <= '0' when r_reg(WIDTH-1 downto 1)="111" else
				'1';
	r_next <= s_in & r_reg(WIDTH-1 downto 1);
	
	-- output logic
	q<= r_reg;

end Behavioral;


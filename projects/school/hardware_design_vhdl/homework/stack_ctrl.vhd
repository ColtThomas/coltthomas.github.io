-- Problem 9.11 --
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity stack_ctrl is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           wr : in  STD_LOGIC;
           rd : in  STD_LOGIC;
           full : out  STD_LOGIC;
           empty : out  STD_LOGIC;
           w_addr,r_addr : out  STD_LOGIC_VECTOR (1 downto 0));
end stack_ctrl;

architecture enlarged_bin_arch of stack_ctrl is
	constant N: natural :=2;
	constant BASE: natural :=3; -- For the 4 word stack
	signal w_ptr_reg, w_ptr_next: unsigned(N downto 0);
	signal r_ptr_reg, r_ptr_next: unsigned(N downto 0);
	signal b_ptr_reg, b_ptr_next: unsigned(N downto 0);

	signal full_flag, empty_flag: std_logic;
begin

-- stack controller
	--register
	process(clk,reset)
	begin
		if(reset='1') then
			w_ptr_reg <= (others=>'0');
			b_ptr_reg <= (others=>'0');
		elsif(clk'event and clk='1') then
			w_ptr_reg <= w_ptr_next;
			b_ptr_reg <= b_ptr_next;			
		end if;
	end process;
	
	-- write pointer next-state logic
	w_ptr_next<=
		w_ptr_reg + 1 when wr='1' and full_flag='0' else
		w_ptr_reg - 1 when rd='1' and empty_flag/='0' else
		w_ptr_reg;
	full_flag <= '1' when w_ptr_reg=BASE+1 else
		'0';
		
	-- write port output 
	w_addr<= std_logic_vector(w_ptr_reg(N-1 downto 0));
	full <= full_flag;
	
	-- read pointer next-state logic
	r_ptr_next<=
		r_ptr_reg + 1 when wr='1' and full_flag='0' else
		r_ptr_reg - 1 when rd='1' and empty_flag/='0' else
		r_ptr_reg;
	empty_flag <= '1' when w_ptr_reg=b_ptr_reg else
						'0';
						
	-- read prot output
	r_addr <= std_logic_vector(w_ptr_reg(N-1 downto 0) - 1) when empty_flag='0' else
					std_logic_vector(w_ptr_reg(N-1 downto 0));
	empty <= empty_flag;
	
end enlarged_bin_arch;
		



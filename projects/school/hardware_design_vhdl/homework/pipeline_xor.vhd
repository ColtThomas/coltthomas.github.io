-- Homework prob 9.15 --
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pipeline_xor is
    Port ( a : in  STD_LOGIC_VECTOR (7 downto 0);
           y : out  STD_LOGIC;
			  clk,reset: in std_logic);
end pipeline_xor;

architecture Behavioral of pipeline_xor is
	signal p:std_logic_vector(3 downto 0);
	signal q:std_logic_vector(1 downto 0);
	signal r:std_logic;
	signal a_reg,a_next: std_logic_vector(7 downto 0);
	signal b_reg,b_next: std_logic_vector(3 downto 0);
	signal c_reg,c_next: std_logic_vector(1 downto 0);
	signal d_reg,d_next: std_logic;
	
begin

process(clk, reset)
begin
	if(reset='1') then
		a_reg<= (others=>'0');
		b_reg<= (others=>'0');
		c_reg<= (others=>'0');
		d_reg<= '0';
	elsif(clk'event and clk='1') then
		a_Reg <= a_next;
		b_Reg <= b_next;
		c_Reg <= c_next;
		d_Reg <= d_next;
	end if;
end process;

--stage 1 
a_next<=a;
--stage 2
p(0)<=a_reg(0) xor a_reg(1);
p(1)<=a_reg(2) xor a_reg(3);
p(2)<=a_reg(4) xor a_reg(5);
p(3)<=a_reg(6) xor a_reg(7);

b_next(0)<=p(0);
b_next(1)<=p(1);
b_next(2)<=p(2);
b_next(3)<=p(3);


--stage 3
q(0)<=b_reg(0) xor b_reg(1);
q(1)<=b_reg(2) xor b_reg(3);

c_next(0)<=q(0);
c_next(1)<=q(1);

--stage 4
r<=c_reg(0) xor c_reg(1);

d_next<=r;

-- output
y<=d_reg;

end Behavioral;


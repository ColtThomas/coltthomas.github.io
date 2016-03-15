-- Colt Thomas

-- So I just jammed all my problems into one architecture (except
-- problem 14.3) for the sake of space. Individually they all work
-- and the various signals are declared with different names.
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity incrementer is
	generic(WIDTH: natural := 8);
	port(
		a: in std_logic; 
		a1: in std_logic_vector;
		a2: in std_logic_vector(WIDTH-1 downto 0);
		s: out std_logic;
		s1: out std_logic_vector;
		s2: out std_logic_vector(WIDTH-1 downto 0);
		cout: out std_logic
	);
end incrementer;

architecture Behavioral of incrementer is
		signal cin: std_logic :='1';
		variable cin1: std_logic :='1';
		signal cin2:std_logic_vector(WIDTH-1 downto 0) := (others=>'0');
begin

-- 14.1 
s <= a xor cin;
cout <= a and cin;

-- 14.5 - parameterizable using for loop
process(a2)
begin
	
	for i in 0 to (WIDTH-1) loop
		s2(i) <= a2(i) xor cin1;
		cin1 := a2(i) and cin1;
	end loop;
end process;

-- 14.7 - parameterizable using a loop
process(a1)
begin
	
	for i in 0 to a1'length loop
		s1(i) <= a1(i) xor cin1;
		cin1 := a1(i) and cin1;
	end loop;
end process;

-- 14.6 - Clever use of array
-- Note that this is in reverse since
-- (0 to Width-1) can't compile
cin2 <='1'&((cin2(WIDTH-2 downto 0)) and a2(Width-1 downto 1));
s2<= a2 xor cin2;

-- 14.2 parameterized incrementor using a generic
-- and a for generate statement
cin2(0) <='1';
gen_label:
for i in 1 to WIDTH-1 generate
		cin2(i) <=	a2(i-1) and cin2(i-1);
end generate;
s2 <= a2 xor cin2;


-- 14.3 component instantiation
-- and a for generate statement
cin2(0) <= '1';

gen_label1:
for i in 0 to WIDTH-1 generate
	incr:entity work.inc_1bit(one)
		port map(a=>a2(i),cin=>cin2(i),s=>s2(i),cout=>cin2(i+1));
end generate;

-- 14.4 conditional generate statements
gen_label2:
for i in 0 to WIDTH-1 generate

	first_gen:if i=0 generate
		cin2(i)<='1';
	end generate;
	second_gen:if i/=0 generate
		cin2(i) <=	a2(i-1) and cin2(i-1);
	end generate;
end generate;
s2 <= a2 xor cin2;


end Behavioral;




-- Colt Thomas -- homework 10
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity inc_1bit is
	port(
		a: in std_logic;
		cin: in std_logic;		
		s: out std_logic;
		cout: out std_logic
	);
end inc_1bit;

architecture one of inc_1bit is
begin
s <= a xor cin;
cout <= a and cin;

end one;

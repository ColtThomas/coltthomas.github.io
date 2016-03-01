-- Colt Thomas -- Problem 8.8
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity abstract_counter is
	port(
		clk,reset: in std_logic;
		q: out std_logic_vector(2 downto 0)
	);
end abstract_counter;

architecture Behavioral of abstract_counter is
	component mod_n_counter
		generic(
		N: natural;
		WIDTH: natural
	);
	 Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           en : in  STD_LOGIC;
           q : out  STD_LOGIC_VECTOR(WIDTH-1 downto 0);
           pulse : out STD_LOGIC
			  );
	end component;
	signal pulse_out: STD_LOGIC;	--Required for component, but unused.
	signal mod_out: STD_LOGIC_VECTOR(2 downto 0);

begin
--	 mod 5 counter: I am recycling my mod_n_counter from another hw prob.
--		note that pulse_out is there because I am recycling code
		counter_mod5: mod_n_counter
		generic map(N=>5, WIDTH=>3)	-- Want a mod 5 counter, 3 bits for q
		port map(clk=>clk,reset=>reset,en=>'1',pulse=>pulse_out,q=>mod_out);
	-- output logic
	q <= 	"000" when(mod_out="000") else
			"011" when(mod_out="001") else
			"110" when(mod_out="010") else
			"101" when(mod_out="011") else
			"111";
end Behavioral;


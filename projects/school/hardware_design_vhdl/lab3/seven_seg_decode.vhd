library IEEE;



use IEEE.STD_LOGIC_1164.ALL;







-- Uncomment the following library declaration if using



-- arithmetic functions with Signed or Unsigned values



--use IEEE.NUMERIC_STD.ALL;







-- Uncomment the following library declaration if instantiating



-- any Xilinx primitives in this code.



--library UNISIM;



--use UNISIM.VComponents.all;







entity seven_seg_decode is



    Port ( sw : in  STD_LOGIC_VECTOR (7 downto 0);



           btn : in  STD_LOGIC_VECTOR (3 downto 0);



           seg : out  STD_LOGIC_VECTOR (6 downto 0);



           dp : out  STD_LOGIC;



           an : out  STD_LOGIC_VECTOR (3 downto 0));



  	signal tempB : STD_LOGIC_VECTOR(3 downto 0);



	signal tempA : STD_LOGIC_VECTOR(3 downto 0);



end seven_seg_decode;







architecture Behavioral of seven_seg_decode is



	



begin







-- Anode Decode Logic







an <= "0000" when (btn(3)='1') else



		"1111" when (btn(2)='1') else



		"1110" when (btn(1)='0' and btn(0)='0') else



		"1101" when (btn(1)='0' and btn(0)='1') else



		"1011" when (btn(1)='1' and btn(0)='0') else



		"0111" when (btn(1)='1' and btn(0)='1') else



		"0000";



-- DP Logic







dp <= '0' when (btn(3)='1') else



		'1' when (btn(2)='1') else



		'1';







-- Seven Segment Decoder Logic











tempA <= sw(3 downto 0) when (btn(1)='0' and btn(0)='0') else



			sw(7 downto 4) when (btn(1)='0' and btn(0)='1') else



			((sw(3) xor sw(7))&(sw(2) xor sw(6))&(sw(1) xor sw(5))&(sw(0) xor sw(4))) when (btn(1)='1' and btn(0)='0') else



			sw(1) & sw(0) & sw(3) & sw(2);







tempB <= "1000" when (btn(3)='1') else



			tempA;







seg <= 	"1000000" when (tempB="0000") else 



				"1111001" when (tempB="0001") else 



				"0100100" when (tempB="0010") else 



				"0110000" when (tempB="0011") else 



				"0011001" when (tempB="0100") else 



				"0010010" when (tempB="0101") else 



				"0000010" when (tempB="0110") else 



				"1111000" when (tempB="0111") else 



				"0000000" when (tempB="1000") else 



				"0010000" when (tempB="1001") else 



				"0001000" when (tempB="1010") else 



				"0000011" when (tempB="1011") else 



				"1000110" when (tempB="1100") else 



				"0100001" when (tempB="1101") else 



				"0000110" when (tempB="1110") else 



				"0001110";







end Behavioral;
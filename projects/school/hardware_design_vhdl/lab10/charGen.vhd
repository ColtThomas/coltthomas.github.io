----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:15:14 03/17/2016 
-- Design Name: 
-- Module Name:    charGen - Behavioral 
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

entity charGen is
    Port ( clk : in  STD_LOGIC;
           char_we : in  STD_LOGIC;
           char_value : in  STD_LOGIC_VECTOR (7 downto 0);
           char_addr : in  STD_LOGIC_VECTOR (11 downto 0);
           pixel_x : in  STD_LOGIC_VECTOR (9 downto 0);
           pixel_y : in  STD_LOGIC_VECTOR (9 downto 0);
           pixel_out : out  STD_LOGIC);
end charGen;

architecture Behavioral of charGen is
	constant CHAR_WIDTH : unsigned(11 downto 0) := to_unsigned(128,12);
	signal char_read_addr : std_logic_vector(11 downto 0) := (others=>'0');
	signal char_read_value: std_logic_vector(7 downto 0);
	signal font_rom_addr: std_logic_vector(10 downto 0):= (others=>'0');
	signal data:std_logic_vector(7 downto 0):= (others=>'0');
--	signal char_write_addr:
	-- buffers
	signal px_x_aReg,px_x_aNext,px_x_bReg,px_x_bNext,px_x_sel : STD_LOGIC_VECTOR (9 downto 0);
	
begin
	-- Output buffer
	process(clk)
	begin
		if(clk'event and clk='1') then
			px_x_aReg <=px_x_aNext;
			px_x_bReg<=px_x_bNext;
		end if;
	end process;

	process(px_x_aReg,px_x_bReg,pixel_x)
	begin
		px_x_aNext <=pixel_x;
		px_x_bNext <=px_x_aReg;
	end process;
--	char_read_addr <= std_logic_vector( unsigned(pixel_y)* CHAR_WIDTH + unsigned(pixel_x));
	char_read_addr <=pixel_y(8 downto 4) & pixel_x(9 downto 3);
	charMem: entity work.char_mem(arch)
		port map(clk=>clk, --
		char_read_addr =>char_read_addr, --*
		char_write_addr=>char_addr, -- is this the prob?
		char_we => char_we, --
		char_write_value=>char_value, --
		char_read_value => char_read_value --
		);

	font_rom_addr<=char_read_value(6 downto 0) & pixel_y(3 downto 0);
	fontRom: entity work.font_rom(arch)
		port map(clk=>clk,
      addr=>font_rom_addr,
      data=>data
		);
	with px_x_bReg(2 downto 0) select
	pixel_out <= 	data(7) when "000",
						data(6) when "001",
						data(5) when "010",
						data(4) when "011",
						data(3) when "100",
						data(2) when "101",
						data(1) when "110",
						data(0) when "111",
						'0' when others;
						
end Behavioral;


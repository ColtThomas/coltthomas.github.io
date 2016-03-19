----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:45:01 02/06/2016 
-- Design Name: 
-- Module Name:    vga_timing - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;


entity vga_timing is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           hs : out  STD_LOGIC;
           vs : out  STD_LOGIC;
           pixel_x : out  STD_LOGIC_VECTOR (9 downto 0);
           pixel_y : out  STD_LOGIC_VECTOR (9 downto 0);
           last_column : out  STD_LOGIC;
           last_row : out  STD_LOGIC;
           blank : out  STD_LOGIC);
end vga_timing;

architecture Behavioral of vga_timing is
	signal pixel_enable: std_logic := '1'; 
	signal pixel_enable_next: std_logic := '0';
--	signal r_reg, r_next: std_logic :='0';
	signal pixel_x_current, pixel_y_current : unsigned(9 downto 0) := (others=>'0');
	signal vertical_enable, horizontal_enable: std_logic;
	

begin
	-- Register to generate 25MHz
	process(clk)
	begin
		if(clk'event and clk='1') then
			pixel_enable <= pixel_enable_next;
		end if;
	end process;

		-- Next state logic pixel_enable
		pixel_enable_next<= not pixel_enable;
	

	-- Horizontal Pixel Counter
	counter_horizontal: entity work.mod_n_counter(behavioral)
		generic map(n=>800,width=>10)
		port map(clk =>clk, reset=>rst , en=>horizontal_enable,q =>pixel_x_current);
	
		-- Next state logic
		last_column <= '1' when (pixel_x_current=639) else
							'0';
		horizontal_enable <= pixel_enable;
		-- Output logic
			pixel_x <= std_logic_vector(pixel_x_current);
		-- Pixel is in retrace phase when pixel_x > 639.
		-- Front porch count is 16, Back porch count is 48.
		-- Pulse width is 96 counts
		hs <= '0' when (pixel_x_current>655 and pixel_x_current<752) else
				'1';
		
	-- Vertical Pixel Counter
	counter_vertical: entity work.mod_n_counter(behavioral)
		generic map(n=>521,width=>10)
		port map(clk =>clk, reset=>rst , en=>vertical_enable,q =>pixel_y_current);
		
		-- Next state logic
		last_row <= '1' when (pixel_y_current=479) else
							'0';
		vertical_enable <= '1' when (pixel_enable='1' and pixel_x_current=799) else
									'0';
		-- Output logic
		pixel_y <= std_logic_vector(pixel_y_current);
		
		-- Pixel is in retrace phase when pixel_x > 479
		-- Front porch count is 10, Back porch count is 29.
		-- Pulse width is 2 counts
		vs <= '0' when (pixel_y_current>489 and pixel_y_current<492) else
				'1';
	--Blank Signal Logic
	blank <= '1' when (pixel_x_current>639 or pixel_y_current>479) else
				'0';
end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity durp_top is
	Port ( clk : in  STD_LOGIC;
			  sw : in  STD_LOGIC_VECTOR (7 downto 0);
			  btn: in  STD_LOGIC_VECTOR (3 downto 0);
           	seg : out  STD_LOGIC_VECTOR (6 downto 0);
          	dp : out  STD_LOGIC;
           	an : out  STD_LOGIC_VECTOR (3 downto 0);
			led :out std_logic_vector(1 downto 0);
			Hsync : out  STD_LOGIC;
           Vsync : out  STD_LOGIC;
           vgaRed : out  STD_LOGIC_VECTOR (2 downto 0);
           vgaGreen : out  STD_LOGIC_VECTOR (2 downto 0);
           vgaBlue : out  STD_LOGIC_VECTOR (1 downto 0));
			  
end durp_top;

architecture Behavioral of durp_top is
	signal pixel_out,char_we,blank_vga:std_logic;
	signal Hsync_out, Vsync_out : std_logic;
	signal blank: std_logic_vector(3 downto 0);
	signal sync_reg,sync_next: std_logic_vector(3 downto 0);
	signal data_in: std_logic_vector(15 downto 0) := (others=>'0');
	signal pixel_x,pixel_y: std_logic_vector(9 downto 0);
	signal background_rgb,rgb_out: std_logic_vector(7 downto 0);
	signal write_reg,write_next : unsigned(23 downto 0) := to_unsigned(0,23);
	signal char_y_reg,char_y_next: unsigned(4 downto 0) := to_unsigned(0,5);
	signal char_x_reg,char_x_next: unsigned(6 downto 0) :=to_unsigned(0,7);
	signal char_addr : STD_LOGIC_VECTOR (11 downto 0);
	
	type state_durp is (idle,waiting,enable);
	signal state_reg,state_next : state_durp :=idle;
begin
	--reset button
	-- just plugged in btn(3) as the reset
	
	--VGA timing controller
	vga_timer_thing: entity work.vga_timing(behavioral)
		port map(clk=>clk,rst=>btn(3),hs=>Hsync_out,vs=>Vsync_out,pixel_x =>pixel_x,pixel_y =>pixel_y,blank=>blank_vga);

			-- buffer registers
			process(clk) --reset?
			begin
				if(clk'event and clk='1') then
					sync_reg<=sync_next;
				end if;
			end process;
			sync_next <= sync_reg(1 downto 0) & Hsync_out & Vsync_out;
			Hsync<=sync_reg(3);
			Vsync<=sync_reg(2);
			
			
	-- charater generator
	-- does this have to be reset as well?
	charGen: entity work.charGen(Behavioral)
		Port Map( clk=>clk, 
           char_we =>char_we,
           char_value =>sw,
           char_addr =>char_addr,
           pixel_x=>pixel_x,
           pixel_y =>pixel_y,
           pixel_out=>pixel_out);
			  
	-- sev seg disp
	seven_seg_ctrl: entity work.seven_segment_control(behavioral)
	port map(clk=>clk,data_in=>data_in,dp_in=>"0000",blank=>blank,seg=>seg,dp=>dp,an=>an);
	data_in <= "00000000" & sw;
	blank <= "1111" when (btn(3)='1') else
				"1100";	
	-- RGB stuff from pixel out
	background_rgb <= "00000000";
	rgb_out <=  "00000000" when btn(3)='1' else
					"00000000" when blank_vga='1' else
					"11100000" when pixel_out='1' else
					background_rgb;
	-- You may need to buffer outputs here
	vgaRed <= rgb_out(7 downto 5);
	vgaGreen <= rgb_out(4 downto 2);
	vgaBlue <= rgb_out(1 downto 0);
	--the write enable switches->memory. add delay for debounce
	process(clk,btn(3))
	begin
		if(btn(3)='1') then
			write_reg <= (others=>'0');
			state_reg <= idle;
		elsif(clk'event and clk='1') then
			write_reg <= write_next;
			state_reg <= state_next;
		end if;
	end process;

	-- the STATE MONTAGE
	process(state_reg,write_reg,btn(0),char_x_reg,char_y_reg)
	begin
	state_next<=state_reg;
	write_next<=write_reg;
	char_x_next<=char_x_reg;
	char_y_next<=char_y_reg;
	char_we<='0';
	led<="00";
		case state_reg is
			when idle =>
				if(btn(0)='1') then
					state_next<=waiting;
				end if;
			when waiting =>
				write_next<=write_reg +1;
				led(0)<='1';
				if(write_reg>=25_000_00) then
					if(btn(0)='1') then
						state_next<= enable;
						write_next<=(others=>'0');
					else
						state_next<=idle;
					end if;
				else
						state_next<=waiting;
				end if;
			when enable =>
				led(1)<='1';
				char_we<='1';
				if(btn(0)='0') then
					state_next<=idle;
				end if;
				if(char_x_reg=79) then	
					char_x_next<=(others=>'0');
					if(char_y_reg=29) then
						char_y_next<= (others=>'0');
					else
						char_y_next<= char_y_Reg+1;
					end if;
				else
					char_x_next<=char_x_reg+1;
				end if;
		end case;
	end process;
	
	
	-- register that indicates the character column and character row where new characters could be written
	process(clk,btn(3))
	begin
		if(btn(3)='1') then
			char_x_reg<=(others=>'0');
			char_y_reg<=(others=>'0');
		elsif(clk'event and clk='1') then
			char_x_reg<=char_x_next;
			char_y_reg<=char_y_next;		
		end if;
	end process;
	
	char_addr <= std_logic_vector(char_y_reg & char_x_reg);
end Behavioral;


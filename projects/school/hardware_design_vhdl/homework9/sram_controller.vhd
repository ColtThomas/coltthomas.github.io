library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;




-- The SRAM controller

entity SRAMcontroller is
	 generic(
		CLK_RATE: natural := 50_000_000
		);
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           addr : in  STD_LOGIC_VECTOR (22 downto 0);
           data_m2s : in  STD_LOGIC_VECTOR (15 downto 0);
           mem : in  STD_LOGIC;
           rw : in  STD_LOGIC;
           data_s2m : out  STD_LOGIC_VECTOR (15 downto 0);
           data_valid : out  STD_LOGIC;
           ready : out  STD_LOGIC;
           MemAdr : out  STD_LOGIC_VECTOR (22 downto 0);
           MemOE : out  STD_LOGIC;
           MemWr : out  STD_LOGIC;
           RamCS : out  STD_LOGIC;
           RamLB : out  STD_LOGIC;
           RamUB : out  STD_LOGIC;
           RamClk : out  STD_LOGIC;
           RamAdv : out  STD_LOGIC;
           RamCre : out  STD_LOGIC;
           MemDb : inout  STD_LOGIC_VECTOR (15 downto 0));
end SRAMcontroller;

architecture Behavioral of SRAMcontroller is
	-- connections
	signal tri_en: std_logic;
--	signal din, dout: std_logic_vector(15 downto 0)  := (others=>'0');
	-- registers
	signal Raddr_reg,Raddr_next: STD_LOGIC_VECTOR (22 downto 0) := (others=>'0');
	signal Rm2s_reg,Rs2m_reg,Rm2s_next,Rs2m_next: STD_LOGIC_VECTOR (15 downto 0) := (others=>'0');
	signal Pwr_timer_reg,Pwr_timer_next: unsigned(13 downto 0) := to_unsigned(0,14); -- This is what determines how long to wait for CE enable
	-- state machine vars
	type state_type is
		(power_up,idle,r1,r2,r3,r4,r5,w1,w2,w3,w4,w5,w6,w7);
	signal state_reg, state_next: state_type := power_up;
begin
-- tri_en buffer
MemDb<= Rm2s_reg when tri_en = '1' else (others => 'Z'); -- Consider a buffer on this

-- Registers
process(clk,rst)
begin
	if(rst='1') then
		state_reg <= power_up;
		Rm2s_reg <= (others=>'0');
		Rs2m_reg <= (others=>'0');
		Raddr_reg <= (others=>'0');
		Pwr_timer_reg <= to_unsigned(0,14);
	elsif (clk'event and clk='1') then
		state_reg <= state_next;
		Rm2s_reg <= Rm2s_next;
		Rs2m_reg <= Rs2m_next;
		Raddr_reg <= Raddr_next;
		Pwr_timer_reg <= Pwr_timer_next;
	end if;
end process;


-- The finite state machine
process(state_reg,mem,rw,pwr_timer_reg,Raddr_reg,Rs2m_reg,Rm2s_reg,addr,data_m2s,MemDb)
begin
	ready<='0';
	RamCS<='0';
	data_valid<='0';
	MemAdr <= Raddr_reg;
	MemOE <= '1';
	MemWR <= '1';
	tri_en<='0';
	RamLB<='0';
	RamUB<='0';
	data_s2m <= Rs2m_reg;
	-- reg assignments
	state_next <= state_reg;
	Rm2s_next <= Rm2s_reg;
	Rs2m_next <= Rs2m_reg;
	Raddr_next <= Raddr_reg;
	Pwr_timer_next <= Pwr_timer_reg;
	
	case state_reg is
		when power_up=>
			RamCS<='1';
			if(pwr_timer_reg >= to_unsigned(7500,14)) then
				state_next <= idle;
			else
				pwr_timer_next <= pwr_timer_reg +1;
				state_next <= power_up;
			end if;
		when idle=> 
			ready<='1';
			if(mem='0') then
				if(rw='1') then
					Raddr_next <= addr;
					state_next <= r1;
				else
					Raddr_next <= addr;
					Rm2s_next <= data_m2s;
					state_next <= w1;
				end if;
			else
				state_next <= idle;
			end if;
		when r1=>
			state_next <= r2;
		when r2=> 
			MemOE <= '0';
			state_next <= r3;
		when r3=> 
			MemOE <= '0';
			state_next <= r4;
		when r4=> 
			MemOE <= '0';
			state_next <= r5;
		when r5=> 
			MemOE <= '0';
			Rs2m_next <= MemDb; -- Check this variable
			data_valid<='1';
			state_next <= idle;
		when w1=> 
			MemWR <= '1';
			state_next <= w2;
		when w2=> 
			tri_en<='1';
			MemWR <= '1';
			state_next <= w3;
		when w3=> 
			tri_en<='1';
			MemWR <= '0';
			state_next <= w4;
		when w4=> 
			tri_en<='1';
			MemWR <= '0';
			state_next <= w5;
		when w5=> 
			tri_en<='1';
			MemWR <= '0';
			state_next <= w6;
		when w6=> 
			tri_en<='1';
			MemWR <= '0';
			state_next <= w7;
		when w7=>
			tri_en<='1';
			MemWR <= '1';
			state_next <= idle;
	end case;
end process;


-- These signals are not being used for asynchronous memory read and write
RamCLK <= '0';
RamADV<='0';
RamCre<='0';


end Behavioral;


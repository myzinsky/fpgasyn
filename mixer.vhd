----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:33:08 07/01/2010 
-- Design Name: 
-- Module Name:    mixer - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mixer is
	Port (
		clk 	  	: in 	std_logic;
		-- Output Mix
		mix_out	  	: out  	STD_LOGIC_VECTOR (11 downto 0) := "100000000000";
		-- Commands
		key		: in	std_logic_vector(7 downto 0 );
		valid		: in	std_logic;
		start		: in	std_logic;
		stop		: in	std_logic;
		panic		: in	std_logic;
		instrument	: in    std_logic_vector(7 downto 0);
		-- test
		led		: out   std_logic_vector(7 downto 0)
	     );
end mixer;

architecture Behavioral of mixer is

component osc is
    port(
            rst    	: in  STD_LOGIC;
            clk    	: in  STD_LOGIC;
            enable 	: in  STD_LOGIC;
            --key    	: in  STD_LOGIC_VECTOR (7 downto 0);
            instrument	: in  STD_LOGIC_VECTOR (7 downto 0);
            busy 	: out STD_LOGIC;
            output 	: out STD_LOGIC_VECTOR (11 downto 0) := "100000000000";
	    -- from/to arbiter
            ack 	: in  STD_LOGIC := '0';
	    rec         : in  integer range 0 to 909091;
            saw_n       : in  integer range 0 to 1818181;
            saw_m       : in  integer range 0 to 1417
    	);
end component;

component arbiter is
port(
	clk	: in  std_logic;
	rst	: in  std_logic;
	-- Control Signals ----------------------------------
	key_1	: in  std_logic_vector(7 downto 0);
	req_1	: in  std_logic;
	ack_1	: out std_logic;
	key_2	: in  std_logic_vector(7 downto 0);
	req_2	: in  std_logic;
	ack_2	: out std_logic;
	key_3	: in  std_logic_vector(7 downto 0);
	req_3	: in  std_logic;
	ack_3	: out std_logic;
	key_4	: in  std_logic_vector(7 downto 0);
	req_4	: in  std_logic;
	ack_4	: out std_logic;
	key_5	: in  std_logic_vector(7 downto 0);
	req_5	: in  std_logic;
	ack_5	: out std_logic;
	key_6	: in  std_logic_vector(7 downto 0);
	req_6	: in  std_logic;
	ack_6	: out std_logic;
	key_7	: in  std_logic_vector(7 downto 0);
	req_7	: in  std_logic;
	ack_7	: out std_logic;
	key_8	: in  std_logic_vector(7 downto 0);
	req_8	: in  std_logic;
	ack_8	: out std_logic;
	-- Data Output --------------------------------------
	rec     : out integer range 0 to 909091;
        saw_n   : out integer range 0 to 1818181;
        saw_m   : out integer range 0 to 1417
);
end component;



-- How many oscillators are active
signal osc_counter 	: integer range 0 to 7 := 0;

-- Store Signals
signal osc_1_key	: std_logic_vector (7 downto 0) := X"00";
signal osc_2_key	: std_logic_vector (7 downto 0) := X"00";
signal osc_3_key	: std_logic_vector (7 downto 0) := X"00";
signal osc_4_key	: std_logic_vector (7 downto 0) := X"00";
signal osc_5_key	: std_logic_vector (7 downto 0) := X"00";
signal osc_6_key	: std_logic_vector (7 downto 0) := X"00";
signal osc_7_key	: std_logic_vector (7 downto 0) := X"00";
signal osc_8_key	: std_logic_vector (7 downto 0) := X"00";
signal osc_1_enable	: std_logic := '0';
signal osc_2_enable	: std_logic := '0';
signal osc_3_enable	: std_logic := '0';
signal osc_4_enable	: std_logic := '0';
signal osc_5_enable	: std_logic := '0';
signal osc_6_enable	: std_logic := '0';
signal osc_7_enable	: std_logic := '0';
signal osc_8_enable	: std_logic := '0';
signal osc_1_busy	: std_logic := '0';
signal osc_2_busy	: std_logic := '0';
signal osc_3_busy	: std_logic := '0';
signal osc_4_busy	: std_logic := '0';
signal osc_5_busy	: std_logic := '0';
signal osc_6_busy	: std_logic := '0';
signal osc_7_busy	: std_logic := '0';
signal osc_8_busy	: std_logic := '0';
signal arbiter_ack_1	: std_logic := '0';
signal arbiter_ack_2	: std_logic := '0';
signal arbiter_ack_3	: std_logic := '0';
signal arbiter_ack_4	: std_logic := '0';
signal arbiter_ack_5	: std_logic := '0';
signal arbiter_ack_6	: std_logic := '0';
signal arbiter_ack_7	: std_logic := '0';
signal arbiter_ack_8	: std_logic := '0';
signal arbiter_req_1	: std_logic := '0';
signal arbiter_req_2	: std_logic := '0';
signal arbiter_req_3	: std_logic := '0';
signal arbiter_req_4	: std_logic := '0';
signal arbiter_req_5	: std_logic := '0';
signal arbiter_req_6	: std_logic := '0';
signal arbiter_req_7	: std_logic := '0';
signal arbiter_req_8	: std_logic := '0';

signal rec   : integer range 0 to 909091;
signal saw_n : integer range 0 to 1818181;
signal saw_m : integer range 0 to 1417;

-- Output
signal output_1 	: std_logic_vector (11 downto 0)	:= "100000000000";
signal output_2 	: std_logic_vector (11 downto 0)	:= "100000000000";
signal output_3 	: std_logic_vector (11 downto 0)	:= "100000000000";
signal output_4 	: std_logic_vector (11 downto 0)	:= "100000000000";
signal output_5 	: std_logic_vector (11 downto 0)	:= "100000000000";
signal output_6 	: std_logic_vector (11 downto 0)	:= "100000000000";
signal output_7 	: std_logic_vector (11 downto 0)	:= "100000000000";
signal output_8 	: std_logic_vector (11 downto 0)	:= "100000000000";
signal mix : unsigned (11 downto 0) 				:= "100000000000";

begin

Inst_arbiter: arbiter PORT MAP(
	clk   => clk,
	rst   => '0',
	key_1 => osc_1_key,
	req_1 => arbiter_req_1,
	ack_1 => arbiter_ack_1,
	key_2 => osc_2_key,
	req_2 => arbiter_req_2,
	ack_2 => arbiter_ack_2,
	key_3 => osc_3_key,
	req_3 => arbiter_req_3,
	ack_3 => arbiter_ack_3,
	key_4 => osc_4_key,
	req_4 => arbiter_req_4,
	ack_4 => arbiter_ack_4,
	key_5 => osc_5_key,
	req_5 => arbiter_req_5,
	ack_5 => arbiter_ack_5,
	key_6 => osc_6_key,
	req_6 => arbiter_req_6,
	ack_6 => arbiter_ack_6,
	key_7 => osc_7_key,
	req_7 => arbiter_req_7,
	ack_7 => arbiter_ack_7,
	key_8 => osc_8_key,
	req_8 => arbiter_req_8,
	ack_8 => arbiter_ack_8,
	rec   => rec,
	saw_n => saw_n,
	saw_m => saw_m
);

osc_1 : osc
port map(
	rst => '0',
	clk => clk,
	enable => osc_1_enable,
	--key => osc_1_key,
	output => output_1,
	busy => osc_1_busy,
	ack   => arbiter_ack_1,
	rec   => rec,
	saw_n => saw_n,
	saw_m => saw_m,
	instrument => instrument
);

osc_2 : osc
port map(
	rst => '0',
	clk => clk,
	enable => osc_2_enable,
	--key => osc_2_key,
	output => output_2,
	busy => osc_2_busy,
	ack   => arbiter_ack_2,
	rec   => rec,
	saw_n => saw_n,
	saw_m => saw_m,
	instrument => instrument
);

osc_3 : osc
port map(
	rst => '0',
	clk => clk,
	enable => osc_3_enable,
	--key => osc_3_key,
	output => output_3,
	busy => osc_3_busy,
	ack   => arbiter_ack_3,
	rec   => rec,
	saw_n => saw_n,
	saw_m => saw_m,
	instrument => instrument
);

osc_4 : osc
port map(
	rst => '0',
	clk => clk,
	enable => osc_4_enable,
	--key => osc_4_key,
	output => output_4,
	busy => osc_4_busy,
	ack   => arbiter_ack_4,
	rec   => rec,
	saw_n => saw_n,
	saw_m => saw_m,
	instrument => instrument
);

osc_5 : osc
port map(
	rst => '0',
	clk => clk,
	enable => osc_5_enable,
	--key => osc_5_key,
	output => output_5,
	busy => osc_5_busy,
	ack   => arbiter_ack_5,
	rec   => rec,
	saw_n => saw_n,
	saw_m => saw_m,
	instrument => instrument
);

osc_6 : osc
port map(
	rst => '0',
	clk => clk,
	enable => osc_6_enable,
	--key => osc_6_key,
	output => output_6,
	busy => osc_6_busy,
	ack   => arbiter_ack_6,
	rec   => rec,
	saw_n => saw_n,
	saw_m => saw_m,
	instrument => instrument
);

osc_7 : osc
port map(
	rst => '0',
	clk => clk,
	enable => osc_7_enable,
	--key => osc_7_key,
	output => output_7,
	busy => osc_7_busy,
	ack   => arbiter_ack_7,
	rec   => rec,
	saw_n => saw_n,
	saw_m => saw_m,
	instrument => instrument
);

osc_8 : osc
port map(
	rst => '0',
	clk => clk,
	enable => osc_8_enable,
	--key => osc_8_key,
	output => output_8,
	busy => osc_8_busy,
	ack   => arbiter_ack_8,
	rec   => rec,
	saw_n => saw_n,
	saw_m => saw_m,
	instrument => instrument
);


mix_out <= std_logic_vector(mix);
led <= osc_1_busy & osc_2_busy & osc_3_busy & osc_4_busy & osc_5_busy & osc_6_busy & osc_7_busy & osc_8_busy;
--led <= instrument;

	input_process : process(clk)
	begin
		if rising_edge(clk) then
			-- When a Command arrives
			if panic = '1' then
				osc_counter <= 0;
				osc_1_enable <= '0';
				osc_1_key    <= X"00";
				arbiter_req_1<= '0';
				osc_2_enable <= '0';
				osc_2_key    <= X"00";
				arbiter_req_2<= '0';
				osc_3_enable <= '0';
				osc_3_key    <= X"00";
				arbiter_req_3<= '0';
				osc_3_enable <= '0';
				osc_3_key    <= X"00";
				arbiter_req_3<= '0';
				osc_4_enable <= '0';
				osc_4_key    <= X"00";
				arbiter_req_4<= '0';
				osc_5_enable <= '0';
				osc_5_key    <= X"00";
				arbiter_req_5<= '0';
				osc_6_enable <= '0';
				osc_6_key    <= X"00";
				arbiter_req_6<= '0';
				osc_7_enable <= '0';
				osc_7_key    <= X"00";
				arbiter_req_7<= '0';
				osc_8_enable <= '0';
				osc_8_key    <= X"00";
				arbiter_req_7<= '0';
			elsif valid = '1' then
				-- When a Key is pressed
				if start = '1' then
					-- Maximal 8 keys can be pressed at the same time
					if osc_counter < 8 then
						if osc_1_busy = '0' then
							osc_1_enable <= '1';
							osc_1_key <= key;
							osc_counter <= osc_counter + 1;
							arbiter_req_1<= '1';
						elsif osc_2_busy = '0' then
							osc_2_enable <= '1';
							osc_2_key <= key;
							osc_counter <= osc_counter + 1;
							arbiter_req_2<= '1';
						elsif osc_3_busy = '0' then
							osc_3_enable <= '1';
							osc_3_key <= key;
							osc_counter <= osc_counter + 1;
							arbiter_req_3<= '1';
						elsif osc_4_busy = '0' then
							osc_4_enable <= '1';
							osc_4_key <= key;
							osc_counter <= osc_counter + 1;
							arbiter_req_4<= '1';
						elsif osc_5_busy = '0' then
							osc_5_enable <= '1';
							osc_5_key <= key;
							osc_counter <= osc_counter + 1;
							arbiter_req_5<= '1';
						elsif osc_6_busy = '0' then
							osc_6_enable <= '1';
							osc_6_key <= key;
							osc_counter <= osc_counter + 1;
							arbiter_req_6<= '1';
						elsif osc_7_busy = '0' then
							osc_7_enable <= '1';
							osc_7_key <= key;
							osc_counter <= osc_counter + 1;
							arbiter_req_7<= '1';
						elsif osc_8_busy = '0' then
							osc_8_enable <= '1';
							osc_8_key <= key;
							osc_counter <= osc_counter + 1;
							arbiter_req_8<= '1';
						end if;
					end if;
				end if;
				-- When a Key is released
				if stop = '1' then
					if osc_1_key = key then
						osc_1_enable <= '0';
						osc_1_key <= (others => '0');
						osc_counter <= osc_counter - 1;
					elsif osc_2_key = key then
						osc_2_enable <= '0';
						osc_2_key <= (others => '0');
						osc_counter <= osc_counter - 1;
					elsif osc_3_key = key then
						osc_3_enable <= '0';
						osc_3_key <= (others => '0');
						osc_counter <= osc_counter - 1;
					elsif osc_4_key = key then
						osc_4_enable <= '0';
						osc_4_key <= (others => '0');
						osc_counter <= osc_counter - 1;
					elsif osc_5_key = key then
						osc_5_enable <= '0';
						osc_5_key <= (others => '0');
						osc_counter <= osc_counter - 1;
					elsif osc_6_key = key then
						osc_6_enable <= '0';
						osc_6_key <= (others => '0');
						osc_counter <= osc_counter - 1;
					elsif osc_7_key = key then
						osc_7_enable <= '0';
						osc_7_key <= (others => '0');
						osc_counter <= osc_counter - 1;
					elsif osc_8_key = key then
						osc_8_enable <= '0';
						osc_8_key <= (others => '0');
						osc_counter <= osc_counter - 1;
					end if;
				end if;
			end if;
		end if;
	end process;

   -- Clock process definitions
   output_process :process(clk)
   begin
   	if rising_edge(clk) then
			mix <=  unsigned("000"&output_1(11 downto 3)) +
			        unsigned("000"&output_2(11 downto 3)) +
			        unsigned("000"&output_3(11 downto 3)) +
			        unsigned("000"&output_4(11 downto 3)) +
			        unsigned("000"&output_5(11 downto 3)) +
			        unsigned("000"&output_6(11 downto 3)) +
			        unsigned("000"&output_7(11 downto 3)) +
			        unsigned("000"&output_8(11 downto 3));
	end if;
   end process;

end Behavioral;


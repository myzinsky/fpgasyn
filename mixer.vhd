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
            key    	: in  STD_LOGIC_VECTOR (7 downto 0);
            instrument	: in  STD_LOGIC_VECTOR (7 downto 0);
            busy 	: out STD_LOGIC;
            output 	: out STD_LOGIC_VECTOR (11 downto 0) := "100000000000"
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

osc_1 : osc
port map(
	rst => '0',
	clk => clk,
	enable => osc_1_enable,
	key => osc_1_key,
	output => output_1,
	busy => osc_1_busy,
	instrument => instrument
);

osc_2 : osc
port map(
	rst => '0',
	clk => clk,
	enable => osc_2_enable,
	key => osc_2_key,
	output => output_2,
	busy => osc_2_busy,
	instrument => instrument
);

osc_3 : osc
port map(
	rst => '0',
	clk => clk,
	enable => osc_3_enable,
	key => osc_3_key,
	output => output_3,
	busy => osc_3_busy,
	instrument => instrument
);

osc_4 : osc
port map(
	rst => '0',
	clk => clk,
	enable => osc_4_enable,
	key => osc_4_key,
	output => output_4,
	busy => osc_4_busy,
	instrument => instrument
);

osc_5 : osc
port map(
	rst => '0',
	clk => clk,
	enable => osc_5_enable,
	key => osc_5_key,
	output => output_5,
	busy => osc_5_busy,
	instrument => instrument
);

osc_6 : osc
port map(
	rst => '0',
	clk => clk,
	enable => osc_6_enable,
	key => osc_6_key,
	output => output_6,
	busy => osc_6_busy,
	instrument => instrument
);

osc_7 : osc
port map(
	rst => '0',
	clk => clk,
	enable => osc_7_enable,
	key => osc_7_key,
	output => output_7,
	busy => osc_7_busy,
	instrument => instrument
);

osc_8 : osc
port map(
	rst => '0',
	clk => clk,
	enable => osc_8_enable,
	key => osc_8_key,
	output => output_8,
	busy => osc_8_busy,
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
				osc_2_enable <= '0';
				osc_2_key    <= X"00";
				osc_3_enable <= '0';
				osc_3_key    <= X"00";
				osc_3_enable <= '0';
				osc_3_key    <= X"00";
				osc_4_enable <= '0';
				osc_4_key    <= X"00";
				osc_5_enable <= '0';
				osc_5_key    <= X"00";
				osc_6_enable <= '0';
				osc_6_key    <= X"00";
				osc_7_enable <= '0';
				osc_7_key    <= X"00";
				osc_8_enable <= '0';
				osc_8_key    <= X"00";
			elsif valid = '1' then
				-- When a Key is pressed
				if start = '1' then
					-- Maximal 8 keys can be pressed at the same time
					if osc_counter < 8 then
						if osc_1_busy = '0' then
							osc_1_enable <= '1';
							osc_1_key <= key;
							osc_counter <= osc_counter + 1;
						elsif osc_2_busy = '0' then
							osc_2_enable <= '1';
							osc_2_key <= key;
							osc_counter <= osc_counter + 1;
						elsif osc_3_busy = '0' then
							osc_3_enable <= '1';
							osc_3_key <= key;
							osc_counter <= osc_counter + 1;
						elsif osc_4_busy = '0' then
							osc_4_enable <= '1';
							osc_4_key <= key;
							osc_counter <= osc_counter + 1;
						elsif osc_5_busy = '0' then
							osc_5_enable <= '1';
							osc_5_key <= key;
							osc_counter <= osc_counter + 1;
						elsif osc_6_busy = '0' then
							osc_6_enable <= '1';
							osc_6_key <= key;
							osc_counter <= osc_counter + 1;
						elsif osc_7_busy = '0' then
							osc_7_enable <= '1';
							osc_7_key <= key;
							osc_counter <= osc_counter + 1;
						elsif osc_8_busy = '0' then
							osc_8_enable <= '1';
							osc_8_key <= key;
							osc_counter <= osc_counter + 1;
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


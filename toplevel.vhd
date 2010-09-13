----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:34:42 04/27/2010 
-- Design Name: 
-- Module Name:    toplevel - Behavioral 
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

entity toplevel is
port
(
    clk 	: in  std_logic;            -- System Clock
    rst 	: in  std_logic;            -- System Reset
    -- Rotory Interface
    rot_a	: in  std_logic;            -- Rotary Interface A
    rot_b	: in  std_logic;            -- Rotary Interface B
    -- SPI Interface
    spi_sdi  	: out std_logic;            -- Data to the DAC
    spi_sdo     : in  std_logic;            -- Data from the DAC
    spi_dac_cs  : out std_logic;            -- DAC Chip Select
    spi_sck  	: out std_logic;            -- SPI Clock
    spi_clr	: out std_logic;            -- Data Clear
    -- Other SPI Compontents to disable
    spi_adc_cs  : out std_logic;
    spi_sfl_cs  : out std_logic;
    spi_amp_cs  : out std_logic;
    spi_sf2_cs  : out std_logic;
    spi_fpg_cs  : out std_logic;
    -- LED Interface
    switches    : in std_logic_vector(3 downto 0) := "0100";
    led	        : out std_logic_vector(7 downto 0):="00000000";  -- Led Signal
    -- Midi Input
    midi_in     : in  std_logic := '0';         -- Midi Input
    midi_through: out  std_logic           	-- Midi Throughput
);
end toplevel;

architecture Behavioral of toplevel is

    ---------------------------------------------------------------------------
    --  Signals   -------------------------------------------------------------
    ---------------------------------------------------------------------------
    
    -- SPI BUS
    signal addr              : std_logic_vector( 3 downto 0) := "1111"; -- an alle
    signal data              : std_logic_vector(11 downto 0) := (others => '0');
    signal send              : std_logic:='0';
    signal received          : std_logic;
    -- Midi
    signal midi_in_1	     : std_logic := '0';
    signal midi_in_2	     : std_logic := '0';
    signal midi_in_3	     : std_logic := '0';
    signal midi_receive	     : std_logic := '0';
    signal midi_receive_old  : std_logic := '0';
    signal midi_do	     : std_logic := '0';
    signal midi_word         : std_logic_vector(7 downto 0) := (others => '0');
    signal midi_word_cnt     : integer range 0 to 7 := 0;
    signal midi_time_cnt     : integer range 0 to 2600 := 0;
    signal midi_debug        : std_logic_vector(7 downto 0);
    signal midi_word_buffer1 : std_logic_vector(7 downto 0) := (others => '0');
    signal midi_word_buffer2 : std_logic_vector(7 downto 0) := (others => '0');
    signal midi_word_buffer3 : std_logic_vector(7 downto 0) := (others => '0');
    -- Mixer
    signal mixer_out         : STD_LOGIC_VECTOR (11 downto 0) := (others => '0');
    signal mixer_key 	     : std_logic_vector(7 downto 0 );
    signal mixer_instrument  : std_logic_vector(7 downto 0 );
    signal mixer_valid	     : std_logic;
    signal mixer_start	     : std_logic;
    signal mixer_stop        : std_logic;
    signal mixer_led         : std_logic_vector(7 downto 0);


    	
    --------------------------------------------------------------------------
    -- Components -------------------------------------------------------------
    ---------------------------------------------------------------------------
	
    COMPONENT mixer
    PORT
    (
    	clk 		: in std_logic;
	mix_out 	: out  STD_LOGIC_VECTOR (11 downto 0) := (others => '0');
	-- Commands
	key 		: in	std_logic_vector(7 downto 0 );
	instrument	: in	std_logic_vector(7 downto 0 );
	valid		: in	std_logic;
	start		: in	std_logic;
	stop    	: in	std_logic;
	led		: out   std_logic_vector(7 downto 0)

    );
    END COMPONENT;

    COMPONENT spi_controller
    PORT
    (
        clk : IN std_logic;
        rst : IN std_logic;
        send : IN std_logic;
        data : IN std_logic_vector(11 downto 0);
        addr : IN std_logic_vector(3 downto 0);
        spi_sdo : IN std_logic;          
        received : OUT std_logic;
        spi_sdi : OUT std_logic;
        spi_dac_cs : OUT std_logic;
        spi_sck : OUT std_logic;
        spi_clr : OUT std_logic
    );
    END COMPONENT;

begin
	
    -- Disable other SPI Devices
    spi_adc_cs <= '1';
    spi_sfl_cs <= '0';
    spi_amp_cs <= '0';
    spi_sf2_cs <= '0';
    spi_fpg_cs <= '0';
	 
    midi_through <= midi_in;
    midi_debug <= midi_word(7 downto 0);
    led <= mixer_led;

    data <= mixer_out;

    send <= '1';

    spi_controller_inst: spi_controller PORT MAP(
    	clk => clk,
    	rst => rst,
    	send => send,
    	received => received,
    	data => data,
    	addr => addr,
    	spi_sdi => spi_sdi,
    	spi_sdo => spi_sdo,
    	spi_dac_cs => spi_dac_cs,
    	spi_sck => spi_sck,
    	spi_clr => spi_clr 
    );
    
    mixer_inst: mixer PORT MAP(
        clk 		=> clk,
	mix_out  	=> mixer_out,
	key 	 	=> mixer_key,	
	instrument	=> mixer_instrument,	
	valid	 	=> mixer_valid,	
	start	 	=> mixer_start,
	stop     	=> mixer_stop,	
	led	 	=> mixer_led

    );

    midi_pro : process(clk)
    begin
        if rising_edge(clk) then
		mixer_valid <= '0';
			mixer_start <= '0';
			mixer_stop  <= '0';
			mixer_key   <= (others => '0');
            -- A midi sequence is detected 
	    if midi_in_3 = '1' and midi_in_2 = '0' and midi_receive = '0' then
                midi_receive <= '1';
		midi_time_cnt <= 2400;		   
		midi_word_cnt <= 0;
		midi_word <= (others => '0');
            end if;
	    -- A midi sequence is received
	    if midi_receive = '1' then
                -- sensing of midi bit
                if midi_time_cnt = 0 then
		    midi_time_cnt <= 1600;		 
                    midi_word(midi_word_cnt) <= midi_in;
		    midi_word_cnt <= midi_word_cnt + 1;
		    if midi_word_cnt = 7 then
                        midi_word_cnt <= 0;
                        midi_receive <= '0';
		        midi_time_cnt <= 2400;
                    end if;
                else	
                    midi_time_cnt <= midi_time_cnt - 1;			    
		end if;
            end if;		    
	    -- A midi sequence is received finish
	    -- Sort Buffers
	    if midi_receive_old = '1' and midi_receive = '0' then
		midi_word_buffer1 <= midi_word;		 
		midi_word_buffer2 <= midi_word_buffer1;		 
		midi_word_buffer3 <= midi_word_buffer2;		 
		midi_do <= '1';
            end if;

	    -- detect and do midi seqenz
            if midi_do = '1' then
                midi_do <= '0';
		if    midi_word_buffer3 = X"90" then -- status 9 (press key) channel 0
		   
		    	mixer_valid <= '1';
			mixer_start <= '1';
			mixer_stop  <= '0';
			mixer_key   <= midi_word_buffer2;


		elsif midi_word_buffer3 = X"80" then -- status 8 (release key) channel 0

		    	mixer_valid <= '1';
			mixer_start <= '0';
			mixer_stop  <= '1';
			mixer_key   <= midi_word_buffer2;
	
		elsif midi_word_buffer2 = X"C0" then -- status C (change instrument) channel 0

			mixer_instrument <= midi_word_buffer1;

		--- elsif midi_word_buffer2 = X"B0" then -- status C (change instrument) channel 0
		--- 	if midi_word_buffer1 =  X"7B" then
		--- 		mixer_panic <= '1';
		--- 	end if;
		end if; 
            end if;


            -- to synchronise midi input
            midi_in_1 <= midi_in;	    
            midi_in_2 <= midi_in_1;	    
            midi_in_3 <= midi_in_2;	    
	    -- to detect end of midi transmission
	    midi_receive_old <= midi_receive;
	end if;
    end process;

end Behavioral;

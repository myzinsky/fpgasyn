----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:03:15 04/27/2010 
-- Design Name: 
-- Module Name:    spi_controller - Behavioral 
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

entity spi_controller is
port(
	 clk      	: in   std_logic;
	 rst      	: in   std_logic;
	 send			: in   std_logic;							 -- Signalise the sending
	 received	: out	 std_logic;							 -- Signalise the trasmission
	 data			: in 	 std_logic_vector(11 downto 0);-- Sending Data
	 addr			: in   std_logic_vector(3  downto 0);-- Sending Address
	 
	 -- SPI INTERFACE --
	 spi_sdi  	: out  std_logic :='0';              -- Data to the DAC
	 spi_sdo 	: in   std_logic;							 -- Data from the DAC
	 spi_dac_cs : out  std_logic :='1';					 -- DAC Chip Select
	 spi_sck  	: out  std_logic :='0';  				 -- SPI Clock
	 spi_clr		: out  std_logic :='1'     			 -- Data Clear
);
end spi_controller;

architecture Behavioral of spi_controller is

	signal clk_div : std_logic_vector (1  downto 0) := "00";
	signal command : std_logic_vector (24 downto 0) := (others => '0');
	signal command_counter : integer range 0 to 24  := 0;
	signal spi_clock_toggle: std_logic := '1';

begin

	spi_clr <= not rst;
	spi_sck <= spi_clock_toggle;
	
	command <= 	"-" & "1111" &                              -- 4 DC
					data(0)& data(1)& data(2 )& data(3 )&  -- \
					data(4)& data(5)& data(6 )& data(7 )&  --  > Data
					data(8)& data(9)& data(10)& data(11)&  -- /
					addr   &  										-- Address
					"1100" ;--&											-- Command, drive output immideatly
					--"11111111";                            -- 8 DC

	transmission : process(clk, rst)
	begin
		if rising_edge(clk) then
			spi_dac_cs <= '1';
			received   <= '0';
			if(send ='1') then
			   if command_counter > 0 then
					spi_dac_cs <= '0';
				end if;
				if spi_clock_toggle = '1' then
					spi_dac_cs <= '0';
					command_counter <= command_counter + 1;
					spi_sdi <= command(command_counter);
					if command_counter = 24 then
						received <= '1';
						command_counter <= 0;
						spi_sdi    <= '0';
					end if;
				end if;
			end if;
			spi_clock_toggle <= not spi_clock_toggle;
		end if;
	end process;

end Behavioral;


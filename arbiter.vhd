----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:04:53 09/16/2010 
-- Design Name: 
-- Module Name:    arbiter - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity arbiter is
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
end arbiter;

architecture Behavioral of arbiter is

	COMPONENT blockrom
	PORT(
		clk   : IN std_logic;
		en    : IN std_logic;
		addr  : IN std_logic_vector(7 downto 0);          
		rec   : out integer range 0 to 909091;
           	saw_n : out integer range 0 to 1818181;
           	saw_m : out integer range 0 to 1417
	);
	END COMPONENT;

	type state_type is (p1,p2,p3,p4,p5,p6,p7,p8);
	signal state : state_type;

	signal ask_1 : std_logic := '0';
	signal ask_2 : std_logic := '0';
	signal ask_3 : std_logic := '0';
	signal ask_4 : std_logic := '0';
	signal ask_5 : std_logic := '0';
	signal ask_6 : std_logic := '0';
	signal ask_7 : std_logic := '0';
	signal ask_8 : std_logic := '0';

	signal en    : std_logic := '0';
	signal addr  : std_logic_vector(7 downto 0);          

begin

	lookup: blockrom PORT MAP(
		clk => clk,
		en => en,
		addr => addr,
		rec => rec,
		saw_n => saw_n,
		saw_m => saw_m 
	);
	
	scheduler : process (clk, rst)
	begin
		if rising_edge(clk) then
			ack_1 <= '0';
			ack_2 <= '0';
			ack_3 <= '0';
			ack_4 <= '0';
			ack_5 <= '0';
			ack_6 <= '0';
			ack_7 <= '0';
			ack_8 <= '0';
			if state = p1 then
				if req_1 = '1' then
					if ask_1 = '0' then
						en    <= '1';
						addr  <= key_1;
						ask_1 <= '1';
					else
						ack_1 <= '1';
						ask_1 <= '0';
						en    <= '0';
						state <= p2;
					end if;
				else
					state <= p2;
				end if;
			elsif state = p2 then
				if req_2 = '1' then
					if ask_2 = '0' then
						en    <= '1';
						addr  <= key_2;
						ask_2 <= '1';
					else
						ack_2 <= '1';
						ask_2 <= '0';
						en    <= '0';
						state <= p3;
					end if;
				else
					state <= p3;
				end if;
			elsif state = p3 then
				if req_3 = '1' then
					if ask_3 = '0' then
						en    <= '1';
						addr  <= key_3;
						ask_3 <= '1';
					else
						ack_3 <= '1';
						ask_3 <= '0';
						en    <= '0';
						state <= p4;
					end if;
				else
					state <= p4;
				end if;
			elsif state = p4 then
				if req_4 = '1' then
					if ask_4 = '0' then
						en    <= '1';
						addr  <= key_4;
						ask_4 <= '1';
					else
						ack_4 <= '1';
						ask_4 <= '0';
						en    <= '0';
						state <= p5;
					end if;
				else
					state <= p5;
				end if;
			elsif state = p5 then
				if req_5 = '1' then
					if ask_5 = '0' then
						en    <= '1';
						addr  <= key_5;
						ask_5 <= '1';
					else
						ack_5 <= '1';
						ask_5 <= '0';
						en    <= '0';
						state <= p6;
					end if;
				else
					state <= p6;
				end if;
			elsif state = p6 then
				if req_6 = '1' then
					if ask_6 = '0' then
						en    <= '1';
						addr  <= key_6;
						ask_6 <= '1';
					else
						ack_6 <= '1';
						ask_6 <= '0';
						en    <= '0';
						state <= p7;
					end if;
				else
					state <= p7;
				end if;
			elsif state = p7 then
				if req_7 = '1' then
					if ask_7 = '0' then
						en    <= '1';
						addr  <= key_7;
						ask_7 <= '1';
					else
						ack_7 <= '1';
						ask_7 <= '0';
						en    <= '0';
						state <= p8;
					end if;
				else
					state <= p8;
				end if;
			elsif state = p8 then
				if req_8 = '1' then
					if ask_8 = '0' then
						en    <= '1';
						addr  <= key_8;
						ask_8 <= '1';
					else
						ack_8 <= '1';
						ask_8 <= '0';
						en    <= '0';
						state <= p1;
					end if;
				else
					state <= p1;
				end if;
			end if;
		end if;
	end process;

end Behavioral;


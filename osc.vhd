library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity osc is
    port(
            rst    	: in  STD_LOGIC;
            clk    	: in  STD_LOGIC;
            enable 	: in  STD_LOGIC := '0';
            --key    	: in  STD_LOGIC_VECTOR (7 downto 0)  := (others => '0');
            instrument 	: in  STD_LOGIC_VECTOR (7 downto 0)  := (others => '0');
            busy 	: out STD_LOGIC := '0';
            output 	: out STD_LOGIC_VECTOR (11 downto 0) := "100000000000";
	    -- from/to arbiter
            ack 	: in  STD_LOGIC := '0';
	    rec         : in  integer range 0 to 909091;
            saw_n       : in  integer range 0 to 1818181;
            saw_m       : in  integer range 0 to 1417
    	);
end osc;

architecture Behavioral of osc is

--    COMPONENT sinus
--    PORT(
--         clk : IN  std_logic;
--         pinc_in : IN  std_logic_vector(47 downto 0);
--         sine : OUT  std_logic_vector(11 downto 0)
--        );
--    END COMPONENT;

    -- Rectangular Signal
    constant freq_min	: integer := 2500000; -- 10Hz	
    signal rec_counter	: integer range 0 to 909091 := 0; 
    signal rec_toggle   : std_logic := '0';
    signal rec_save     : integer range 0 to 909091; 
    signal rec_y	: std_logic_vector(11 downto 0); 

    -- Saw Signal
    signal saw_k	: integer range 0 to 335544  := 0;
    signal saw_m_save	: integer range 0 to 6710    := 147;    --- a
    signal saw_n_save	: integer range 0 to 2500000 := 113636; --- a
    signal saw_y	: std_logic_vector(23 downto 0); 

    -- Triangle Signal
    signal tri_k	: integer range 0 to 335544  := 0;
    signal tri_m_save	: integer range 0 to 6710    := 147;    --- a
    signal tri_n_save	: integer range 0 to 2500000 := 113636; --- a
    signal tri_y	: std_logic_vector(23 downto 0) := "100000000000000000000000"; 
    signal tri_toggle   : std_logic := '0';
    signal tri_enable   : std_logic := '0';

--    -- Sine Signal
--    signal sin_data	: std_logic_vector(47 downto 0) := "000000000000000010010011101001000000010101000000"; 
--    signal sin_y	: std_logic_vector(11 downto 0); 

begin
    
--	osc_sin: sinus
--	PORT MAP(
--			clk => clk,
--			pinc_in => sin_data,
--			sine => sin_y
--        	);

    output <=  saw_y(23 downto 12) when instrument = X"01" else
               tri_y(23 downto 12) when instrument = X"02" else
               rec_y               when instrument = X"00" else
	       "100000000000";

    busy   <=  enable     when instrument = X"01" else
               tri_enable when instrument = X"02" else
               enable;

    get_frequencies : process(clk)
    begin
    	if rising_edge(clk) then
		if ack = '1' then
			rec_save <= rec;
			saw_n_save <= saw_n;
			saw_m_save <= saw_m;
			tri_n_save <= saw_n / 2;
			tri_m_save <= saw_m * 2;
		end if;
	end if;
    end process;

    rec_pro : process(clk)
    begin
        if rising_edge(clk) then
            if enable = '1' then		
                rec_counter <= rec_counter - 1;
                if rec_counter = 0 then
                    rec_counter <= rec_save;--freq;
                    rec_toggle  <= not rec_toggle;
                    if rec_toggle = '1' then
                        rec_y <= (others => '1');
                    else
                        rec_y <= (others => '0');				
                    end if;
                end if;
	    else
                        rec_y <= "100000000000";				
                    	rec_counter <= 0;
            end if;
        end if;
    end process;


    saw_pro : process(clk)
    begin
        if rising_edge(clk) then
            if enable = '1' then		
		if saw_k = saw_n_save then
                    saw_k <= 0;
                else
		    saw_k  <= saw_k + 1;
                end if;
		saw_y <= conv_std_logic_vector((saw_m_save * saw_k),24);
	    else
                        saw_y <= "100000000000000000000000";				
                    	saw_k <= 0;
            end if;
        end if;
    end process;

    tri_pro : process(clk)
    begin
        if rising_edge(clk) then
       	    if enable = '1' then
		    tri_enable <= '1';
		    tri_k <= tri_n_save / 2;
	    end if;
            if tri_enable = '1' then		
		if tri_k = tri_n_save-1 then -- end of triangle
		    tri_toggle <= '1';
		elsif tri_k = 1 then 	-- other end of triangle
		    tri_toggle <= '0';
                end if;
		if tri_toggle = '0' then
		    tri_k  <= tri_k + 1;
		else
		    tri_k  <= tri_k - 1;
		end if;
		if enable = '0' then  -- phase out 

			if tri_y = "100000000000000000000000" then
				tri_enable <= '0';
			elsif tri_y > "100000000000000000000000" then
				tri_y <= tri_y - '1';
			else
				tri_y <= tri_y + '1';
			end if;

		else
			tri_y <= conv_std_logic_vector((tri_m_save * tri_k),24);
		end if;
	    else
                    tri_y <= "100000000000000000000000";
            end if;
        end if;
    end process;

end Behavioral;


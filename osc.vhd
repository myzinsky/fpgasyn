library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity osc is
    port(
            rst    	: in  STD_LOGIC;
            clk    	: in  STD_LOGIC;
            enable 	: in  STD_LOGIC := '0';
            key    	: in  STD_LOGIC_VECTOR (7 downto 0)  := (others => '0');
            instrument 	: in  STD_LOGIC_VECTOR (7 downto 0)  := (others => '0');
            busy 	: out  STD_LOGIC := '0';
            output 	: out STD_LOGIC_VECTOR (11 downto 0) := "100000000000"
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
    signal freq         : integer range 0 to 909091; 
    signal rec_y	: std_logic_vector(11 downto 0); 

    -- Saw Signal
    signal saw_k	: integer range 0 to 335544  := 0;
    signal saw_m	: integer range 0 to 6710    := 147;    --- a
    signal saw_n	: integer range 0 to 2500000 := 113636; --- a
    signal saw_y	: std_logic_vector(23 downto 0); 

    -- Triangle Signal
    signal tri_k	: integer range 0 to 335544  := 0;
    signal tri_m	: integer range 0 to 6710    := 147;    --- a
    signal tri_n	: integer range 0 to 2500000 := 113636; --- a
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
    
    freq <= 5919	when key = X"6C" else
            6313	when key = X"6B" else
            6576	when key = X"6A" else
            7102	when key = X"69" else
            7398	when key = X"68" else
            7891	when key = X"67" else
            8523	when key = X"66" else
            8878	when key = X"65" else
            9470	when key = X"64" else
            9864	when key = X"63" else
            10522	when key = X"62" else
            11364	when key = X"61" else
            11837	when key = X"60" else
            12626	when key = X"5F" else
            13152	when key = X"5E" else
            14205	when key = X"5D" else
            14796	when key = X"5C" else
            15783	when key = X"5B" else
            17045	when key = X"5A" else
            17756	when key = X"59" else
            18939	when key = X"58" else
            19729	when key = X"57" else
            21044	when key = X"56" else
            22727	when key = X"55" else
            23674	when key = X"54" else
            25253	when key = X"53" else
            26305	when key = X"52" else
            28409	when key = X"51" else
            29593	when key = X"50" else
            31566	when key = X"4F" else
            34091	when key = X"4E" else
            35511	when key = X"4D" else
            37879	when key = X"4C" else
            39457	when key = X"4B" else
            42088	when key = X"4A" else
            45455	when key = X"49" else
            47348	when key = X"48" else
            50505	when key = X"47" else
            52609	when key = X"46" else
            56818	when key = X"45" else
            59186	when key = X"44" else
            63131	when key = X"43" else
            68182	when key = X"42" else
            71023	when key = X"41" else
            75758	when key = X"40" else
            78914	when key = X"3F" else
            84175	when key = X"3E" else
            90909	when key = X"3D" else
            94697	when key = X"3C" else
            101010	when key = X"3B" else
            105219	when key = X"3A" else
            113636	when key = X"39" else
            118371	when key = X"38" else
            126263	when key = X"37" else
            136364	when key = X"36" else
            142045	when key = X"35" else
            151515	when key = X"34" else
            157828	when key = X"33" else
            168350	when key = X"32" else
            181818	when key = X"31" else
            189394	when key = X"30" else
            202020	when key = X"2F" else
            210438	when key = X"2E" else
            227273	when key = X"2D" else
            236742	when key = X"2C" else
            252525	when key = X"2B" else
            272727	when key = X"2A" else
            284091	when key = X"29" else
            303030	when key = X"28" else
            315657	when key = X"27" else
            336700	when key = X"26" else
            363636	when key = X"25" else
            378788	when key = X"24" else
            404040	when key = X"23" else
            420875	when key = X"22" else
            454545	when key = X"21" else
            473485	when key = X"20" else
            505051	when key = X"1F" else
            545455	when key = X"1E" else
            568182	when key = X"1D" else
            606061	when key = X"1C" else
            631313	when key = X"1B" else
            673401	when key = X"1A" else
            727273	when key = X"19" else
            757576	when key = X"18" else
            808081	when key = X"17" else
            841751	when key = X"16" else
            909091	when key = X"15";

    saw_n <= 	11837	when key = X"6C" else
		12626	when key = X"6B" else
		13152	when key = X"6A" else
		14204	when key = X"69" else
		14796	when key = X"68" else
		15782	when key = X"67" else
		17045	when key = X"66" else
		17755	when key = X"65" else
		18939	when key = X"64" else
		19728	when key = X"63" else
		21043	when key = X"62" else
		22727	when key = X"61" else
		23674	when key = X"60" else
		25252	when key = X"5F" else
		26304	when key = X"5E" else
		28409	when key = X"5D" else
		29592	when key = X"5C" else
		31565	when key = X"5B" else
		34090	when key = X"5A" else
		35511	when key = X"59" else
		37878	when key = X"58" else
		39457	when key = X"57" else
		42087	when key = X"56" else
		45454	when key = X"55" else
		47348	when key = X"54" else
		50505	when key = X"53" else
		52609	when key = X"52" else
		56818	when key = X"51" else
		59185	when key = X"50" else
		63131	when key = X"4F" else
		68181	when key = X"4E" else
		71022	when key = X"4D" else
		75757	when key = X"4C" else
		78914	when key = X"4B" else
		84175	when key = X"4A" else
		90909	when key = X"49" else
		94696	when key = X"48" else
		101010	when key = X"47" else
		105218	when key = X"46" else
		113636	when key = X"45" else
		118371	when key = X"44" else
		126262	when key = X"43" else
		136363	when key = X"42" else
		142045	when key = X"41" else
		151515	when key = X"40" else
		157828	when key = X"3F" else
		168350	when key = X"3E" else
		181818	when key = X"3D" else
		189393	when key = X"3C" else
		202020	when key = X"3B" else
		210437	when key = X"3A" else
		227272	when key = X"39" else
		236742	when key = X"38" else
		252525	when key = X"37" else
		272727	when key = X"36" else
		284090	when key = X"35" else
		303030	when key = X"34" else
		315656	when key = X"33" else
		336700	when key = X"32" else
		363636	when key = X"31" else
		378787	when key = X"30" else
		404040	when key = X"2F" else
		420875	when key = X"2E" else
		454545	when key = X"2D" else
		473484	when key = X"2C" else
		505050	when key = X"2B" else
		545454	when key = X"2A" else
		568181	when key = X"29" else
		606060	when key = X"28" else
		631313	when key = X"27" else
		673400	when key = X"26" else
		727272	when key = X"25" else
		757575	when key = X"24" else
		808080	when key = X"23" else
		841750	when key = X"22" else
		909090	when key = X"21" else
		946969	when key = X"20" else
		1010101	when key = X"1F" else
		1090909	when key = X"1E" else
		1136363	when key = X"1D" else
		1212121	when key = X"1C" else
		1262626	when key = X"1B" else
		1346801	when key = X"1A" else
		1454545	when key = X"19" else
		1515151	when key = X"18" else
		1616161	when key = X"17" else
		1683501	when key = X"16" else
		1818181	when key = X"15";

	saw_m <= 1417	when key = X"6C" else
		 1328	when key = X"6B" else
		 1275	when key = X"6A" else
		 1181	when key = X"69" else
		 1133	when key = X"68" else
		 1063	when key = X"67" else
		 984	when key = X"66" else
		 944	when key = X"65" else
		 885	when key = X"64" else
		 850	when key = X"63" else
		 797	when key = X"62" else
		 738	when key = X"61" else
		 708	when key = X"60" else
		 664	when key = X"5F" else
		 637	when key = X"5E" else
		 590	when key = X"5D" else
		 566	when key = X"5C" else
		 531	when key = X"5B" else
		 492	when key = X"5A" else
		 472	when key = X"59" else
		 442	when key = X"58" else
		 425	when key = X"57" else
		 398	when key = X"56" else
		 369	when key = X"55" else
		 354	when key = X"54" else
		 332	when key = X"53" else
		 318	when key = X"52" else
		 295	when key = X"51" else
		 283	when key = X"50" else
		 265	when key = X"4F" else
		 246	when key = X"4E" else
		 236	when key = X"4D" else
		 221	when key = X"4C" else
		 212	when key = X"4B" else
		 199	when key = X"4A" else
		 184	when key = X"49" else
		 177	when key = X"48" else
		 166	when key = X"47" else
		 159	when key = X"46" else
		 147	when key = X"45" else
		 141	when key = X"44" else
		 132	when key = X"43" else
		 123	when key = X"42" else
		 118	when key = X"41" else
		 110	when key = X"40" else
		 106	when key = X"3F" else
		 99	when key = X"3E" else
		 92	when key = X"3D" else
		 88	when key = X"3C" else
		 83	when key = X"3B" else
		 79	when key = X"3A" else
		 73	when key = X"39" else
		 70	when key = X"38" else
		 66	when key = X"37" else
		 61	when key = X"36" else
		 59	when key = X"35" else
		 55	when key = X"34" else
		 53	when key = X"33" else
		 49	when key = X"32" else
		 46	when key = X"31" else
		 44	when key = X"30" else
		 41	when key = X"2F" else
		 39	when key = X"2E" else
		 36	when key = X"2D" else
		 35	when key = X"2C" else
		 33	when key = X"2B" else
		 30	when key = X"2A" else
		 29	when key = X"29" else
		 27	when key = X"28" else
		 26	when key = X"27" else
		 24	when key = X"26" else
		 23	when key = X"25" else
		 22	when key = X"24" else
		 20	when key = X"23" else
		 19	when key = X"22" else
		 18	when key = X"21" else
		 17	when key = X"20" else
		 16	when key = X"1F" else
		 15	when key = X"1E" else
		 14	when key = X"1D" else
		 13	when key = X"1C" else
		 13	when key = X"1B" else
		 12	when key = X"1A" else
		 11	when key = X"19" else
		 11	when key = X"18" else
		 10	when key = X"17" else
		 9	when key = X"16" else
		 9	when key = X"15";

	tri_n <= saw_n / 2;
	tri_m <= saw_m * 2;

    rec_pro : process(clk)
    begin
        if rising_edge(clk) then
            if enable = '1' then		
                rec_counter <= rec_counter - 1;
                if rec_counter = 0 then
                    rec_counter <= freq;
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
		if saw_k = saw_n then
                    saw_k <= 0;
                else
		    saw_k  <= saw_k + 1;
                end if;
		saw_y <= conv_std_logic_vector((saw_m * saw_k),24);
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
		    tri_k <= tri_n / 2;
	    end if;
            if tri_enable = '1' then		
		if tri_k = tri_n-1 then -- end of triangle
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
			tri_y <= conv_std_logic_vector((tri_m * tri_k),24);
		end if;
	    else
                    tri_y <= "100000000000000000000000";
            end if;
        end if;
    end process;

end Behavioral;


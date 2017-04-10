--VHDL instantiation template

component testmem is
    port (testmem1_Data: in std_logic_vector(35 downto 0);
        testmem1_Q: out std_logic_vector(35 downto 0);
        testmem1_RdAddress: in std_logic_vector(8 downto 0);
        testmem1_WrAddress: in std_logic_vector(8 downto 0);
        testmem1_RdClock: in std_logic;
        testmem1_RdClockEn: in std_logic;
        testmem1_Reset: in std_logic;
        testmem1_WE: in std_logic;
        testmem1_WrClock: in std_logic;
        testmem1_WrClockEn: in std_logic
    );
    
end component testmem; -- sbp_module=true 
_inst: testmem port map (testmem1_Data => __,testmem1_Q => __,testmem1_RdAddress => __,
            testmem1_WrAddress => __,testmem1_RdClock => __,testmem1_RdClockEn => __,
            testmem1_Reset => __,testmem1_WE => __,testmem1_WrClock => __,
            testmem1_WrClockEn => __);

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.constantes.ALL;


ENTITY topLevel IS
 GENERIC (
   DATA_WIDTH    : NATURAL := 32;
   ROM_DATA_WIDTH: NATURAL := 32;
   ADDR_WIDTH    : NATURAL := 32
 );

 PORT (
   --IN
   FPGA_RESET_N : IN STD_LOGIC;
   SW       : IN std_logic_vector(1 downto 0);
   
   --OUT
   HEX0 : OUT std_logic_vector(6 downto 0);
   HEX1 : OUT std_logic_vector(6 downto 0);
   HEX2 : OUT std_logic_vector(6 downto 0);
   HEX3 : OUT std_logic_vector(6 downto 0);
   HEX4 : OUT std_logic_vector(6 downto 0);
   HEX5 : OUT std_logic_vector(6 downto 0)


 );
END ENTITY;
ARCHITECTURE uwu OF topLevel IS

 SIGNAL selUlA, flagULA, selMuxRsPC        : std_logic;
 SIGNAL endReg3, reg3        : std_logic_vector(4 downto 0);
 SIGNAL palavraControle: std_logic_vector(11 downto 0);
 SIGNAL IR             : STD_LOGIC_VECTOR(ROM_DATA_WIDTH - 1 DOWNTO 0);
 SIGNAL PC, ADDER, outAdder,shiftBeq, outShift, outJUMP, inPC, outRsPC, shift16 : STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
 SIGNAL saidaULA, IMED, entradaB, escReg3, escReg3Def, saidaA, saidaB, dadoRAM, saidaHex: STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
 SIGNAL seletorULA            : STD_LOGIC_VECTOR(2 DOWNTO 0);
 SIGNAL ULAop : std_logic_vector(2 downto 0);

 

 alias selMUXULA     : std_logic is palavraControle(0);
 alias selMUXEndReg3 : std_logic_vector(1 downto 0) is palavraControle(2 downto 1);
 alias selMUXEscReg3 : std_logic_vector(1 downto 0) is palavraControle(4 downto 3);
 alias habEscritaReg : std_logic is palavraControle(5);
 alias habEscritaRAM : std_logic is palavraControle(6);
 alias BEQ           : std_logic is palavraControle(7);
 alias selMUXPC      : std_logic is palavraControle(8);
 alias habShift      : std_logic is palavraControle(9);
 alias BNE           : std_logic is palavraControle(10);
 alias selExt        : std_logic is palavraControle(11);


 CONSTANT incremento : NATURAL := 4;

BEGIN

 ROM: ENTITY work.memoriaROM generic map (dataWidth => DATA_WIDTH, addrWidth => ADDR_WIDTH, memoryAddrWidth => 6)
 PORT MAP(clk => FPGA_RESET_N, Endereco => PC, Dado => IR);

 ProgConter: ENTITY work.registrador generic map (larguraDados => DATA_WIDTH)
 PORT MAP(DIN => inPC, DOUT => PC, ENABLE => '1', CLK => FPGA_RESET_N, RST => '0');

 SHIFTER_JUMP: entity work.shifter generic map (larguraDados => 28, shiftValue => 2 )
 port map(inShift => "00" & IR(25 downto 0), outShift => outShift, habilita => '1');


 SOMADOR_C: ENTITY work.somadorConstante GENERIC MAP(larguraDados => DATA_WIDTH, constante => incremento)
 PORT MAP(entrada => PC, saida => ADDER);

 muxRsPC : entity work.mux2x1 generic map (larguraDados => DATA_WIDTH)         
 port map(entradaA_MUX => outJUMP, entradaB_MUX => saidaA, seletor_MUX => selMuxRsPC, saida_MUX => outRsPC );
 
 
 muxPC : entity work.mux2x1 generic map (larguraDados => DATA_WIDTH)          --ntrada HARDCODED, trocar pro shiftJump e
 port map(entradaA_MUX => outRsPC, entradaB_MUX => ADDER(31 downto 28) & outShift, seletor_MUX => selMUXPC, saida_MUX => inPC );

 
 UC: ENTITY work.unidadeControle generic map (DATA_WIDTH => DATA_WIDTH, ADDR_WIDTH => ADDR_WIDTH)
 PORT MAP(CLK => FPGA_RESET_N, opCode => IR(31 DOWNTO 26), funct => IR(5 downto 0), ULAop => ULAop, palavraControle => palavraControle);
 
 UCula: ENTITY work.unidadeControleULA generic map (DATA_WIDTH => DATA_WIDTH, ADDR_WIDTH => ADDR_WIDTH)
 PORT MAP(CLK => FPGA_RESET_N, funct => IR(5 DOWNTO 0), ULAop => ULAop, JR => selMuxRsPC, seletorULA  => seletorULA);
 
 muxEndREG3: entity work.mux4x1 generic map (larguraDados => 5)
 port map(entradaA_MUX => IR(20 downto 16), entradaB_MUX => IR(15 downto 11), entradaC_MUX => "11111", entradaD_MUX => (others => '0'), seletor_MUX => selMUXEndReg3, saida_MUX => endReg3 );
 
-- endReg3 <= "11111" when IR(31 downto 26) = jal else reg3;
-- escReg3Def <= std_logic_vector(unsigned(PC) + 8) when IR(31 downto 26) = jal else escReg3;
 
 BR: ENTITY work.bancoRegistradores generic map (larguraDados => DATA_WIDTH, larguraEndBancoRegs => 5)
 PORT MAP(clk => FPGA_RESET_N, enderecoA => IR(25 DOWNTO 21), enderecoB => IR(20 DOWNTO 16), enderecoC => endReg3, dadoEscritaC => escReg3, escreveC => habEscritaReg, saidaA => saidaA, saidaB => saidaB );

 EXT: entity work.estendeSinal   generic map (larguraDadoEntrada => 16, larguraDadoSaida => DATA_WIDTH)
 port map (estendeSinal_IN => IR(15 downto 0), seletor=> selExt, estendeSinal_OUT => IMED);

 muxULA: entity work.mux2x1 generic map (larguraDados => DATA_WIDTH)
 port map(entradaA_MUX => saidaB, entradaB_MUX => shift16, seletor_MUX => selMUXULA, saida_MUX => entradaB);
   
 ULAa: ENTITY work.ULA generic map (larguraDados => DATA_WIDTH)
 PORT MAP(entradaA => saidaA , entradaB => entradaB, seletor => seletorULA, saida => saidaULA , flagZ => flagULA);

 RAM: entity work.memoriaRAM generic map (dataWidth => DATA_WIDTH, addrWidth => ADDR_WIDTH, memoryAddrWidth => 6)
 port map(clk => FPGA_RESET_N, Endereco => saidaULA, Dado_in => saidaB , Dado_out => dadoRAM, we => habEscritaRAM);
 
 muxEscREG3: entity work.mux4x1 generic map (larguraDados => DATA_WIDTH)
 port map(entradaA_MUX => saidaULA, entradaB_MUX => dadoRAM, entradaC_MUX => ADDER, entradaD_MUX => (others => '0'), seletor_MUX => selMUXEscReg3, saida_MUX => escReg3);

 SHIFTER_BEQ: entity work.shifter generic map (larguraDados => DATA_WIDTH, shiftValue => 2)
 port map(inShift => shift16, outShift => shiftBeq, habilita => '1');
 
 SOMADOR: entity work.somador  generic map (larguraDados => DATA_WIDTH)
 port map(entradaA => ADDER, entradaB => shiftBeq , saida => outAdder);
 
 muxJUMP: entity work.mux2x1 generic map (larguraDados => DATA_WIDTH)
 port map(entradaA_MUX => ADDER, entradaB_MUX => outAdder, seletor_MUX => ( (flagULA and BEQ) or ((not flagULA) and BNE) ) , saida_MUX => outJUMP );


 SHIFTER_16: entity work.shifter generic map (larguraDados => DATA_WIDTH, shiftValue => 16)
 port map(inShift => IMED, outShift => shift16, habilita => habShift );


 MUXHEX: entity work.mux4x1 generic map (larguraDados => DATA_WIDTH)
 port map(entradaA_MUX => PC, entradaB_MUX => saidaULA , entradaC_MUX => entradaB, entradaD_MUX => saidaA,  seletor_MUX => SW, saida_MUX => saidaHex);

 HEX_0 :  entity work.conversorHex7Seg
 port map(dadoHex => saidaHex(3 downto 0), apaga =>  '0', negativo => '0', overFlow => '0', saida7seg => HEX0);

 HEX_1 :  entity work.conversorHex7Seg
 port map(dadoHex => saidaHex(7 downto 4), apaga =>  '0', negativo => '0', overFlow => '0', saida7seg => HEX1);

 HEX_2 :  entity work.conversorHex7Seg
 port map(dadoHex => saidaHex(11 downto 8), apaga =>  '0', negativo => '0', overFlow => '0', saida7seg => HEX2);

 HEX_3 :  entity work.conversorHex7Seg
 port map(dadoHex => saidaHex(15 downto 12), apaga =>  '0', negativo => '0', overFlow => '0', saida7seg => HEX3);

 HEX_4 :  entity work.conversorHex7Seg
 port map(dadoHex => saidaHex(19 downto 16), apaga =>  '0', negativo => '0', overFlow => '0', saida7seg => HEX4);

 HEX_5 :  entity work.conversorHex7Seg
 port map(dadoHex => saidaHex(23 downto 20), apaga =>  '0', negativo => '0', overFlow => '0', saida7seg => HEX5);



END ARCHITECTURE;
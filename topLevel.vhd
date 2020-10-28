LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY topLevel IS
  GENERIC (
    DATA_WIDTH    : NATURAL := 32;
    ROM_DATA_WIDTH: NATURAL := 32;
    ADDR_WIDTH    : NATURAL := 32
  );

  PORT (
    CLOCK_50 : IN STD_LOGIC
  );
END ENTITY;
ARCHITECTURE uwu OF topLevel IS

  SIGNAL selUlA, flagULA         : std_logic;
  SIGNAL endReg3        : std_logic_vector(4 downto 0);
  SIGNAL palavraControle: std_logic_vector(6 downto 0);
  SIGNAL IR             : STD_LOGIC_VECTOR(ROM_DATA_WIDTH - 1 DOWNTO 0);
  SIGNAL PC, ADDER, outAdder, outShift, outJUMP                        : STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
  SIGNAL RS, saidaULA, IMED, entradaB, escReg3, saidaA, saidaB, dadoRAM: STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
  

  alias selMUXULA     : std_logic is palavraControle(0);
  alias selMUXEndReg3 : std_logic is palavraControle(1);
  alias selMUXEscReg3 : std_logic is palavraControle(2);
  alias habEscritaReg : std_logic is palavraControle(3);
  alias habEscritaRAM : std_logic is palavraControle(4);
  alias selOperacaoULA: std_logic is palavraControle(5);
  alias BEQ           : std_logic is palavraControle(6);

  CONSTANT incremento : NATURAL := 4;

BEGIN

  ROM: ENTITY work.memoriaROM generic map (dataWidth => DATA_WIDTH, addrWidth => ADDR_WIDTH, memoryAddrWidth => 6)
  PORT MAP(clk => CLOCK_50, Endereco => PC, Dado => IR);

  ProgConter: ENTITY work.registrador generic map (larguraDados => DATA_WIDTH)
  PORT MAP(DIN => outJUMP, DOUT => PC, ENABLE => '1', CLK => CLOCK_50, RST => '0');

  SOMADOR_C: ENTITY work.somadorConstante GENERIC MAP(larguraDados => DATA_WIDTH, constante => incremento)
  PORT MAP(entrada => PC, saida => ADDER);

  UC: ENTITY work.unidadeControle generic map (DATA_WIDTH => DATA_WIDTH, ADDR_WIDTH => ADDR_WIDTH)
  PORT MAP(CLK => CLOCK_50, opCode => IR(31 DOWNTO 26), funct => IR(5 DOWNTO 0), palavraControle => palavraControle);

  muxEndREG3: entity work.mux2x1 generic map (larguraDados => 5)
  port map(entradaA_MUX => IR(20 downto 16), entradaB_MUX => IR(15 downto 11), seletor_MUX => selMUXEndReg3, saida_MUX => endReg3 );

  BR: ENTITY work.bancoRegistradores generic map (larguraDados => DATA_WIDTH, larguraEndBancoRegs => 5)
  PORT MAP(clk => CLOCK_50, enderecoA => IR(25 DOWNTO 21), enderecoB => IR(20 DOWNTO 16), enderecoC => endReg3, dadoEscritaC => escReg3, escreveC => habEscritaReg, saidaA => saidaA, saidaB => saidaB );

  EXT: entity work.estendeSinal   generic map (larguraDadoEntrada => 16, larguraDadoSaida => DATA_WIDTH)
  port map (estendeSinal_IN => IR(15 downto 0), estendeSinal_OUT => IMED);

  muxULA: entity work.mux2x1 generic map (larguraDados => DATA_WIDTH)
  port map(entradaA_MUX => saidaA, entradaB_MUX => IMED, seletor_MUX => selMUXULA, saida_MUX => entradaB);
  
  ULA: ENTITY work.ULA generic map (larguraDados => DATA_WIDTH)
  PORT MAP(entradaA => RS , entradaB => entradaB, seletor => selOperacaoULA, saida => saidaULA , flagZ => flagULA);

  RAM: entity work.memoriaRAM generic map (dataWidth => DATA_WIDTH, addrWidth => ADDR_WIDTH, memoryAddrWidth => 6)
  port map(clk => CLOCK_50, Endereco => saidaULA, Dado_in => saidaB , Dado_out => dadoRAM, we => habEscritaRAM);
  
  muxEscREG3: entity work.mux2x1 generic map (larguraDados => DATA_WIDTH)
  port map(entradaA_MUX => saidaULA, entradaB_MUX => dadoRAM, seletor_MUX => selMUXEscReg3, saida_MUX => escReg3);

  SHIFTER: entity work.shifter generic map (larguraDados => DATA_WIDTH)
  port map(inShift => IMED, outShift => outShift);
  
  SOMADOR: entity work.somador  generic map (larguraDados => DATA_WIDTH)
  port map(entradaA => IMED, entradaB => outShift, saida => outAdder);
  
  muxJUMP: entity work.mux2x1 generic map (larguraDados => DATA_WIDTH)
  port map(entradaA_MUX => ADDER, entradaB_MUX => outAdder, seletor_MUX => (flagULA and BEQ ) , saida_MUX => outJUMP );


END ARCHITECTURE;
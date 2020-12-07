library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constantes.all;
entity topLevel is
  generic (
    DATA_WIDTH : natural := 32;
    ROM_DATA_WIDTH : natural := 32;
    ADDR_WIDTH : natural := 32
  );

  port (
    --IN
    FPGA_RESET_N : in std_logic;
    SW : in std_logic_vector(1 downto 0);

    --OUT
    HEX0 : out std_logic_vector(6 downto 0);
    HEX1 : out std_logic_vector(6 downto 0);
    HEX2 : out std_logic_vector(6 downto 0);
    HEX3 : out std_logic_vector(6 downto 0);
    HEX4 : out std_logic_vector(6 downto 0);
    HEX5 : out std_logic_vector(6 downto 0)
  );
end entity;
architecture uwu of topLevel is

  signal selUlA, flagULA, selMuxRsPC : std_logic;
  signal endReg3, reg3 : std_logic_vector(4 downto 0);
  signal palavraControle : std_logic_vector(11 downto 0);
  signal IR : std_logic_vector(ROM_DATA_WIDTH - 1 downto 0);
  signal PC, ADDER, outAdder, shiftBeq, outShift, outJUMP, inPC, outRsPC, shift16 : std_logic_vector(ADDR_WIDTH - 1 downto 0);
  signal saidaULA, IMED, entradaB, escReg3, escReg3Def, saidaA, saidaB, dadoRAM, saidaHex : std_logic_vector(DATA_WIDTH - 1 downto 0);
  signal seletorULA : std_logic_vector(2 downto 0);
  signal ULAop : std_logic_vector(2 downto 0);

  alias selMUXULA : std_logic is palavraControle(0);
  alias selMUXEndReg3 : std_logic_vector(1 downto 0) is palavraControle(2 downto 1);
  alias selMUXEscReg3 : std_logic_vector(1 downto 0) is palavraControle(4 downto 3);
  alias habEscritaReg : std_logic is palavraControle(5);
  alias habEscritaRAM : std_logic is palavraControle(6);
  alias BEQ : std_logic is palavraControle(7);
  alias selMUXPC : std_logic is palavraControle(8);
  alias habShift : std_logic is palavraControle(9);
  alias BNE : std_logic is palavraControle(10);
  alias selExt : std_logic is palavraControle(11);
  constant incremento : natural := 4;

begin

  -- Memória ROM
  ROM : entity work.memoriaROM generic map (dataWidth => DATA_WIDTH, addrWidth => ADDR_WIDTH, memoryAddrWidth => 6)
    port map(clk => FPGA_RESET_N, Endereco => PC, Dado => IR);

  -- Registrador PC
  ProgConter : entity work.registrador generic map (larguraDados => DATA_WIDTH)
    port map(DIN => inPC, DOUT => PC, ENABLE => '1', CLK => FPGA_RESET_N, RST => '0');

  -- PC + 4
  SOMADOR_C : entity work.somadorConstante generic map(larguraDados => DATA_WIDTH, constante => incremento)
    port map(entrada => PC, saida => ADDER);

  -- Seleciona entre R[rs] (instrução jr) ou PC+4/BEQ
  muxRsPC : entity work.mux2x1 generic map (larguraDados => DATA_WIDTH)
    port map(entradaA_MUX => outJUMP, entradaB_MUX => saidaA, seletor_MUX => selMuxRsPC, saida_MUX => outRsPC);

  -- Seleciona entre outMuxRsPC ou instrução j
  muxPC : entity work.mux2x1 generic map (larguraDados => DATA_WIDTH)
    port map(entradaA_MUX => outRsPC, entradaB_MUX => ADDER(31 downto 28) & IR(25 downto 0) & "00", seletor_MUX => selMUXPC, saida_MUX => inPC);

  -- Unidade de controle
  UC : entity work.unidadeControle generic map (DATA_WIDTH => DATA_WIDTH, ADDR_WIDTH => ADDR_WIDTH)
    port map(CLK => FPGA_RESET_N, opCode => IR(31 downto 26), funct => IR(5 downto 0), ULAop => ULAop, palavraControle => palavraControle);

  -- Unidade de controle ULA
  UCula : entity work.unidadeControleULA generic map (DATA_WIDTH => DATA_WIDTH, ADDR_WIDTH => ADDR_WIDTH)
    port map(CLK => FPGA_RESET_N, funct => IR(5 downto 0), ULAop => ULAop, JR => selMuxRsPC, seletorULA => seletorULA);

  -- Seleciona entre R[rt], R[rd] ou #31 (jal)
  muxEndREG3 : entity work.mux4x1 generic map (larguraDados => 5)
    port map(entradaA_MUX => IR(20 downto 16), entradaB_MUX => IR(15 downto 11), entradaC_MUX => "11111", entradaD_MUX => (others => '0'), seletor_MUX => selMUXEndReg3, saida_MUX => endReg3);

  -- Banco com 32 registradores
  BR : entity work.bancoRegistradores generic map (larguraDados => DATA_WIDTH, larguraEndBancoRegs => 5)
    port map(clk => FPGA_RESET_N, enderecoA => IR(25 downto 21), enderecoB => IR(20 downto 16), enderecoC => endReg3, dadoEscritaC => escReg3, escreveC => habEscritaReg, saidaA => saidaA, saidaB => saidaB);

  -- Estende o imediato de 16 para 32 bits. Se habilitado, estende com 0, caso não, estende com o bit mais significativo 
  EXT : entity work.estendeSinal generic map (larguraDadoEntrada => 16, larguraDadoSaida => DATA_WIDTH)
    port map(estendeSinal_IN => IR(15 downto 0), seletor => selExt, estendeSinal_OUT => IMED);

  -- Shifta ou não o sinal vindo do estende sinal vindo do estende sinal para a instrução lui
  SHIFTER_16 : entity work.shifter generic map (larguraDados => DATA_WIDTH, shiftValue => 16)
    port map(inShift => IMED, outShift => shift16, habilita => habShift);

  -- Seleciona a entrada B da ULA entre dado lido reg 2 ou imediato
  muxULA : entity work.mux2x1 generic map (larguraDados => DATA_WIDTH)
    port map(entradaA_MUX => saidaB, entradaB_MUX => shift16, seletor_MUX => selMUXULA, saida_MUX => entradaB);

  -- ULA bit a bit
  ULAa : entity work.ULA generic map (larguraDados => DATA_WIDTH)
    port map(entradaA => saidaA, entradaB => entradaB, seletor => seletorULA, saida => saidaULA, flagZ => flagULA);

  -- Memória RAM
  RAM : entity work.memoriaRAM generic map (dataWidth => DATA_WIDTH, addrWidth => ADDR_WIDTH, memoryAddrWidth => 6)
    port map(clk => FPGA_RESET_N, Endereco => saidaULA, Dado_in => saidaB, Dado_out => dadoRAM, we => habEscritaRAM);

  -- Seleciona o dado a ser escrito no reg 3 entre saída da ula, dado lido da memória RAM ou PC+4 (jal)
  muxEscREG3 : entity work.mux4x1 generic map (larguraDados => DATA_WIDTH)
    port map(entradaA_MUX => saidaULA, entradaB_MUX => dadoRAM, entradaC_MUX => ADDER, entradaD_MUX => (others => '0'), seletor_MUX => selMUXEscReg3, saida_MUX => escReg3);

  -- Shifter para instrução BEQ
  SHIFTER_BEQ : entity work.shifter generic map (larguraDados => DATA_WIDTH, shiftValue => 2)
    port map(inShift => shift16, outShift => shiftBeq, habilita => '1');

  -- Soma (PC+4) com (SigExt(imediato)estendido
  SOMADOR : entity work.somador generic map (larguraDados => DATA_WIDTH)
    port map(entradaA => ADDER, entradaB => shiftBeq, saida => outAdder);

  -- Seleciona entre PC+4 ou ((PC+4) com (SigExt(imediato)estendido)
  muxJUMP : entity work.mux2x1 generic map (larguraDados => DATA_WIDTH)
    port map(entradaA_MUX => ADDER, entradaB_MUX => outAdder, seletor_MUX => ((flagULA and BEQ) or ((not flagULA) and BNE)), saida_MUX => outJUMP);

  -- Sinais a serem mandados para o HEX display
  MUXHEX : entity work.mux4x1 generic map (larguraDados => DATA_WIDTH)
    port map(entradaA_MUX => PC, entradaB_MUX => saidaULA, entradaC_MUX => entradaB, entradaD_MUX => saidaA, seletor_MUX => SW, saida_MUX => saidaHex);

  HEX_0 : entity work.conversorHex7Seg
    port map(dadoHex => saidaHex(3 downto 0), apaga => '0', negativo => '0', overFlow => '0', saida7seg => HEX0);

  HEX_1 : entity work.conversorHex7Seg
    port map(dadoHex => saidaHex(7 downto 4), apaga => '0', negativo => '0', overFlow => '0', saida7seg => HEX1);

  HEX_2 : entity work.conversorHex7Seg
    port map(dadoHex => saidaHex(11 downto 8), apaga => '0', negativo => '0', overFlow => '0', saida7seg => HEX2);

  HEX_3 : entity work.conversorHex7Seg
    port map(dadoHex => saidaHex(15 downto 12), apaga => '0', negativo => '0', overFlow => '0', saida7seg => HEX3);

  HEX_4 : entity work.conversorHex7Seg
    port map(dadoHex => saidaHex(19 downto 16), apaga => '0', negativo => '0', overFlow => '0', saida7seg => HEX4);

  HEX_5 : entity work.conversorHex7Seg
    port map(dadoHex => saidaHex(23 downto 20), apaga => '0', negativo => '0', overFlow => '0', saida7seg => HEX5);

end architecture;
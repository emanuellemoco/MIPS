LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY topLevel IS
  GENERIC (
    DATA_WIDTH : NATURAL := 32;
    ROM_DATA_WIDTH : NATURAL := 32;
    ADDR_WIDTH : NATURAL := 32
  );

  PORT (
    CLOCK_50 : IN STD_LOGIC
  );
END ENTITY;
ARCHITECTURE uwu OF topLevel IS



  SIGNAL PC, ADDER : STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
  SIGNAL IR : STD_LOGIC_VECTOR(ROM_DATA_WIDTH - 1 DOWNTO 0);
  SIGNAL RS, RD, RT : STD_LOGIC_VECTOR(DATA_WIDTH -1 DOWNTO 0);
  SIGNAL selUlA : std_logic;


  CONSTANT incremento : NATURAL := 4;

BEGIN
  --------------------------------------FETCH------------------------------------------

  -----------!!!!!!!!!!!!!!! Qual a diferença entre memoryAddrWidth e addrWidth???  ---------------------------??
  ROM  : ENTITY work.memoriaROM GENERIC MAP(dataWidth => DATA_WIDTH, addrWidth => ADDR_WIDTH, memoryAddrWidth => 6)
    PORT MAP(clk => CLOCK_50, Endereco => PC, Dado => IR);

  ProgConter   : ENTITY work.registrador GENERIC MAP(larguraDados => DATA_WIDTH)
    PORT MAP(DIN => ADDER, DOUT => PC, ENABLE => '1', CLK => CLOCK_50, RST => '0');

  SOMADOR: ENTITY work.somador GENERIC MAP(larguraDados => DATA_WIDTH, constante => incremento)
    PORT MAP(entrada => PC, saida => ADDER);

  UC   : ENTITY work.unidadeControle GENERIC MAP(DATA_WIDTH => DATA_WIDTH, ADDR_WIDTH => ADDR_WIDTH)
    PORT MAP(CLK => CLOCK_50, opCode => IR(31 DOWNTO 26), funct => IR(5 DOWNTO 0), palavraControle => selULA);

  BR   : ENTITY work.bancoRegistradores GENERIC MAP(larguraDados => DATA_WIDTH, larguraEndBancoRegs => 5)
    PORT MAP(clk => CLOCK_50, enderecoA => IR(25 DOWNTO 21), enderecoB => IR(20 DOWNTO 16), enderecoC => IR(15 DOWNTO 11), dadoEscritaC => RD, escreveC => '1', saidaA => open, saidaB => open);

  ULA  : ENTITY work.ULA GENERIC MAP(larguraDados => DATA_WIDTH)
  PORT MAP(entradaA => RS , entradaB => RT , seletor => selULA , saida => RD , flagZero => open);


END ARCHITECTURE;
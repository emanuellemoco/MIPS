library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constantes.all;


entity unidadeControle is
  generic (
    DATA_WIDTH : natural := 8;
    ADDR_WIDTH : natural := 8
  );

  port (
    -- Input ports
    CLK   : in std_logic;
    opcode: in std_logic_vector(5 downto 0);
    funct : in std_logic_vector(5 downto 0);

    -- Output ports
    palavraControle : out std_logic_vector(9 downto 0)
  );
end entity;
architecture arch_name of unidadeControle is

  alias selMUXULA     : std_logic is palavraControle(0);
  alias selMUXEndReg3 : std_logic is palavraControle(1);
  alias selMUXEscReg3 : std_logic is palavraControle(2);
  alias habEscritaReg : std_logic is palavraControle(3);
  alias habEscritaRAM : std_logic is palavraControle(4);
  alias selOperacaoULA: std_logic_vector(2 downto 0) is palavraControle(7 downto 5);
  alias BEQ           : std_logic is palavraControle(8);
  alias selMUXPC      : std_logic is palavraControle(9);


-- TIPO R
-- instR     000000

-- TIPO I   
--  addi     001000 Add immediate  -- ULA
--  andi     001100 And Immediate --ULA
--  beqw     000100 Branch on Equal 
--  bne      000101 Branch on not equal                     ok
--  lui      001111 Load Upper Immediate                    ok
--  lw       100011 Load word                               ok                    
--  ori      001101 Or Immediate  -- ULA
--  slti     001010 Set less than Immediate --?
--  sw       101011 Store word

-- -- TIPO J
-- j         000010 jump
-- jal       000011 jump and link                           metade ok 

 

begin

  -- Instrução R
    selMuxUla     <= '0' when opcode = instR or opcode = beqw or opcode = bne or opcode = sw else 
    '1'; 

  -- Instrução R
  selMUXEndReg3 <= '1' when opcode = instR else 
    '0'; 

  -- Instrução R, lui, addi, andi, ori, slti
  selMUXEscReg3 <= '0' when opcode = instR or opcode = lui or opcode = addi or opcode = andi or opcode = ori or opcode = slti else 
    '1';

  -- Instrução R, lw, lui, addi, andi, ori, slti
  habEscritaReg <= '1' when opcode = instR or opcode = lw or opcode = lui or opcode = addi or opcode = andi or opcode = ori or opcode = slti else 
    '0';
  
  -- sw
  habEscritaRAM <= '1' when opcode = sw else 
    '0';

  -- Instrução R 
  selOperacaoULA<="001" when (opcode = instR and funct = "000000") else 
                  "010" when  (opcode = instR and funct = "000001") else
                  "011" when (opcode = andi) else
                  "100" when (opcode = ori) else  
                  "000";  

  -- Beq
  BEQ           <= '1' when opcode = beqw else 
    '0';
  
    selMUXPC <= '1' when opcode = jal or opcode = j else 
  '0';

end architecture;
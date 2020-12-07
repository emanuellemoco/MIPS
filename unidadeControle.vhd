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
    funct: in std_logic_vector(5 downto 0);

    -- Output ports
    ULAop : out std_logic_vector(2 downto 0);
    palavraControle : out std_logic_vector(11 downto 0)

  );
end entity;
architecture arch_name of unidadeControle is

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

  -- Instrução R, beqw, bne
    selMuxUla     <= '0' when opcode = instR or opcode = beqw or opcode = bnew else 
    '1'; 

  -- Instrução R
  selMUXEndReg3 <= "01" when opcode = instR else
                   "10" when opcode = jal else  
    "00"; 

  -- Instrução R, lui, addi, andi, ori, slti
  selMUXEscReg3 <= "00" when opcode = instR or opcode = lui or opcode = addi or opcode = andi or opcode = ori or opcode = slti else
                   "10" when opcode =  jal else  
    "01";

  -- Instrução R, lw, lui, addi, andi, ori, slti
  habEscritaReg <= '1' when (opcode = instR and funct /= jrw) or opcode = lw or opcode = lui or opcode = addi or opcode = andi or opcode = ori or opcode = slti else 
    '0';
  
  -- sw
  habEscritaRAM <= '1' when opcode = sw else 
    '0';


  -- Beq
  BEQ           <= '1' when opcode = beqw else 
    '0';
  
    selMUXPC <= '1' when opcode = jal or opcode = j else 
  '0';


  ULAop <= "000" when opcode = lw or opcode = sw or opcode = lui or opcode = addi  else
           "001" when opcode = beqw or opcode = bnew else
           "011" when opcode = andi else
           "100" when opcode = ori  else
           "101" when opcode = slti else  
           "010";
  
  habShift <= '1' when opcode = lui else 
              '0';

  BNE <= '1' when opcode = bnew else 
         '0';

  selExt <= '1' when opcode = andi or opcode = addi or opcode = ori else 
            '0';

  
end architecture;
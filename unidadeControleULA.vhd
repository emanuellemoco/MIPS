library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constantes.all;
entity unidadeControleULA is
  generic (
    DATA_WIDTH : natural := 8;
    ADDR_WIDTH : natural := 8 -- uwuw
  );

  port (
    -- Input ports
    CLK : in std_logic;
    funct : in std_logic_vector(5 downto 0);
    ulaOP : in std_logic_vector(2 downto 0);

    -- Output ports
    JR : out std_logic;
    seletorULA : out std_logic_vector(2 downto 0)
  );
end entity;
architecture uwu of unidadeControleULA is

  signal seletorFUNCT : std_logic_vector(2 downto 0);

  alias seletor : std_logic_vector(1 downto 0) is seletorFUNCT(1 downto 0);
  alias inverteB : std_logic is seletorFUNCT(2);

  -- TIPO R
  -- instR     000000 
  -- add       100000 Add
  -- andw      100100 And
  -- jr        001000 Jump Register ***
  -- orw       100101 Or  
  -- slt       101010 Set Less Than
  -- sub       100010 Subtract
  -- 

  -- TIPO I   
  --  addi     001000 Add immediate  -- ULA
  --  andi     001100 And Immediate --ULA
  --  beqw     000100 Branch on Equal 
  --  bne      000101 Branch on not equal                     
  --  lui      001111 Load Upper Immediate                    
  --  lw       100011 Load word                                                   
  --  ori      001101 Or Immediate  -- ULA
  --  slti     001010 Set less than Immediate --?
  --  sw       101011 Store word

  -- -- TIPO J
  -- j         000010 jump
  -- jal       000011 jump and link                       
begin

  seletor <= "00" when funct = andw else -- 000
    "01" when funct = orw else -- 001
    "10" when funct = add or funct = subw or funct = jrw else -- 010   110
    "11" when funct = slt else -- 111
    "01"; -- 001
  inverteB <= '1' when funct = subw or funct = slt else
    '0';
  seletorULA <= "010" when ULAop = "000" else
    "110" when ULAop = "001" else
    "000" when ULAop = "011" else --andi
    "001" when ULAop = "100" else --ori
    "111" when ULAop = "101" else --slti
    seletorFUNCT;

  JR <= '1' when funct = jrw and ULAop = "010" else
    '0';

end architecture;
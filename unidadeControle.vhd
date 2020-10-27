library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unidadeControle is
  generic (
    DATA_WIDTH : natural := 8;
    ADDR_WIDTH : natural := 8
  );

  port (
    -- Input ports
    CLK   : in std_logic;
    opCode: in std_logic_vector(5 downto 0);
    funct : in std_logic_vector(5 downto 0);

    -- Output ports
    palavraControle : out std_logic_vector(5 downto 0)
  );
end entity;
architecture arch_name of unidadeControle is

  alias selMUXULA : std_logic is  palavraControle(0);
  alias selMUXEndReg3 : std_logic is palavraControle(1);
  alias selMUXEscReg3 : std_logic is palavraControle(2);
  alias habEscritaReg : std_logic is palavraControle(3);
  alias habEscritaRAM : std_logic is palavraControle(4);
  alias selOperacaoULA : std_logic is palavraControle(5);
  
  


begin

  selMuxUla <= '0' when opcode = "000000" else 
    '1'; 
  selMUXEndReg3 <= '1' when opcode = "000000" else 
    '0'; 
  
  selMUXEscReg3 <= '0' when opcode = "000000" else 
    '1';

  habEscritaReg <= '1' when opcode = "000000" or opcode = "100011" else 
    '0';
  
  habEscritaRAM <= '1' when opcode = "101011" else 
    '0';

  selOperacaoULA <= '1' when (opcode = "000000" and funct = "000001") else 
    '0';

end architecture;
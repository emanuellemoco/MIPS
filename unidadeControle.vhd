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
    palavraControle : out std_logic
  );
end entity;
architecture arch_name of unidadeControle is



begin

  palavraControle <= '1' when funct = "000001" else '0';

end architecture;
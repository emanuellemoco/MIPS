library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;

entity shifter is
  -- Total de bits das entradas e saidas
  generic (
       larguraDados : natural := 32;
       shiftValue   : natural := 2
       );

  port (
    inShift  : in std_logic_vector((larguraDados-1) downto 0);
    outShift : out std_logic_vector((larguraDados-1) downto 0);
    habilita : in std_logic
  );
end entity;

architecture comportamento of shifter is
  begin

    outShift <= std_logic_vector(SHIFT_LEFT(unsigned(inShift) , shiftValue)) when habilita = '1' else
                inShift;
end architecture;

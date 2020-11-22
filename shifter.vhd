library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;

entity shifter is
  -- Total de bits das entradas e saidas
  generic (
       larguraDados : natural := 32);
  port (
    inShift  : in std_logic_vector((larguraDados-1) downto 0);
    outShift : out std_logic_vector((larguraDados-1) downto 0)
  );
end entity;

architecture comportamento of shifter is
  begin
    outShift <= std_logic_vector(SHIFT_LEFT(unsigned(inShift) ,2));
end architecture;
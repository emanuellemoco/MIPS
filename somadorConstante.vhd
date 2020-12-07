library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; --Soma (esta biblioteca =ieee)

entity somadorConstante is
    generic (
        larguraDados : natural := 32;
        constante : natural := 4
    );
    port (
        entrada : in std_logic_vector((larguraDados - 1) downto 0);
        saida : out std_logic_vector((larguraDados - 1) downto 0)
    );
end entity;

architecture comportamento of somadorConstante is
begin
    saida <= std_logic_vector(unsigned(entrada) + constante);
end architecture;
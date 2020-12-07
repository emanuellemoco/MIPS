library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- Biblioteca IEEE para funções aritméticas

entity somadorULA is
    port (
        entradaA, entradaB : in std_logic;
        saida : out std_logic;
        C_in : in std_logic;
        C_out : out std_logic
    );
end entity;
architecture comportamento of somadorULA is

    signal xorA_B, andA_B, andCin_AB : std_logic;
begin

    xorA_B <= entradaA xor entradaB;
    andA_B <= entradaA and entradaB;
    andCin_AB <= C_in and xorA_B;
    saida <= C_in xor xorA_B;
    C_out <= andA_B or andCin_AB;
end architecture;
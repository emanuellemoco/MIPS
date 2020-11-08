library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;          -- Biblioteca IEEE para funções aritméticas

entity somadorULA is
    generic
    (
        larguraDados : natural := 32
    );
    port
    (
        entradaA, entradaB: in STD_LOGIC_VECTOR((larguraDados-1) downto 0);
        saida:  out STD_LOGIC_VECTOR((larguraDados-1) downto 0);
        C_in: in std_logic;
        overflow: out STD_LOGIC;
        C_out:  out STD_LOGIC
    );
end entity;



architecture comportamento of somadorULA is

    -- Exemplo de OVERFLOW disponivel no StackOVERFLOW:
    -- https://stackoverflow.com/questions/1741285/overflow-bit-32bit-alu-vhdl


    SIGNAL aa : std_logic_vector(larguraDados -1 downto 0);
    SIGNAL entradaA_ext, entradaB_ext, intermed : std_logic_vector(larguraDados downto 0);


    begin
        
        aa <= std_logic_vector(signed(entradaB) + 1);

        entradaA_ext <= entradaA(larguraDados-1) & entradaA;

        entradaB_ext <= (entradaB(larguraDados-1) & aa ) when c_in = '1' else
        entradaB(larguraDados-1) & entradaB;

        intermed <= std_logic_vector(signed(entradaA_ext) + signed(entradaB_ext));

        overflow <= '1' when intermed(larguraDados) /= intermed(larguraDados-1);

        C_out <= '1' when intermed(larguraDados) /= intermed(larguraDados-1);

        saida <= intermed(larguraDados-1  downto 0);
        
        
end architecture;
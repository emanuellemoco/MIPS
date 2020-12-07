
library ieee;
use ieee.std_logic_1164.all;

entity estendeSinal is
    generic (
        larguraDadoEntrada : natural := 16;
        larguraDadoSaida : natural := 32
    );
    port (
        -- Input ports
        estendeSinal_IN : in std_logic_vector(larguraDadoEntrada - 1 downto 0);
        seletor : in std_logic;
        -- Output ports
        estendeSinal_OUT : out std_logic_vector(larguraDadoSaida - 1 downto 0)
    );
end entity;

architecture comportamento of estendeSinal is

    signal sigExt : std_logic_vector(larguraDadoSaida - 1 downto 0);
    constant zero : std_logic_vector(larguraDadoSaida - 1 downto larguraDadoEntrada) := (others => '0');

begin
    process (estendeSinal_IN) is
    begin
        if (estendeSinal_IN(larguraDadoEntrada - 1) = '1') then
            sigExt <= (larguraDadoSaida - 1 downto larguraDadoEntrada => '1') & estendeSinal_IN;
        else
            sigExt <= (larguraDadoSaida - 1 downto larguraDadoEntrada => '0') & estendeSinal_IN;
        end if;
    end process;

    estendeSinal_OUT <= (zero & estendeSinal_IN) when seletor = '1' else
        sigExt;
end architecture;
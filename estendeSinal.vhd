library ieee;
use ieee.std_logic_1164.all;

entity estendeSinal is
    generic
    (
        larguraDadoEntrada : natural  :=    16;
        larguraDadoSaida   : natural  :=    32
    );
    port
    (
        -- Input ports
        estendeSinal_IN : in  std_logic_vector(larguraDadoEntrada-1 downto 0);
        -- Output ports
        estendeSinal_OUT: out std_logic_vector(larguraDadoSaida-1 downto 0)
    );
end entity;

architecture comportamento of estendeSinal is

    signal left : std_logic_vector(larguraDadoEntrada -1 downto 0);

begin
    process (estendeSinal_IN) is
    begin
            if (estendeSinal_IN(larguraDadoEntrada-1) = '1') then
                left <= (others => '1');
            else
                left <= (others => '0');
            end if;

            estendeSinal_OUT <= left & estendeSinal_IN;
    end process;
end architecture;
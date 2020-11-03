library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;    -- Biblioteca IEEE para funções aritméticas

entity ULA is
    generic
    (
        larguraDados : natural := 8
    );
    port
    (
      entradaA, entradaB:  in STD_LOGIC_VECTOR((larguraDados-1) downto 0);
      seletor:  in STD_LOGIC_VECTOR(2 downto 0);
      saida:    out STD_LOGIC_VECTOR((larguraDados-1) downto 0);
      flagZ: out std_logic
    );
end entity;

architecture comportamento of ULA is
  constant zero : std_logic_vector(larguraDados-1 downto 0) := (others => '0');

   signal soma   :   STD_LOGIC_VECTOR((larguraDados-1) downto 0);
   signal subtracao: STD_LOGIC_VECTOR((larguraDados-1) downto 0);
   signal op_and :   STD_LOGIC_VECTOR((larguraDados-1) downto 0);
   signal op_or  :   STD_LOGIC_VECTOR((larguraDados-1) downto 0); 

    begin
      soma      <= STD_LOGIC_VECTOR(unsigned(entradaA) + unsigned(entradaB));
      subtracao <= STD_LOGIC_VECTOR(unsigned(entradaA) - unsigned(entradaB));
      op_and    <= entradaA and entradaB;
      op_or     <= entradaA or entradaB;
      
      saida <= entradaB when (seletor = "000") else
          soma when (seletor = "001") else
          subtracao when (seletor = "010") else
          op_and when (seletor = "011") else
          op_or when (seletor = "100") else 
          entradaB;

      flagZ <= '1' when subtracao = zero else '0';

end architecture;
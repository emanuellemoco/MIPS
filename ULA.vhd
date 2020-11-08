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
      inverteA, inverteB: in STD_LOGIC;

      seletor:  in STD_LOGIC_VECTOR(1 downto 0);
      saida:    out STD_LOGIC_VECTOR((larguraDados-1) downto 0);
      flagZ: out std_logic
    );
end entity;

architecture comportamento of ULA is
  

  SIGNAL saidaA, saidaB, outAdder, outOr, outAnd, saidaMux, outOverflow32 : std_logic_vector(larguraDados -1 downto 0);
  SIGNAL left : std_logic_vector(larguraDados -2 downto 0);
  SIGNAL outOverflow : STD_LOGIC;
  constant zero : std_logic_vector(larguraDados-1 downto 0) := (others => '0');
   
  begin
  left <= (others => '0');
  muxInverteA: entity work.mux2x1 generic map (larguraDados => larguraDados)
  port map(entradaA_MUX => entradaA, entradaB_MUX => not entradaA, seletor_MUX => inverteA , saida_MUX => saidaA );
  
  muxInverteB: entity work.mux2x1 generic map (larguraDados => larguraDados)
  port map(entradaA_MUX => entradaB, entradaB_MUX => not entradaB, seletor_MUX => inverteB, saida_MUX => saidaB );
  
  somador: entity work.somadorULA  generic map (larguraDados => larguraDados)
  port map(entradaA => saidaA, entradaB => saidaB, C_in => inverteB, overflow => outOverflow, C_out => open, saida => outAdder);

  outOverflow32 <= left & outOverflow;

  mux: entity work.mux4x1 generic map (larguraDados => larguraDados)
  port map(entradaA_MUX => outAnd, entradaB_MUX => outOr, entradaC_MUX => outAdder, entradaD_MUX => outOverflow32, seletor_MUX => seletor , saida_MUX => saidaMux);

  flagZ<= '1' when saidaMux = zero else 
  '0';      



 
end architecture;
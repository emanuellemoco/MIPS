library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- Biblioteca IEEE para funções aritméticas

entity miniULA is
  port (
    -- Inputs
    entradaA, entradaB, C_in : in std_logic;
    d_mux : in std_logic;
    seletor : in std_logic_vector(1 downto 0);
    -- OUT
    C_out : out std_logic;
    set : out std_logic;
    saida : out std_logic
  );
end entity;

architecture comportamento of miniULA is
  signal saidaA, saidaB, outAdder, outOr, outAnd, intermed : std_logic;
  constant zero : std_logic := '0';

begin

  somador : entity work.somadorULA
    port map(entradaA => entradaA, entradaB => entradaB, C_in => C_in, C_out => C_out, saida => outAdder);

  mux : entity work.mux4x1Bit
    port map(entradaA_MUX => entradaA and entradaB, entradaB_MUX => entradaA or entradaB, entradaC_MUX => outAdder, entradaD_MUX => d_mux, seletor_MUX => seletor, saida_MUX => saida);

  set <= outAdder;
end architecture;
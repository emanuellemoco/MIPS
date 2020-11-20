library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;    -- Biblioteca IEEE para funções aritméticas

entity miniULA is
    port
    (
      -- Inputs
      entradaA, entradaB, C_in:  in STD_LOGIC;
      d_mux : in std_logic;
      seletor:  in std_logic_vector(1 downto 0);
    -- OUT
      C_out : out std_Logic;
      set   : out std_logic;
      saida :    out STD_LOGIC
    );
end entity;

architecture comportamento of miniULA is
  

  SIGNAL saidaA, saidaB, outAdder, outOr, outAnd, intermed: std_logic;
  constant zero : std_logic :=  '0';
   
  begin

    -- T1 ==> 0000 0000 0000 0000 0000 0000 0000 1010
    -- T2 ==> 0000 0000 0000 0000 0000 0000 0000 1011
    
    somador: entity work.somadorULA  
    port map(entradaA => entradaA, entradaB => entradaB, C_in => C_in, C_out => C_out, saida => outAdder);
  
    mux: entity work.mux4x1Bit 
    port map(entradaA_MUX=> entradaA and entradaB,  entradaB_MUX => entradaA or entradaB, entradaC_MUX => outAdder, entradaD_MUX => d_mux, seletor_MUX => seletor , saida_MUX => saida);
     
    set <= outAdder;
    
    

 
end architecture;
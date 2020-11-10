library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;          -- Biblioteca IEEE para funções aritméticas

entity somadorULA is
    port
    (
        entradaA, entradaB: in STD_LOGIC;
        saida:  out STD_LOGIC;
        C_in: in std_logic;
        C_out:  out STD_LOGIC
    );
end entity;



architecture comportamento of somadorULA is

    SIGNAL entradaB_def : std_logic;


    begin
    
        entradaB_def <= not entradaB when C_in = '1' else
            entradaB;    

        C_out <= '1' when entradaA = '1' and entradaB = '1';
        
        saida <= entradaA or entradaB_def; 
        
        
        
        
end architecture;
--
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

package constantes is

    constant OPCODE_WIDTH : natural := 6;
    constant FUNCT_WIDTH : natural := 6;


    subtype opcode is std_logic_vector(OPCODE_WIDTH - 1 downto 0);
    subtype funct is std_logic_vector(FUNCT_WIDTH - 1 downto 0);

    constant instR : opcode  := "000000";
    constant addi  : opcode  := "001000";
    constant andi  : opcode  := "001100";
    constant beqw  : opcode  := "000100";
    constant bne   : opcode  := "000101";
    constant lui   : opcode  := "001111";
    constant lw    : opcode  := "100011";
    constant ori   : opcode  := "001101";
    constant slti  : opcode  := "001010";
    constant sw    : opcode  := "001011";
    constant j     : opcode  := "000010";
    constant jal   : opcode  := "000011";

    constant add   : funct   := "100000";
    constant andw  : funct   := "100100";
    constant jr    : funct   := "001000";
    constant orw   : funct   := "100101";
    constant slt   : funct   := "101010";
    constant subw   : funct   := "100010";

     


end package constantes;

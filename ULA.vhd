library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- Biblioteca IEEE para funções aritméticas

entity ULA is
  generic (
    larguraDados : natural := 32
  );
  port (
    entradaA, entradaB : in std_logic_vector((larguraDados - 1) downto 0);

    seletor : in std_logic_vector(2 downto 0);
    saida : out std_logic_vector((larguraDados - 1) downto 0);
    flagZ : out std_logic
  );
end entity;
architecture comportamento of ULA is

  constant zero : std_logic_vector(larguraDados - 1 downto 0) := (others => '0');

  signal entradaBdef, saida_intermed : std_logic_vector(larguraDados - 1 downto 0);
  signal overflow : std_logic;
  signal c_out0, c_out1, c_out2, c_out3, c_out4, c_out5, c_out6, c_out7, c_out8, c_out9, c_out10,
  c_out11, c_out12, c_out13, c_out14, c_out15, c_out16, c_out17, c_out18, c_out19, c_out20,
  c_out21, c_out22, c_out23, c_out24, c_out25, c_out26, c_out27, c_out28, c_out29, c_out30, c_out31 : std_logic;
  signal slt, set31 : std_logic;

begin

  entradaBdef <= std_logic_vector(not entradaB) when seletor(2) = '1' else
    entradaB;

  ULA0 : entity work.miniULA
    port map(entradaA => entradaA(0), entradaB => entradaBdef(0), d_mux => slt, seletor => seletor(1 downto 0), C_in => seletor(2), C_out => C_out0, set => open, saida => saida_intermed(0));
  ULA1 : entity work.miniULA
    port map(entradaA => entradaA(1), entradaB => entradaBdef(1), d_mux => '0', seletor => seletor(1 downto 0), C_in => c_out0, C_out => c_out1, set => open, saida => saida_intermed(1));
  ULA2 : entity work.miniULA
    port map(entradaA => entradaA(2), entradaB => entradaBdef(2), d_mux => '0', seletor => seletor(1 downto 0), C_in => c_out1, C_out => c_out2, set => open, saida => saida_intermed(2));
  ULA3 : entity work.miniULA
    port map(entradaA => entradaA(3), entradaB => entradaBdef(3), d_mux => '0', seletor => seletor(1 downto 0), C_in => c_out2, C_out => c_out3, set => open, saida => saida_intermed(3));
  ULA4 : entity work.miniULA
    port map(entradaA => entradaA(4), entradaB => entradaBdef(4), d_mux => '0', seletor => seletor(1 downto 0), C_in => c_out3, C_out => c_out4, set => open, saida => saida_intermed(4));
  ULA5 : entity work.miniULA
    port map(entradaA => entradaA(5), entradaB => entradaBdef(5), d_mux => '0', seletor => seletor(1 downto 0), C_in => c_out4, C_out => c_out5, set => open, saida => saida_intermed(5));
  ULA6 : entity work.miniULA
    port map(entradaA => entradaA(6), entradaB => entradaBdef(6), d_mux => '0', seletor => seletor(1 downto 0), C_in => c_out5, C_out => c_out6, set => open, saida => saida_intermed(6));
  ULA7 : entity work.miniULA
    port map(entradaA => entradaA(7), entradaB => entradaBdef(7), d_mux => '0', seletor => seletor(1 downto 0), C_in => c_out6, C_out => c_out7, set => open, saida => saida_intermed(7));
  ULA8 : entity work.miniULA
    port map(entradaA => entradaA(8), entradaB => entradaBdef(8), d_mux => '0', seletor => seletor(1 downto 0), C_in => c_out7, C_out => c_out8, set => open, saida => saida_intermed(8));
  ULA9 : entity work.miniULA
    port map(entradaA => entradaA(9), entradaB => entradaBdef(9), d_mux => '0', seletor => seletor(1 downto 0), C_in => c_out8, C_out => c_out9, set => open, saida => saida_intermed(9));
  ULA10 : entity work.miniULA
    port map(entradaA => entradaA(10), entradaB => entradaBdef(10), d_mux => '0', seletor => seletor(1 downto 0), C_in => c_out9, C_out => c_out10, set => open, saida => saida_intermed(10));
  ULA11 : entity work.miniULA
    port map(entradaA => entradaA(11), entradaB => entradaBdef(11), d_mux => '0', seletor => seletor(1 downto 0), C_in => c_out10, C_out => c_out11, set => open, saida => saida_intermed(11));
  ULA12 : entity work.miniULA
    port map(entradaA => entradaA(12), entradaB => entradaBdef(12), d_mux => '0', seletor => seletor(1 downto 0), C_in => c_out11, C_out => c_out12, set => open, saida => saida_intermed(12));
  ULA13 : entity work.miniULA
    port map(entradaA => entradaA(13), entradaB => entradaBdef(13), d_mux => '0', seletor => seletor(1 downto 0), C_in => c_out12, C_out => c_out13, set => open, saida => saida_intermed(13));
  ULA14 : entity work.miniULA
    port map(entradaA => entradaA(14), entradaB => entradaBdef(14), d_mux => '0', seletor => seletor(1 downto 0), C_in => c_out13, C_out => c_out14, set => open, saida => saida_intermed(14));
  ULA15 : entity work.miniULA
    port map(entradaA => entradaA(15), entradaB => entradaBdef(15), d_mux => '0', seletor => seletor(1 downto 0), C_in => c_out14, C_out => c_out15, set => open, saida => saida_intermed(15));
  ULA16 : entity work.miniULA
    port map(entradaA => entradaA(16), entradaB => entradaBdef(16), d_mux => '0', seletor => seletor(1 downto 0), C_in => c_out15, C_out => c_out16, set => open, saida => saida_intermed(16));
  ULA17 : entity work.miniULA
    port map(entradaA => entradaA(17), entradaB => entradaBdef(17), d_mux => '0', seletor => seletor(1 downto 0), C_in => c_out16, C_out => c_out17, set => open, saida => saida_intermed(17));
  ULA18 : entity work.miniULA
    port map(entradaA => entradaA(18), entradaB => entradaBdef(18), d_mux => '0', seletor => seletor(1 downto 0), C_in => c_out17, C_out => c_out18, set => open, saida => saida_intermed(18));
  ULA19 : entity work.miniULA
    port map(entradaA => entradaA(19), entradaB => entradaBdef(19), d_mux => '0', seletor => seletor(1 downto 0), C_in => c_out18, C_out => c_out19, set => open, saida => saida_intermed(19));
  ULA20 : entity work.miniULA
    port map(entradaA => entradaA(20), entradaB => entradaBdef(20), d_mux => '0', seletor => seletor(1 downto 0), C_in => c_out19, C_out => c_out20, set => open, saida => saida_intermed(20));
  ULA21 : entity work.miniULA
    port map(entradaA => entradaA(21), entradaB => entradaBdef(21), d_mux => '0', seletor => seletor(1 downto 0), C_in => c_out20, C_out => c_out21, set => open, saida => saida_intermed(21));
  ULA22 : entity work.miniULA
    port map(entradaA => entradaA(22), entradaB => entradaBdef(22), d_mux => '0', seletor => seletor(1 downto 0), C_in => c_out21, C_out => c_out22, set => open, saida => saida_intermed(22));
  ULA23 : entity work.miniULA
    port map(entradaA => entradaA(23), entradaB => entradaBdef(23), d_mux => '0', seletor => seletor(1 downto 0), C_in => c_out22, C_out => c_out23, set => open, saida => saida_intermed(23));
  ULA24 : entity work.miniULA
    port map(entradaA => entradaA(24), entradaB => entradaBdef(24), d_mux => '0', seletor => seletor(1 downto 0), C_in => c_out23, C_out => c_out24, set => open, saida => saida_intermed(24));
  ULA25 : entity work.miniULA
    port map(entradaA => entradaA(25), entradaB => entradaBdef(25), d_mux => '0', seletor => seletor(1 downto 0), C_in => c_out24, C_out => c_out25, set => open, saida => saida_intermed(25));
  ULA26 : entity work.miniULA
    port map(entradaA => entradaA(26), entradaB => entradaBdef(26), d_mux => '0', seletor => seletor(1 downto 0), C_in => c_out25, C_out => c_out26, set => open, saida => saida_intermed(26));
  ULA27 : entity work.miniULA
    port map(entradaA => entradaA(27), entradaB => entradaBdef(27), d_mux => '0', seletor => seletor(1 downto 0), C_in => c_out26, C_out => c_out27, set => open, saida => saida_intermed(27));
  ULA28 : entity work.miniULA
    port map(entradaA => entradaA(28), entradaB => entradaBdef(28), d_mux => '0', seletor => seletor(1 downto 0), C_in => c_out27, C_out => c_out28, set => open, saida => saida_intermed(28));
  ULA29 : entity work.miniULA
    port map(entradaA => entradaA(29), entradaB => entradaBdef(29), d_mux => '0', seletor => seletor(1 downto 0), C_in => c_out28, C_out => c_out29, set => open, saida => saida_intermed(29));
  ULA30 : entity work.miniULA
    port map(entradaA => entradaA(30), entradaB => entradaBdef(30), d_mux => '0', seletor => seletor(1 downto 0), C_in => c_out29, C_out => c_out30, set => open, saida => saida_intermed(30));
  ULA31 : entity work.miniULA
    port map(entradaA => entradaA(31), entradaB => entradaBdef(31), d_mux => '0', seletor => seletor(1 downto 0), C_in => c_out30, C_out => c_out31, set => set31, saida => saida_intermed(31));
  overflow <= c_out31 xor c_out30;

  slt <= set31 when overflow = '0' else
    not set31;

  saida <= saida_intermed;

  flagZ <= '1' when saida = zero else
    '0';
end architecture;
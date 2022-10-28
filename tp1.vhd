--------------------------------------
-- Biblioteca
--------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

--------------------------------------
-- Entidade
--------------------------------------
entity tp1 is
  port( clock, reset, stdin: in std_logic;
        prog: in std_logic_vector(2 downto 0);
        padrao: in std_logic_vector(7 downto 0);
        dout, alarme: out std_logic
      );
end entity; 

--------------------------------------
-- Arquitetura
--------------------------------------
architecture tp1 of tp1 is

  type state is (IDLE, UM, DOIS, TRES, BSC, PER, BLK);

  signal EA: state;
  signal PE: state;

  signal reg_din : std_logic_vector(7 downto 0);
  
  signal p1: std_logic_vector(7 downto 0);
  signal p2: std_logic_vector(7 downto 0);
  signal p3: std_logic_vector(7 downto 0);

  signal C_p1: std_logic;
  signal C_p2: std_logic;
  signal C_p3: std_logic;

  signal valid_p1: std_logic;
  signal valid_p2: std_logic;
  signal valid_p3: std_logic;

  signal match_p1: std_logic;
  signal match_p2: std_logic;
  signal match_p3: std_logic;
  signal match: std_logic;

  signal cont: std_logic_vector(1 downto 0);

  signal alarme_int: std_logic;

begin
    
  process (reset, clock):
  begin
    if reset = '1' then
      EA <= IDLE;
    elsif rising_edge(clock) then
      EA <= PE;
    end if;
  end process;

  process(EA, prog, match, cont)
  begin
    case EA is
      when IDLE =>
      when UM =>
      when DOIS =>
      when TRES =>
      when BSC =>
      when PER =>
      when BLK =>
    end case;
  end process;

  -- <COMPLETAR>

end architecture;
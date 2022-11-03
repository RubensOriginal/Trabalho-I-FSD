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
  port( clock, reset, din: in std_logic;
        prog: in std_logic_vector(2 downto 0);
        padrao: in std_logic_vector(7 downto 0);
        dout, alarme: out std_logic
      );
end entity; 

--------------------------------------
-- Arquitetura
--------------------------------------
architecture tp1 of tp1 is

  type state is (IDLE, UM, DOIS, TRES, BSC, PER, BLK, RESET_STATE);

  signal EA: state;
  signal PE: state;

  signal reg_din : std_logic_vector(7 downto 0);
  
  signal p1: std_logic_vector(7 downto 0) := "00000000";
  signal p2: std_logic_vector(7 downto 0) := "00000000";
  signal p3: std_logic_vector(7 downto 0) := "00000000";

  signal C_p1: std_logic := '0';
  signal C_p2: std_logic := '0';
  signal C_p3: std_logic := '0';

  signal valid_p1: std_logic := '0';
  signal valid_p2: std_logic := '0';
  signal valid_p3: std_logic := '0';

  signal match_p1: std_logic := '0';
  signal match_p2: std_logic := '0';
  signal match_p3: std_logic := '0';
  signal match: std_logic := '0';

  signal cont: std_logic_vector(1 downto 0) := "00";

  signal alarme_int: std_logic := '0';

begin
  -- Maquina de Estados
  process (reset, clock)
  begin
    if reset = '1' then
      EA <= IDLE;
    elsif rising_edge(clock) then
      EA <= PE;
    end if;
  end process;

  -- Maquina de Estados
  process(EA, prog, match, cont)
  begin
    case EA is
      when IDLE =>
        if prog = "001" then
          PE <= UM;
        elsif prog = "010" then
          PE <= DOIS;
        elsif prog = "011" then
          PE <= TRES;
        elsif prog = "100" then
          PE <= BSC;
        end if;
      when UM =>
        if prog = "000" then
          PE <= IDLE;
        end if;
      when DOIS =>
        if prog = "000" then
          PE <= IDLE;
        end if;
      when TRES =>
        if prog = "000" then
          PE <= IDLE;
        end if;
      when BSC =>
        if match = '1' then
          PE <= PER;
        elsif prog = "101" then
          PE <= BLK;
        elsif prog = "111" then
          PE <= RESET_STATE;
        end if;
      when PER =>
        if cont = "11" then
          PE <= BSC;
        else
          cont <= cont + 1;
        end if;
      when BLK =>
        if prog = "110" then
          PE <= BSC;
        elsif prog = "111" then
          PE <= RESET_STATE;
        end if;
      when RESET_STATE =>
        if prog = "000" then
          PE <= IDLE;
        end if;
    end case;
  end process;

  -- Reg_Din
  process(reset, clock)
  begin
    if reset = '1' then
      reg_din <= (others => '0');
    elsif rising_edge(clock) then
      reg_din <= din & reg_din(7 downto 1);
    end if;
  end process;

  -- Registrador p1
  process(clock, reset)
  begin
    if reset = '1' then
      p1 <= (others => '0');
    elsif rising_edge(clock) then
      if EA = UM then
        p1 <= padrao;
      end if;
    end if;
  end process;

  -- Registrador p2
  process(clock, reset)
  begin
    if reset = '1' then
      p2 <= (others => '0');
    elsif rising_edge(clock) then
      if EA = DOIS then
        p2 <= padrao;
      end if;
    end if;
  end process;

  -- Registrador p3
  process(clock, reset)
  begin
    if reset = '1' then
      p3 <= (others => '0');
    elsif rising_edge(clock) then
      if EA = TRES then
        p3 <= padrao;
      end if;
    end if;
  end process;

  -- Registrador valid_p1
  process(clock, reset)
  begin
    if reset = '1' then
      valid_p1 <= '0';
    elsif rising_edge(clock) then
      if EA = UM then
        valid_p1 <= '1';
      elsif EA = RESET_STATE then
        valid_p1 <= '0';
      end if;
    end if;
  end process;

  -- Registrador valid_p2
  process(clock, reset)
  begin
    if reset = '1' then
      valid_p2 <= '0';
    elsif rising_edge(clock) then
      if EA = DOIS then
        valid_p2 <= '1';
      elsif EA = RESET_STATE then
        valid_p2 <= '0';
      end if;
    end if;
  end process;

  -- Registrador valid_p3
  process(clock, reset)
  begin
    if reset = '1' then
      valid_p3 <= '0';
    elsif rising_edge(clock) then
      if EA = TRES then
        valid_p3 <= '1';
      elsif EA = RESET_STATE then
        valid_p3 <= '0';
      end if;
    end if;
  end process;

  C_p1 <= '1' when reg_din = p1 else '0';
  C_p2 <= '1' when reg_din = p2 else '0';
  C_p3 <= '1' when reg_din = p3 else '0';

  match_p1 <= C_p1 and valid_p1;
  match_p2 <= C_p2 and valid_p2;
  match_p3 <= C_p3 and valid_p3;

  match <= match_p1 or match_p2 or match_p3;

  -- <COMPLETAR>

end architecture;
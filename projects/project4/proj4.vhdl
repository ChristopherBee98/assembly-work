-- proj4.vhdl    keep as one file for 'submit'
--               add multiplier below where indicated

library IEEE;
use IEEE.std_logic_1164.all;

entity madd is               -- full adder stage, interface
  port(m    : in  std_logic;
       a    : in  std_logic;
       b    : in  std_logic;
       cin  : in  std_logic;
       s    : out std_logic;
       cout : out std_logic);
end entity madd;

architecture circuits of madd is  -- full adder stage, body
  signal aa : std_logic;
begin  -- circuits of madd
  aa <= a and m;
  s <= aa xor b xor cin after 1 ns;
  cout <= (aa and b) or (aa and cin) or (b and cin) after 1 ns;
end architecture circuits; -- of madd

library IEEE;
use IEEE.std_logic_1164.all;

entity madd4 is      -- 4-bit multiplier-adder
  port(m    : in  std_logic;
       a    : in  std_logic_vector(3 downto 0);
       b    : in  std_logic_vector(3 downto 0);
       sum  : out std_logic_vector(3 downto 0);
       cout : out std_logic);
end entity madd4;

architecture circuits of madd4 is
  signal c : std_logic_vector(3 downto 0);  -- internal wires
begin  -- circuits of add4
  a0: entity WORK.madd port map(m, a(0), b(0),  '0', sum(0), c(0));
  a1: entity WORK.madd port map(m, a(1), b(1), c(0), sum(1), c(1));
  a2: entity WORK.madd port map(m, a(2), b(2), c(1), sum(2), c(2));
  a3: entity WORK.madd port map(m, a(3), b(3), c(2), sum(3), cout);
end architecture circuits; -- of madd4

use STD.textio.all;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
use IEEE.std_logic_arith.all;

entity proj4 is
end proj4;

architecture circuits of proj4 is
  signal a:     std_logic_vector(3 downto 0):=('0','0','0','0');
  signal b:     std_logic_vector(3 downto 0):=('0','0','0','0');
  signal p:     std_logic_vector(7 downto 0);       
  signal s0:    std_logic_vector(3 downto 0);
  signal s0s:   std_logic_vector(3 downto 0);
  signal s1:    std_logic_vector(3 downto 0);
  signal s1s:   std_logic_vector(3 downto 0);
  signal s2:    std_logic_vector(3 downto 0);
  signal s2s:   std_logic_vector(3 downto 0);
  signal c:     std_logic_vector(3 downto 0);
  signal cntr:  std_logic_vector(3 downto 0);
  signal zero4: std_logic_vector(3 downto 0) := ('0','0','0','0');
  
  procedure print_values is       -- format output
    variable my_line : LINE;
  begin
    write(my_line, string'("a="));
    write(my_line, a);
    write(my_line, string'(", b="));
    write(my_line, b);
    write(my_line, string'(", a*b=p "));
    write(my_line, p);
    writeline(output, my_line);
  end print_values;

begin  -- circuits of proj4


  a0: entity work.madd4 port map(b(0), a, zero4, s0, c(0));
      p(0) <= s0(0);
      s0s <= c(0) & s0(3 downto 1);

  
  -- Put your three "madd4" here with extra statements for
  -- "p(1)" and "s1s" etc

  -- a1:





  

  driver: process                      -- serial code, test driver
            variable my_line : LINE;
          begin  -- process driver
            wait for 9 ns;           --  propagating signals
            print_values;            -- write output
            for i in 0 to 14 loop 
              a <= unsigned(a)+unsigned'("0001");
              b <= not a;
              wait for 9 ns;           --  propagating signals
              print_values;            -- write output
            end loop;  -- i
            b <= a;
            wait for 9 ns;             --  propagating signals
            print_values;              -- write output
            wait for 100 ns;
          end process driver;
end architecture circuits; -- of proj4


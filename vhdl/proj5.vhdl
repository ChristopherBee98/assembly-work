-- proj5.vhdl   spin lock (Austin Bailey)
-- when compiling, takes a little while so be patient

library IEEE;
use IEEE.std_logic_1164.all;

entity dff1 is  -- D flip flop
  port(d     : in    std_logic;            -- input read on rising clock
       clk   : in    std_logic;            -- standard clock signal
       set   : in    std_logic;            -- normally high, low to set
       reset : in    std_logic;            -- normally high, low to reset
       q     : inout std_logic);           -- output
end entity dff1;

architecture behavior of dff1 is
begin
  dff: process (clk, reset, set)
  begin  -- process dff
    if set='0' then                     -- active low
      q <= '1';
    elsif reset='0' then                -- active low
      q <= '0';
    elsif clk='1' then                  -- raising edge
      q <= d;
    end if;
  end process dff;
end architecture behavior;  -- of dff1

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
use STD.textio.all;

entity proj5 is   -- test bench
end entity proj5;

architecture circuits of proj5 is
  signal clk   : std_logic := '0';        -- system clock
  signal clear : std_logic := '0';        -- used for circuit initialization 
  signal A, B, C, D, E, F : std_logic;    -- shift register outputs
  signal Ain, Bin, Cin, Din, Ein, Fin : std_logic; -- shift register inputs
  signal rcvr :  std_logic_vector(0 to 10) := ('1','0','1','1','0','1','1','1','0','1','0');
  signal activate : std_logic;            -- output of spin lock
  signal one   : std_logic := '1';        -- for unused R and S on D flip flops
  signal I : std_logic := '0';            -- rcvr(ii)

  component dff1
    port(d     : in    std_logic;            -- input read on rising clock
         clk   : in    std_logic;            -- standard clock signal
         set   : in    std_logic;            -- normally high, low to set
         reset : in    std_logic;            -- normally high, low to reset
         q     : inout std_logic);           -- output
  end component;
begin  -- circuits of proj5
  clk <= not clk after 1 ns;   -- control circuitry, the clock
  clear <= '1' after 250 ps;     -- 0 initially, then always one

  -- circuitry that makes the 6-bit spin lock
  dffA: dff1 port map(Ain, clk, clear, one,   A);
  dffB: dff1 port map(Bin, clk, one,   clear, B);
  dffC: dff1 port map(Cin, clk, one,   clear, C);
  dffD: dff1 port map(Din, clk, one,   clear, D);
-- etc ???
  dffE: dff1 port map(Ein, clk, one, clear, E);
  dffF: dff1 port map(Fin, clk, one, clear, F);
  
  A1: Ain <= (A and not I) or (B and not I) or (C and I) or (D and not I) or (E and not I) or (F); --  or ???;
  B1: Bin <= (A and I); 
  C1: Cin <= (B and I); 
  D1: Din <= (C and not I); 
--  etc. ???
  E1: Ein <= (D and I);
  F1: Fin <= (E and I);
  
  G1: activate <= F and I;

  
  print: process (clk) is  -- show shift register and activate
    variable my_line : line;
    variable ii : integer := 0;               -- rcvr count
  begin
    if clk='0' then
      write(my_line, string'("                     ABCDEF="));
      write(my_line, A);    -- uncomment if you used A, B, C, D, E, F 
      write(my_line, B);    -- for spin lock dff1 outputs
      write(my_line, C);    -- optional, this is for your testing
      write(my_line, D);
      write(my_line, E);
      write(my_line, F);
      write(my_line, string'("  I="));
      write(my_line, I);
      write(my_line, string'(" activate="));
      write(my_line, activate);
      writeline(output, my_line);
      ii := ii+1;
      I <= rcvr(ii) after 1 ns;
    end if;
  end process print;
end architecture circuits;  -- of proj5

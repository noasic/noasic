-------------------------------------------------------------------------------
--
--  Testbench for the random_pkg package.
--
--  This file is part of the noasic library.
--
--  Author(s):
--    Guy Eschemann, Guy.Eschemann@gmail.com
--
-------------------------------------------------------------------------------
--
--  Copyright (c) 2012 Guy Eschemann
--
--  This source file may be used and distributed without restriction provided
--  that this copyright statement is not removed from the file and that any
--  derivative work contains the original copyright notice and the associated
--  disclaimer.
--
--  This source file is free software: you can redistribute it and/or modify it
--  under the terms of the GNU Lesser General Public License as published by
--  the Free Software Foundation, either version 3 of the License, or (at your
--  option) any later version.
--
--  This source file is distributed in the hope that it will be useful, but
--  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
--  or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
--  for more details.
--
--  You should have received a copy of the GNU Lesser General Public License
--  along with the noasic library.  If not, see http://www.gnu.org/licenses
--
-------------------------------------------------------------------------------

library ieee;

use ieee.std_logic_1164.all;
use work.random_pkg.all;

entity tb_random_pkg is
end entity tb_random_pkg;

architecture RTL of tb_random_pkg is
  type t_integer_array is array (integer range <>) of integer;

  -- Tests the random_pkg.randint() function: execute the randint() 
  -- function as many times as it takes to have every value in the range 
  -- [MIN_VALUE, MAX_VALUE] generated at least once.  
  procedure test_randint is
    constant MIN_VALUE             : integer := -1000;
    constant MAX_VALUE             : integer := 1000;
    variable v_randval_histogram   : t_integer_array(MIN_VALUE to MAX_VALUE);
    variable v_randval             : integer;
    variable v_iterations_count    : natural;
    variable v_unique_values_count : natural;
  begin
    v_randval_histogram   := (others => 0);
    v_unique_values_count := 0;
    v_iterations_count    := 0;
    while v_unique_values_count < v_randval_histogram'length loop
      v_randval := randint(MIN_VALUE, MAX_VALUE);
      check_range : assert v_randval >= MIN_VALUE and v_randval <= MAX_VALUE report "generated value is out of range." severity failure;
      if v_randval_histogram(v_randval) = 0 then
        v_unique_values_count := v_unique_values_count + 1;
      end if;
      v_randval_histogram(v_randval) := v_randval_histogram(v_randval) + 1;
      v_iterations_count             := v_iterations_count + 1;
    end loop;
    check_histogram : for i in v_randval_histogram'range loop
      assert v_randval_histogram(i) >= 1 severity failure;
    end loop;
    report "test_randint completed in " & integer'image(v_iterations_count) & " iterations." severity note;
  end procedure;

  -- Tests the random_pkg.randwait() procedure: execute the randwait() 
  -- procedure as many times as it takes to have every delay in the given 
  -- range covered at least once.
  procedure test_randwait(signal s_clk : std_logic; period : time) is
    constant MIN                   : natural := 0;
    constant MAX                   : natural := 100;
    variable v_start_time          : time;
    variable v_delay               : time;
    variable v_delay_cycles        : natural;
    variable v_delay_histogram     : t_integer_array(MIN to MAX);
    variable v_unique_delays_count : natural;
    variable v_iterations_count    : natural;
  begin
    v_delay_histogram     := (others => 0);
    v_unique_delays_count := 0;
    v_iterations_count    := 0;
    while v_unique_delays_count < v_delay_histogram'length loop
      v_start_time := now;
      randwait(s_clk, MIN, MAX);
      v_delay        := now - v_start_time;
      v_delay_cycles := v_delay / period;
      if v_delay_histogram(v_delay_cycles) = 0 then
        v_unique_delays_count := v_unique_delays_count + 1;
      end if;
      v_delay_histogram(v_delay_cycles) := v_delay_histogram(v_delay_cycles) + 1;
      v_iterations_count                := v_iterations_count + 1;
    end loop;
    check_histogram : for i in v_delay_histogram'range loop
      assert v_delay_histogram(i) >= 1 severity failure;
    end loop;
    report "test_randwait completed in " & integer'image(v_iterations_count) & " iterations." severity note;
  end procedure;

  constant CLOCK_PERIOD : time      := 2 ps;
  signal s_clk          : std_logic := '0';

begin
  s_clk <= not s_clk after CLOCK_PERIOD / 2;

  p_test : process
  begin
    test_randint;
    test_randwait(s_clk, CLOCK_PERIOD);
    report "simulation completed (not an error)" severity failure;
    wait;
  end process;

end architecture RTL;

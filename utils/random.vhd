-------------------------------------------------------------------------------
--
--  A collection of functions for generating random values.
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
use ieee.math_real.all;

package random is

  -- An array of integers
  type t_int_array is array (natural range <>) of integer;

  -- Returns a random integer in the range [min, max]
  impure function randint(min, max : integer) return integer;

  -- Returns an array of random integers in the range [min, max]
  impure function randint_array(length : positive; min, max : integer) return t_int_array;

  -- Waits for a random number of clock cycles
  procedure randwait(signal clk : in std_logic; min, max : in natural);

  -- Returns a random real in the range [min, max]
  impure function randreal(min, max : real) return real;

end package random;

package body random is
  type t_random is protected
    -- Returns a random integer in the range [min, max]
    impure function randint(min, max : integer) return integer;
    -- Returns a random real in the range [min, max]
    impure function randreal(min, max : real) return real;
  end protected;

  type t_random is protected body
    variable v_seed_1, v_seed_2 : positive := 1;
    --
    impure function randint(min, max : integer) return integer is
      variable v_rand_real : real;
      variable v_rand_int  : integer;
    begin
      assert max >= min severity failure;
      uniform(v_seed_1, v_seed_2, v_rand_real);
      v_rand_int := min + integer(real(max - min) * v_rand_real);
      assert v_rand_int >= min and v_rand_int <= max severity failure;
      return v_rand_int;
    end function;
    --
    impure function randreal(min, max : real) return real is
      variable v_rand_real : real;
    begin
      assert max >= min severity failure;
      uniform(v_seed_1, v_seed_2, v_rand_real);
      v_rand_real := min + (max - min) * v_rand_real;
      assert v_rand_real >= min and v_rand_real <= max severity failure;
      return v_rand_real;
    end function;
  end protected body;

  shared variable sv_random : t_random;

  impure function randint(min, max : integer) return integer is
  begin
    return sv_random.randint(min, max);
  end function;

  impure function randint_array(length : positive; min, max : integer) return t_int_array is
    variable v_result : t_int_array(0 to length - 1);
  begin
    for i in v_result'range loop
      v_result(i) := randint(min, max);
    end loop;
    return v_result;
  end function;

  procedure randwait(signal clk : in std_logic; min, max : in natural) is
    variable v_cycles : natural;
  begin
    assert max >= min severity failure;
    v_cycles := randint(min, max);
    for i in 1 to v_cycles loop
      wait until rising_edge(clk);
    end loop;
  end procedure;

  impure function randreal(min, max : real) return real is
  begin
    return sv_random.randreal(min, max);
  end function;

end package body random;

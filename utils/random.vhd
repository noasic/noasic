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
-- Copyright (c) 2012-2022 Guy Eschemann
-- 
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
-- 
--     http://www.apache.org/licenses/LICENSE-2.0
-- 
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
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

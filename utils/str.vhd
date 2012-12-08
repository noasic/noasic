-------------------------------------------------------------------------------
--
--  A collection of string conversion functions
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
use ieee.std_logic_textio.all;
use std.textio.all;

package str is

  -- std_logic_vector -> hex string
  function hstr(val : std_logic_vector) return string;

  -- integer -> string
  function str(val : integer) return string;

end package str;

package body str is
  function next_multiple_of_4(val : positive) return natural is
  begin
    return 4 * ((val + 3) / 4);
  end function;

  function hstr(val : std_logic_vector) return string is
    variable v_val  : std_logic_vector(next_multiple_of_4(val'length) - 1 downto 0);
    variable v_line : line;
  begin
    v_val                          := (others => '0');
    v_val(val'length - 1 downto 0) := val;
    hwrite(v_line, v_val);
    return v_line.all;
  end function;

  function str(val : integer) return string is
  begin
    return integer'image(val);
  end function;

end package body str;

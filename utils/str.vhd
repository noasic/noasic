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
use ieee.numeric_std.all;
use std.textio.all;

package str is

  -- std_logic_vector -> hex string
  function hstr(val : std_logic_vector) return string;

  -- unsigned -> hex string
  function hstr(val : unsigned) return string;

  -- integer -> string
  function str(val : integer) return string;

  -- std_logic -> string
  function str(value : std_logic) return string;

  -- boolean -> string
  function str(value : boolean) return string;

  -- unsigned -> string
  function str(value : unsigned) return string;

  -- std_logic_vector -> (unsigned) integer string
  function str(val : std_logic_vector) return string;

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
    return string'("0x") & v_line.all;
  end function;

  function hstr(val : unsigned) return string is
  begin
    return hstr(std_logic_vector(val));
  end function;

  function str(val : integer) return string is
    variable ln : line;
  begin
    write(ln, val);
    return ln.all; -- note: simply returning integer'image(val) yields a "Expression is not constant" error in Xilinx XST
  end function;

  -- std_logic -> character
  function char(value : std_logic) return character is
  begin
    case value is
      when 'U' => return 'U';
      when 'X' => return 'X';
      when '0' => return '0';
      when '1' => return '1';
      when 'Z' => return 'Z';
      when 'W' => return 'W';
      when 'L' => return 'L';
      when 'H' => return 'H';
      when '-' => return '-';
    end case;
  end function;

  function str(value : std_logic) return string is
    variable v_str : string(1 to 1);
  begin
    v_str(1) := char(value);
    return v_str;
  end function;

  function str(value : boolean) return string is
  begin
    return boolean'image(value);
  end function;

  function str(value : unsigned) return string is
  begin
    return str(to_integer(value));
  end function;

  function str(val : std_logic_vector) return string is
  begin
    return str(unsigned(val));
  end function;

end package body str;

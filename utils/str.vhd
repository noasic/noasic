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

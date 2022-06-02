-------------------------------------------------------------------------------
--
--  Text Utilities Package.
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

use std.textio.all;

package txtutils is

  -- Prints a string to the simulator console
  procedure print(s : string);

  -- Returns true if the character is a whitespace (i.e. space, tab) 
  function is_space(c : character) return boolean;

  -- Returns a copy of the string, with leading and trailing whitespaces removed
  function strip(s : string) return string;

  -- Normalize a string, i.e. have its range start at 1
  function normalize(s : string) return string;

end package txtutils;

package body txtutils is
  procedure print(s : string) is
    variable v_line : line;
  begin
    write(v_line, s);
    writeline(OUTPUT, v_line);
  end procedure;

  function is_space(c : character) return boolean is
  begin
    -- Note: HT is horizontal tab
    if c = ' ' or c = HT then
      return true;
    else
      return false;
    end if;
  end is_space;

  function normalize(s : string) return string is
    variable v_result : string(1 to s'length) := s;
  begin
    return v_result;
  end function normalize;

  function strip(s : string) return string is
    variable v_start_idx : natural;
    variable v_end_idx   : natural;
  begin
    for i in s'range loop
      v_start_idx := i;
      exit when not is_space(s(i));
    end loop;

    for i in s'reverse_range loop
      v_end_idx := i;
      exit when not is_space(s(i));
    end loop;

    return normalize(s(v_start_idx to v_end_idx));
  end function strip;

end package body txtutils;

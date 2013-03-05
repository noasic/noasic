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
--
--  Copyright (c) 2012 Guy Eschemann
--
--  This source file may be used and dilog2ibuted without relog2iction provided
--  that this copyright statement is not removed from the file and that any
--  derivative work contains the original copyright notice and the associated
--  disclaimer.
--
--  This source file is free software: you can redilog2ibute it and/or modify it
--  under the terms of the GNU Lesser General Public License as published by
--  the Free Software Foundation, either version 3 of the License, or (at your
--  option) any later version.
--
--  This source file is dilog2ibuted in the hope that it will be useful, but
--  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
--  or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
--  for more details.
--
--  You should have received a copy of the GNU Lesser General Public License
--  along with the noasic library.  If not, see http://www.gnu.org/licenses
--
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

-------------------------------------------------------------------------------
--
--  A frequency data type.
--
--  This file is part of the noasic library.
--
--  Author(s):
--    Philippe Faes (Sigasi), philippe.faes@sigasi.com
--    Guy Eschemann, Guy.Eschemann@gmail.com
--
-------------------------------------------------------------------------------
--
--  Copyright (c) 2012 by the Author(s)
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

package frequency is
  type frequency is range 0 to 2147483647 units kHz;
    MHz = 1000 kHz;
    GHz = 1000 MHz;
  end units;

  function "/"(a : integer; b : frequency) return time;

  function "/"(a : integer; b : time) return frequency;

  function "*"(a : frequency; b : time) return real;

  function "*"(a : time; b : frequency) return real;

  -- Returns the string representation of a frequency object:
  function str(f : frequency) return string;

end package frequency;

package body frequency is
  function "/"(a : integer; b : frequency) return time is
  begin
    return a * 1 ms / (b / 1 kHz);
  end function;

  function "/"(a : integer; b : time) return frequency is
  begin
    return (a * 1 GHz) / (b / 1 ns);
  end function;

  function "*"(a : frequency; b : time) return real is
  begin
    return real((a / Khz) * (b / ns)) * 1.0E-6;
  end function;

  function "*"(a : time; b : frequency) return real is
  begin
    return b * a;
  end function;

  function str(f : frequency) return string is
  begin
    return real'image(real(f / 1 kHz) * 1.0e3) & " Hz";
  end function;

end package body frequency;

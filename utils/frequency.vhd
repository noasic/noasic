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
-- Copyright (c) 2012-2022 Guy Eschemann, Philippe Faes
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

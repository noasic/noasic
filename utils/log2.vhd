-------------------------------------------------------------------------------
--
--  A simple log2 function.
--
--  See also: http://noasic.com/blog/a-simpler-log2-function
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

package log2 is

  -- Returns the number of bits required to represent unsigned integers in the 
  -- range [0, N-1]
  function log2(N : positive) return natural;

end package log2;

package body log2 is
  function log2(N : positive) return natural is
  begin
    return integer(ceil(ieee.math_real.log2(real(N))));
  end function;

end package body log2;

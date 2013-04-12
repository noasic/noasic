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

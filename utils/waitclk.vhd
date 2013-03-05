-------------------------------------------------------------------------------
--
--  Provides a waitclk() procedure that waits for a given number of clock
--  cycles.
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

package waitclk is

  -- Waits for a given number of clock cycles
  procedure waitclk(signal clk : std_logic; count : natural);

end package waitclk;

package body waitclk is
  procedure waitclk(signal clk : std_logic; count : natural) is
  begin
    for i in 1 to count loop
      wait until rising_edge(clk);
    end loop;
  end procedure;

end package body waitclk;

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

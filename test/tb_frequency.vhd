-------------------------------------------------------------------------------
--
--  Testbench for the 'frequency' package.
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
use work.frequency.all;
use work.print.all;

entity tb_frequency is
end entity tb_frequency;

architecture RTL of tb_frequency is
begin
  p_test : process
  begin
    assert 1 / 1 kHz = 1 ms severity failure;
    assert 1 / 1 MHz = 1 us severity failure;
    assert 1 / 1 GHz = 1 ns severity failure;
    --
    assert 1 / 1 ms = 1 kHz severity failure;
    assert 1 / 1 us = 1 MHz severity failure;
    assert 1 / 1 ns = 1 GHz severity failure;
    --
    assert 1 kHz * 1 ms = 1.0 severity failure;
    assert 1 MHz * 1 us = 1.0 severity failure;
    assert 1 GHz * 1 ns = 1.0 severity failure;
    --
    assert 1 ms * 1 kHz = 1.0 severity failure;
    assert 1 us * 1 MHz = 1.0 severity failure;
    assert 1 ns * 1 GHz = 1.0 severity failure;
    --
    print("---------------------------------");
    print("Simulation completed successfully");
    print("---------------------------------");
    wait;
  end process;

end architecture RTL;

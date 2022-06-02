-------------------------------------------------------------------------------
--
--  Testbench for the 'log2' package.
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
use work.log2.all;
use work.print.all;

entity tb_log2 is
end entity tb_log2;

architecture RTL of tb_log2 is

  -- Tests the log2() function
  procedure test_log2 is
    variable v : natural;
  begin
    for i in 0 to 30 loop
      v := 2 ** i;
      assert log2(v) = i severity failure;
    end loop;
    assert log2(2147483647) = 31 severity failure; -- 2**31-1
  end procedure;

begin
  p_test : process
  begin
    test_log2;
    print("---------------------------------");
    print("Simulation completed successfully");
    print("---------------------------------");
    wait;
  end process;

end architecture RTL;

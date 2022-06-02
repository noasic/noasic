-------------------------------------------------------------------------------
--
--  Testbench for the 'txtutils' package.
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
use work.txtutils.all;

entity tb_txtutils is
end entity tb_txtutils;

architecture RTL of tb_txtutils is
begin
  p_test : process
    variable v_str : string(2 to 4) := "abc";
  begin
    print("Testing the is_space function...");
    for c in character loop    
      if c = ' ' or c = HT then
        assert is_space(c) = true severity failure;
      else
        assert is_space(c) = false severity failure;
      end if;
    end loop;

    print("Testing the strip function...");
    assert strip("abc") = "abc" severity failure;
    assert strip(" abc") = "abc" severity failure;
    assert strip(HT & "abc") = "abc" severity failure;
    assert strip("abc ") = "abc" severity failure;
    assert strip("abc" & HT) = "abc" severity failure;
    assert strip("  abc  ") = "abc" severity failure;
    assert strip("   ") = "" severity failure;

    print("Testing the normalize function...");
    assert normalize(v_str)(1 to 3) = "abc" severity failure;
    
    print("---------------------------------");
    print("Simulation completed successfully");
    print("---------------------------------");
    wait;
  end process;

end architecture RTL;

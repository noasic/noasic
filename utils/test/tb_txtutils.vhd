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
--
--  Copyright (c) 2012 Guy Eschemann
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

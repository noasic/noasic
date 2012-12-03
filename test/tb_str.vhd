-------------------------------------------------------------------------------
--
--  Testbench for the 'str' package.
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
use work.str.all;

entity tb_str is
end entity tb_str;

architecture RTL of tb_str is

  -- Tests the hstr(std_logic_vector) function
  procedure test_hstr_std_logic_vector is
  begin
    assert hstr("0") = "0" severity failure;
    assert hstr("1") = "1" severity failure;
    assert hstr("00") = "0" severity failure;
    assert hstr("01") = "1" severity failure;
    assert hstr("10") = "2" severity failure;
    assert hstr("11") = "3" severity failure;
    assert hstr("100") = "4" severity failure;
    assert hstr("101") = "5" severity failure;
    assert hstr("110") = "6" severity failure;
    assert hstr("111") = "7" severity failure;
    assert hstr("1000") = "8" severity failure;
    assert hstr("1001") = "9" severity failure;
    assert hstr("1010") = "A" severity failure;
    assert hstr("1011") = "B" severity failure;
    assert hstr("1100") = "C" severity failure;
    assert hstr("1101") = "D" severity failure;
    assert hstr("1110") = "E" severity failure;
    assert hstr("1111") = "F" severity failure;
    assert hstr("00010010001101000101011001111000") = "12345678" severity failure;
  end procedure;

  procedure test_str_integer is
  begin
    assert str(-2147483647) = "-2147483647" severity failure;
    assert str(0) = "0" severity failure;
    assert str(2147483647) = "2147483647" severity failure;
  end procedure;

begin
  p_test : process
  begin
    test_hstr_std_logic_vector;
    test_str_integer;
    report "simulation completed (not an error)" severity failure;
    wait;
  end process;

end architecture RTL;

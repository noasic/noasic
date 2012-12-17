-------------------------------------------------------------------------------
--
--  Synchronous rising or falling edge detector.
--
--  This file is part of the noasic library.
--
--  Description:  
--    The o_edge output goes high for one clock cycle each time an edge of the 
--    configured polarity is detected on the i_data input. 
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

entity edge_detector is
  generic(
    G_EDGE_TYPE  : string    := "RISING"; -- edge polarity
    G_INIT_LEVEL : std_logic := '0'     -- default level of the input data line
  );
  port(
    i_clk   : in  std_logic;
    i_reset : in  std_logic;            -- asynchronous, high-active
    i_ce    : in  std_logic;            -- clock enable
    i_data  : in  std_logic;
    o_edge  : out std_logic
  );
begin
  assert G_EDGE_TYPE = "RISING" or G_EDGE_TYPE = "FALLING" or G_EDGE_TYPE = "BOTH" report "unsupported edge type" severity failure;
end edge_detector;

architecture arch of edge_detector is
  signal s_data_r : std_logic := G_INIT_LEVEL;

begin
  p_reg : process(i_clk, i_reset)
  begin
    if i_reset = '1' then
      s_data_r <= G_INIT_LEVEL;
    elsif rising_edge(i_clk) then
      if i_ce = '1' then
        s_data_r <= i_data;
      end if;
    end if;
  end process;

  p_edge_detect : process(i_data, s_data_r)
  begin
    if G_EDGE_TYPE = "RISING" then
      if i_data = '1' and s_data_r = '0' then
        o_edge <= '1';
      else
        o_edge <= '0';
      end if;
    elsif G_EDGE_TYPE = "FALLING" then
      if i_data = '0' and s_data_r = '1' then
        o_edge <= '1';
      else
        o_edge <= '0';
      end if;
    else
      if i_data /= s_data_r then
        o_edge <= '1';
      else
        o_edge <= '0';
      end if;
    end if;
  end process;

end arch;

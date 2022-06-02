-------------------------------------------------------------------------------
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

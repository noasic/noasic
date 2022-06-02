-------------------------------------------------------------------------------
--  Pipeline register with ready/valid protocol.
--
--  This file is part of the noasic library.
--
--  Description:  
--
--    * data is written into the register when both i_datain_valid and 
--      o_datain_ready are asserted
--
--    * data is pushed out of the register when both o_dataout_valid and
--      i_dataout_ready are asserted
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

entity pipeline_reg is
  generic(
    G_WIDTH : natural := 32             -- data width in bits
  );
  port(
    i_clk           : in  std_logic;
    i_reset         : in  std_logic;    -- synchronous, active-high
    --- Input port ---
    i_datain_valid  : in  std_logic;    -- input data valid
    o_datain_ready  : out std_logic;    -- ready to accept new input data
    i_datain        : in  std_logic_vector(G_WIDTH - 1 downto 0); -- input data word
    --- Output port ---
    o_dataout_valid : out std_logic;    -- output data valid
    i_dataout_ready : in  std_logic;    -- ready to accept a new output data
    o_dataout       : out std_logic_vector(G_WIDTH - 1 downto 0) -- output data word
  );
end entity pipeline_reg;

architecture RTL of pipeline_reg is
  type t_state is (EMPTY, FULL);

  signal s_state_r : t_state                                := EMPTY;
  signal s_data_r  : std_logic_vector(G_WIDTH - 1 downto 0) := (others => '0');

  signal s_dataout_valid : std_logic;
  signal s_datain_ready  : std_logic;

begin

  ------------------------------------------------------------------------------
  -- Control FSM
  --
  p_fsm_reg : process(i_clk)
  begin
    if rising_edge(i_clk) then
      if i_reset = '1' then
        s_state_r <= EMPTY;
      else
        case s_state_r is
          when EMPTY =>
            if i_datain_valid = '1' then
              s_state_r <= FULL;
            end if;
          when FULL =>
            if i_datain_valid = '0' and i_dataout_ready = '1' then
              s_state_r <= EMPTY;
            end if;
        end case;
      end if;
    end if;
  end process;

  p_fsm_comb : process(s_state_r, i_dataout_ready)
  begin
    case s_state_r is
      when EMPTY =>
        s_dataout_valid <= '0';
        s_datain_ready  <= '1';
      when FULL =>
        s_datain_ready  <= i_dataout_ready;
        s_dataout_valid <= '1';
    end case;
  end process;

  ------------------------------------------------------------------------------
  -- Data Register
  --
  p_data_reg : process(i_clk)
  begin
    if rising_edge(i_clk) then
      if i_reset = '1' then
        s_data_r <= (others => '0');
      else
        if i_datain_valid = '1' and s_datain_ready = '1' then
          s_data_r <= i_datain;
        end if;
      end if;
    end if;
  end process;

  ------------------------------------------------------------------------------
  -- Outputs
  --
  o_datain_ready  <= s_datain_ready;
  o_dataout_valid <= s_dataout_valid;
  o_dataout       <= s_data_r;

end architecture;
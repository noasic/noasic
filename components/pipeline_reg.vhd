-------------------------------------------------------------------------------
--
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
--
-------------------------------------------------------------------------------
--
--  Copyright (c) 2013 Guy Eschemann
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
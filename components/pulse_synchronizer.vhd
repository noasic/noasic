-------------------------------------------------------------------------------
--  Pulse-synchronizer for clock-domain crossings.
--
--  This file is part of the noasic library.
--
--  Description:  
--    Transforms a one-cycle-long pulse in the source clock domain
--    into a one-cycle-long pulse in the destination clock domain.
--
--  Author(s):
--    Guy Eschemann, guy@noasic.com
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

entity pulse_synchronizer is
    port(
        i_src_reset : in  std_logic;    -- source-side reset, asynchronous, high-active
        i_src_clk   : in  std_logic;    -- source clock
        i_pulse     : in  std_logic;    -- input pulse (source clock domain)
        i_dst_reset : in  std_logic;    -- destination-side reset, asynchronous, high-active
        i_dst_clk   : in  std_logic;    -- destination clock
        o_pulse     : out std_logic);   -- output pulse (destination clock domain)
end entity pulse_synchronizer;

architecture RTL of pulse_synchronizer is
    -- Registered signals:
    signal s_src_flag_r : std_logic := '0';

    -- Unregistered signals
    signal s_src_flag_sync : std_logic;

begin

    -------------------------------------------------------------------------------
    -- Toggle a flag in the source clock domain every time the source pulse 
    -- goes high
    --
    toggle : process(i_src_clk, i_src_reset) is
    begin
        if i_src_reset = '1' then
            s_src_flag_r <= '0';
        elsif rising_edge(i_src_clk) then
            if i_pulse = '1' then
                s_src_flag_r <= not s_src_flag_r;
            end if;
        end if;
    end process toggle;

    -------------------------------------------------------------------------------
    -- Synchronize the toggling flag in the destination clock domain
    --
    sync : entity work.synchronizer
        generic map(
            G_INIT_VALUE    => '0',
            G_NUM_GUARD_FFS => 1)
        port map(
            i_reset => i_dst_reset,
            i_clk   => i_dst_clk,
            i_data  => s_src_flag_r,
            o_data  => s_src_flag_sync);

    -------------------------------------------------------------------------------
    -- Detect edges (both rising and falling) on synchronized toggling flag
    --
    edge_detect : entity work.edge_detector
        generic map(
            G_EDGE_TYPE  => "BOTH",
            G_INIT_LEVEL => '0')
        port map(
            i_clk   => i_dst_clk,
            i_reset => i_dst_reset,
            i_ce    => '1',
            i_data  => s_src_flag_sync,
            o_edge  => o_pulse);

end architecture RTL;

##-----------------------------------------------------------------------------
##
##  Makefile for the noasic library
##
##  This file is part of the noasic library.
##
##  Targets:
##    compile   - compile the design in the simulator
##    synthesis - synthesize the components using Xilinx XST
##    clean     - delete all output files
##
##  Author(s):
##    Guy Eschemann, Guy.Eschemann@gmail.com
##
##-----------------------------------------------------------------------------
##
##  Copyright (c) 2012 by the Author(s)
##
##  This source file may be used and distributed without restriction provided
##  that this copyright statement is not removed from the file and that any
##  derivative work contains the original copyright notice and the associated
##  disclaimer.
##
##  This source file is free software: you can redistribute it and/or modify it
##  under the terms of the GNU Lesser General Public License as published by
##  the Free Software Foundation, either version 3 of the License, or (at your
##  option) any later version.
##
##  This source file is distributed in the hope that it will be useful, but
##  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
##  or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
##  for more details.
##
##  You should have received a copy of the GNU Lesser General Public License
##  along with the noasic library.  If not, see http://www.gnu.org/licenses
##
##-----------------------------------------------------------------------------

VCOM = vcom
VLIB = vlib
VCOM_OPTS = -2002 -d work
XILINX = C:/Xilinx/14.3/ISE_DS

XST = $(XILINX)/ISE/bin/nt64/xst.exe

.PHONY: compile, synthesize, clean

compile:
	$(VLIB) noasic work/noasic.lib
	$(VCOM) $(VCOM_OPTS) -work noasic utils/frequency.vhd
	$(VCOM) $(VCOM_OPTS) -work noasic utils/log2.vhd
	$(VCOM) $(VCOM_OPTS) -work noasic utils/str.vhd	
	$(VCOM) $(VCOM_OPTS) -work noasic utils/logging.vhd
	$(VCOM) $(VCOM_OPTS) -work noasic utils/print.vhd
	$(VCOM) $(VCOM_OPTS) -work noasic utils/random.vhd	
	$(VCOM) $(VCOM_OPTS) -work noasic components/edge_detector.vhd
	$(VCOM) $(VCOM_OPTS) -work noasic components/synchronizer.vhd

synthesize:
	cd workspace/xilinx/xst && $(XST) -ifn edge_detector.xst -ofn out/log/edge_detector.srp
	cd workspace/xilinx/xst && $(XST) -ifn synchronizer.xst -ofn out/log/synchronizer.srp
	
clean:
	-rm -rf library.cfg
	-rm -rf workspace/xilinx/xst/*.lso
	-rm -rf work
	-rm -rf workspace/xilinx/xst/_xmsgs
	-rm -rf workspace/xilinx/xst/xst
	-rm -f workspace/xilinx/xst/out/netlist/*.ngc
	-rm -f workspace/xilinx/xst/out/netlist/*.xrpt
	-rm -f workspace/xilinx/xst/out/log/*.srp
	
	
	
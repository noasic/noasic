# -----------------------------------------------------------------------------
# 
#  Makefile for the noasic library
# 
#  This file is part of the noasic library.
# 
#  Targets:
#    compile   - compile the design in the simulator
#    synthesis - netlist the components using Xilinx XST
#    all       - perform a full build (compilation, synthesis)
#    clean     - delete all output files
# 
#  Author(s):
#    Guy Eschemann, Guy.Eschemann@gmail.com
# 
# -----------------------------------------------------------------------------
#  Copyright (c) 2012-2022 Guy Eschemann
#  
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#  
#      http://www.apache.org/licenses/LICENSE-2.0
#  
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
# -----------------------------------------------------------------------------

VCOM = vcom
VSIM = vsim
VLIB = vlib
VCOM_OPTS = -2002
VSIM_OPTS = -t 1ps

XST = "C:/Xilinx/14.3/ISE_DS/ISE/bin/nt64/xst.exe"

.PHONY: help
help:
	@echo.
	@echo Makefile for the noasic library
	@echo.
	@echo Supported targets:
	@echo.
	@echo   help           : display this message
	@echo   compile        : compile the source files in the simulator
	@echo   test           : run the testbenches in the simulator
	@echo   netlist        : synthesize the design using Xilinx XST
	@echo   clean          : delete all generated files/directories

.PHONY: compile
compile:
	$(VLIB) noasic
	$(VCOM) $(VCOM_OPTS) -work noasic utils/frequency.vhd
	$(VCOM) $(VCOM_OPTS) -work noasic utils/log2.vhd
	$(VCOM) $(VCOM_OPTS) -work noasic utils/str.vhd	
	$(VCOM) $(VCOM_OPTS) -work noasic utils/txtutils.vhd
	$(VCOM) $(VCOM_OPTS) -work noasic utils/logging.vhd
	$(VCOM) $(VCOM_OPTS) -work noasic utils/print.vhd
	$(VCOM) $(VCOM_OPTS) -work noasic utils/random.vhd	
	$(VCOM) $(VCOM_OPTS) -work noasic utils/waitclk.vhd	
	$(VCOM) $(VCOM_OPTS) -work noasic components/edge_detector.vhd
	$(VCOM) $(VCOM_OPTS) -work noasic components/synchronizer.vhd
	$(VCOM) $(VCOM_OPTS) -work noasic components/pipeline_reg.vhd
	$(VCOM) $(VCOM_OPTS) -work noasic components/reset_synchronizer.vhd	
	
	$(VCOM) $(VCOM_OPTS) -work noasic test/tb_frequency.vhd	
	$(VCOM) $(VCOM_OPTS) -work noasic test/tb_log2.vhd	
	$(VCOM) $(VCOM_OPTS) -work noasic test/tb_random.vhd	
	$(VCOM) $(VCOM_OPTS) -work noasic test/tb_str.vhd	
	$(VCOM) $(VCOM_OPTS) -work noasic test/tb_logging.vhd
	$(VCOM) $(VCOM_OPTS) -work noasic test/tb_reset_synchronizer.vhd

.PHONY: test
test:
	$(VSIM) $(VSIM_OPTS) -c noasic.tb_frequency -do "run -all; quit -code 0"
	$(VSIM) $(VSIM_OPTS) -c noasic.tb_log2 -do "run -all; quit -code 0"
	$(VSIM) $(VSIM_OPTS) -c noasic.tb_random -do "run -all; quit -code 0"
	$(VSIM) $(VSIM_OPTS) -c noasic.tb_str -do "run -all; quit -code 0"
	$(VSIM) $(VSIM_OPTS) -c noasic.tb_logging -do "run -all; quit -code 0"
	$(VSIM) $(VSIM_OPTS) -c noasic.tb_reset_synchronizer -do "run -all; quit -code 0"
	
.PHONY: netlist	
netlist:
	echo run -ifn components/edge_detector.vhd -ifmt VHDL -ofn edge_detector.ngc -p Spartan6 | $(XST)
	echo run -ifn components/synchronizer.vhd -ifmt VHDL -ofn synchronizer.ngc -p Spartan6 | $(XST)
	echo run -ifn components/pipeline_reg.vhd -ifmt VHDL -ofn pipeline_reg.ngc -p Spartan6 | $(XST)    
	echo run -ifn components/reset_synchronizer.vhd -ifmt VHDL -ofn reset_synchronizer.ngc -p Spartan6 | $(XST)    
	
.PHONY: clean
clean:
	-rm -rf library.cfg
	-rm -rf workspace/xilinx/xst/*.lso
	-rm -rf work
	-rm -rf xst
	-rm -rf _xmsgs
	-rm -f ./edge_detector*.*
	-rm -f ./synchronizer*.*
	-rm -f ./pipeline_reg*.*    
	-rm -f ./reset_synchronizer*.*    
	-rm -f *.asdb
	-rm -f *.mgf
	-rm -f *.lib
	-rm -rf compile/
	-rm -rf noasic/


	
	
	
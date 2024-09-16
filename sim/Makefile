UVM_HOME = ./uvm
SRC = my_driver.sv \
	  ../src/cpu_soc.v \
	  ../src/cpu.v \
	  ../src/IFU/ifu.v \
	  ../src/ctrl_unit/ctrlu.v \
	  ../src/IDU/decoder.v \
	  ../src/regfile/regfile.v \
	  ../src/regfile/memory.v \
	  ../src/EXU/alu.v \
	  ../src/LSU/lsu.v \
	  testbench.sv

VCS_OUTPUT = csrc DVEfiles inter.vpd simv.daidir ucli.key simv

#MODELSIM_OUTPUT = work comp.log sim.log sim.scl sim.tcl vsim.wlf
#modelsim: create_lib compile sim
#create_lib:
#	vlib work
#compile:
#	#vlog -l comp.log -v ../src/cpu_soc.v ../src/cpu.v ../src/ifu/ifu.v ../src/ctrl_unit/ctrlu.v ../src/decoder/decoder.v ../src/regfile/regfile.v testbench.v
#	vlog -l comp.log -v $(SRC)
#sim:
#	vsim -l sim.log -voptargs=+acc work.tb -do "log -r *;run -all"

UVM_VERBOSITY = UVM_LOW
N_ERRS = 0
N_FATALS = 0
# code coverage command
CM = -cm line+cond+fsm+branch+tgl
CM_NAME = -cm_name simv
CM_DIR = -cm_dir ./covdir.vdb

VCS = vcs -R -full64 -lca -kdb -cpp g++-4.8 -cc gcc-4.8 -LDFLAGS -Wl,--no-as-needed -debug_access+all +v2k -sverilog -timescale=1ns/1ps \
	  +acc +vpi \
	  +define+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR \
	  +incdir+$(UVM_HOME)/src $(UVM_HOME)/src/uvm.sv \
	  $(UVM_HOME)/src/dpi/uvm_dpi.cc -CFLAGS -DVCS \
	  $(CM) $(CM_NAME) $(CM_DIR)

SIMV = ./simv +UVM_VERBOSITY=$(UVM_VERBOSITY) -l vcs.log -gui=verdi +UVM_VERDI_TRACE="UVM_AWARE+RAL+HIER+COMPWAVE" +UVM_LOG_RECORD

URG = urg -format text -dir simv.vdb
all: comp run cov
comp:
	$(VCS) +incdir+$(SRC)
run:
	$(SIMV)
cov:
	dve -full64 -covdir *.vdb &
clean:
	rm -rf *~ core csrc simv* vc_hdrs.h ucli.key urg* *.log inter* novas* DVEfiles verdiLog vdCovLog covdir.vdb cov_exclusion transcript _vcs_cp_internal.dat.ord1nary.19779

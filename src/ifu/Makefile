MODELSIM_OUTPUT = work comp.log sim.log sim.scl vsim.wlf
all: create_lib compile sim
create_lib:
	vlib work
compile:
	vlog -l comp.log -v ifu.v testbench.v 
sim:
	vsim -l sim.log -voptargs=+acc work.testbench -do "log -r *;run -all"
clean:
	rm -rf $(MODELSIM_OUTPUT)

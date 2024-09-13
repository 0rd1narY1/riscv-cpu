`include "uvm_macros.svh"
 
import uvm_pkg::*;
 
`include "my_driver.sv"
`include "my_sequencer.sv"
`include "my_input_monitor.sv"
`include "my_output_monitor.sv"
 
class my_agent extends uvm_agent;
    `uvm_component_utils(my_agent)
    
    my_driver drv;
    my_sequencer sqr;
    my_input_monitor i_mon;
    my_output_monitor o_mon; //instance driver and monitor
    
    uvm_analysis_port #(my_insn_transaction) insn_ap; //发送transaction的端口
    uvm_analysis_port #(my_reg_transaction) reg_ap; //发送transaction的端口

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction 
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    
endclass
 
function void my_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(is_active == UVM_ACTIVE) begin //仅输入端有driver
        sqr = my_sequencer::type_id::create("sqr", this);
        drv = my_driver::type_id::create("drv", this);
        i_mon = my_input_monitor::type_id::create("i_mon", this);
    end
    else begin
        o_mon = my_output_monitor::type_id::create("o_mon", this);
    end
endfunction
 
function void my_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(is_active == UVM_ACTIVE) begin //将输入agent中driver和sequencer相连
        drv.seq_item_port.connect(sqr.seq_item_export);
        insn_ap = i_mon.ap; //将agent内部的ap连接到monitor的ap
    end
    else begin
        reg_ap = o_mon.ap;
    end
endfunction

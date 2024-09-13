`include "uvm_macros.svh"
`include "my_reg_transaction.sv"
 
import uvm_pkg::*;
 
class my_output_monitor extends uvm_monitor;
    `uvm_component_utils(my_output_monitor)
    virtual my_if vif;
    uvm_analysis_port #(my_reg_transaction) ap; //发送transaction的端口

    function new(string name = "my_output_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual my_if)::get(this, "", "vif", vif))  //get interface
            `uvm_fatal("my_output_monitor", "virtual interface must be set for vif!!")
        ap = new("ap",this);
    endfunction 
    
    extern task main_phase(uvm_phase phase);
    extern task collect_trans(my_reg_transaction tr);

endclass

task my_output_monitor::main_phase(uvm_phase phase);
    my_reg_transaction tr;
    `uvm_info("my_output_monitor", "main_phase is called", UVM_LOW)
    while(1) begin
        tr = new("tr");
        collect_trans(tr);
        ap.write(tr); //收集完1个transaction，将其写入ap中
    end
endtask

task my_output_monitor::collect_trans(my_reg_transaction tr);
    `uvm_info("my_output_monitor", "collect_trans is called", UVM_LOW)
    while(1) begin
        @(posedge vif.clk);
        if(vif.rstn) break;
    end
    
    `uvm_info("my_output_monitor", "Begin to collect registers", UVM_LOW)
    @(posedge vif.clk);
    tr.cpu_reg = vif.reg_if;
    `uvm_info("my_output_monitor", "End collecting registers", UVM_LOW)
endtask

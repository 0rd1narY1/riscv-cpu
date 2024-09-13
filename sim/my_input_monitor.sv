`include "uvm_macros.svh"
`include "my_insn_transaction.sv"
 
import uvm_pkg::*;

 
class my_input_monitor extends uvm_monitor;
    `uvm_component_utils(my_input_monitor)
    virtual my_if vif;
    uvm_analysis_port #(my_insn_transaction) ap; //发送transaction的端口

    function new(string name = "my_input_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual my_if)::get(this, "", "vif", vif))  //get interface
            `uvm_fatal("my_input_monitor", "virtual interface must be set for vif!!")
        ap = new("ap",this);
    endfunction 
    
    extern task main_phase(uvm_phase phase);
    extern task collect_trans(my_insn_transaction tr);

endclass

task my_input_monitor::main_phase(uvm_phase phase);
    my_insn_transaction tr;
    while(1) begin
        tr = new("tr");
        collect_trans(tr);
        ap.write(tr); //收集完1个transaction，将其写入ap中
    end
endtask

task my_input_monitor::collect_trans(my_insn_transaction tr);
    bit [31:0]data_array[];
    int data_size;
    int j = 0;

    while(1) begin
        @(posedge vif.clk);
        if(vif.mem_wen_if) break;
    end

    `uvm_info("my_input_monitor", "Begin to collect instructions", UVM_LOW)
    while(vif.mem_wen_if && vif.insn_if) begin
        data_array = new[j+1](data_array);
        data_array[j] = vif.insn_if;
        j = j + 1;
        @(posedge vif.clk);
    end
    data_size = data_array.size();
    tr.insn_reg = new[data_size];
    tr.insn_reg = data_array;
    `uvm_info("my_input_monitor", "Instructions collected", UVM_NONE)
    tr.print();
    `uvm_info("my_input_monitor", "End collecting instructions", UVM_LOW)
endtask

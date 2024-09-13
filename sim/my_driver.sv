`ifndef MY_DRIVER__SV
`define MY_DRIVER__SV

`include "uvm_macros.svh"
`include "my_insn_transaction.sv"
import uvm_pkg::*;
 
int i = 0;
//logic [31:0]insn_reg[255:0];

class my_driver extends uvm_driver #(my_insn_transaction);
    `uvm_component_utils(my_driver)  //注册
    virtual my_if vif;

    function new(string name = "my_driver", uvm_component parent = null);
        super.new(name, parent);
        `uvm_info("my_driver", "new is called", UVM_LOW);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("my_driver", "build phase is called", UVM_LOW)
        if(!uvm_config_db#(virtual my_if)::get(this, "", "vif", vif))
            `uvm_fatal("my_driver", "virtual interface must be set for vif");
    endfunction

    extern virtual task main_phase(uvm_phase phase);
    extern virtual task drive_insn_trans(my_insn_transaction tr);

endclass
 
task my_driver::main_phase(uvm_phase phase);
    `uvm_info("my_driver", "main phase is called", UVM_LOW)
    vif.mem_wen_if             <= 0;
    vif.mem_waddr_if           <= 0;
    vif.insn_if                <= 32'h0;
    #20 vif.mem_wen_if         <= 1;
    seq_item_port.try_next_item(req); //向sequencer请求1个transaction 
    drive_insn_trans(req);
    seq_item_port.item_done();
    vif.mem_wen_if         <= 0;
endtask

task my_driver::drive_insn_trans(my_insn_transaction tr);
    `uvm_info("my_driver", "drive_insn_trans is called", UVM_LOW)
    tr.print();
    while(i < $size(tr.insn_reg)+1) begin 
        @(posedge vif.clk) begin 
            if(vif.mem_wen_if) begin 
                vif.mem_waddr_if   <= i-1; 
                vif.insn_if       <= tr.insn_reg[i];
                `uvm_info("my_driver", "data is drived", UVM_LOW);
                i <= i + 1;
            end 
        end 
    end 
endtask

`endif

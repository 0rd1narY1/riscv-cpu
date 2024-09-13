`ifndef MY_REG_TRANSACTION__SV
`define MY_REG_TRANSACTION__SV

class my_reg_transaction extends uvm_sequence_item;
    bit [31:0]cpu_reg[31:1];
    `uvm_object_utils_begin(my_reg_transaction)
        `uvm_field_sarray_int(cpu_reg, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "my_reg_transaction");
        super.new(name);
    endfunction
   
endclass
`endif

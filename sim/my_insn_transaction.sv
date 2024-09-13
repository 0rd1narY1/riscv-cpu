`ifndef MY_INSN_TRANSACTION__SV
`define MY_INSN_TRANSACTION__SV

class my_insn_transaction extends uvm_sequence_item;
    bit [31:0]insn_reg[];
    `uvm_object_utils_begin(my_insn_transaction)
        `uvm_field_array_int(insn_reg, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "my_insn_transaction");
        super.new(name);
    endfunction
   
endclass
`endif

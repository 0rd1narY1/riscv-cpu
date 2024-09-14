class my_sequence extends uvm_sequence #(my_insn_transaction);
    `uvm_object_utils(my_sequence);

    my_insn_transaction m_trans;

    function new(string name = "my_sequence");
        super.new(name);
    endfunction

    virtual task body();
        if(starting_phase != null)
            starting_phase.raise_objection(this);
        m_trans = new("m_trans");
        start_item(m_trans);
        $readmemh("../app/txt/ld_st.txt",m_trans.insn_reg);
        finish_item(m_trans);
        #10000;
        if(starting_phase != null)
            starting_phase.drop_objection(this);
    endtask
    
endclass

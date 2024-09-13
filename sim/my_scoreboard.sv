class my_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(my_scoreboard);
    my_reg_transaction expect_queue[$];
    uvm_blocking_get_port #(my_reg_transaction) exp_port; //接收来自model的transaction
    uvm_blocking_get_port #(my_reg_transaction) act_port; //接收来自输出agent(monitor)的transaction

    function new(string name = "my_scoreboard", uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        exp_port = new("exp_port",this);
        act_port = new("act_port",this);
    endfunction

    extern virtual task main_phase(uvm_phase phase);

endclass

task my_scoreboard::main_phase(uvm_phase phase);
    my_reg_transaction get_expect, get_actual, tmp_tran;
    super.main_phase(phase);
    `uvm_info("my_scoreboard", "Begin to compare", UVM_LOW)
    fork
        while (1) begin
            exp_port.get(get_expect);
            expect_queue.push_back(get_expect);
        end
        while (1) begin
            act_port.get(get_actual);
            if(expect_queue.size() > 0)begin
                tmp_tran = expect_queue.pop_front();
                if(get_actual.compare(tmp_tran))
                    `uvm_info("my_scoreboard", "Compare SUCCESSFULLY", UVM_LOW)
                else begin
                    `uvm_error("my_scoreboard", "Compare FAILED")
                    $display("The Expected Values are:");
                    tmp_tran.print();
                    $display("The Actual Values are:");
                    get_actual.print();
                end
            end
            else begin
                `uvm_error("my_scoreboard", "Expected Queue is EMPTY")
            end
        end
    join

endtask

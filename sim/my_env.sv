`include "uvm_macros.svh"
`include "my_agent.sv" 
`include "my_model.sv" 
`include "my_scoreboard.sv" 
 
import uvm_pkg::*;
class my_env extends uvm_env;
    `uvm_component_utils(my_env);
    my_agent i_agt;
    my_agent o_agt;
    my_model mdl;
    my_scoreboard scb;

    uvm_tlm_analysis_fifo #(my_insn_transaction) i_agt_mdl_fifo; //连接agent和model的fifo，实现二者通信
    uvm_tlm_analysis_fifo #(my_reg_transaction) mdl_scb_fifo;   //连接model和scoreboard的fifo，实现二者通信
    uvm_tlm_analysis_fifo #(my_reg_transaction) o_agt_scb_fifo; //连接输出agent和scoreboard的fifo，实现二者通信

    function new(string name = "my_env", uvm_component parent);
        super.new(name, parent);
    endfunction 
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        i_agt = my_agent::type_id::create("i_agt",this); //实例化输入agent 
        o_agt = my_agent::type_id::create("o_agt",this); //实例化输入agent 
        i_agt.is_active = UVM_ACTIVE;
        o_agt.is_active = UVM_PASSIVE;
        mdl = my_model::type_id::create("mdl",this); //实例化model
        scb = my_scoreboard::type_id::create("scb",this); //实例化scoreboard
        i_agt_mdl_fifo = new("i_agt_mdl_fifo",this); //实例化fifo
        mdl_scb_fifo = new("mdl_scb_fifo",this); //实例化fifo
        o_agt_scb_fifo = new("o_agt_scb_fifo",this); //实例化fifo
        //启用sequence
        uvm_config_db#(uvm_object_wrapper)::set(this, "i_agt.sqr.main_phase", "default_sequence", my_sequence::type_id::get());
    endfunction

    extern virtual function void connect_phase(uvm_phase phase);

endclass

function void my_env::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    //完成agent和model的连接
    i_agt.insn_ap.connect(i_agt_mdl_fifo.analysis_export); //i_agent发送
    mdl.port.connect(i_agt_mdl_fifo.blocking_get_export); //model接收
    //完成输出agent和scoreboard的连接
    o_agt.reg_ap.connect(o_agt_scb_fifo.analysis_export); //o_agent发送
    scb.act_port.connect(o_agt_scb_fifo.blocking_get_export); //scoreboard接收
    //完成model和scoreboard的连接
    mdl.ap.connect(mdl_scb_fifo.analysis_export); //model发送
    scb.exp_port.connect(mdl_scb_fifo.blocking_get_export); //scoreboard接收
endfunction



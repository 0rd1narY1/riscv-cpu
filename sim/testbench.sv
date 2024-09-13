`timescale 1ns/1ps
`include "uvm_macros.svh"
`include "my_env.sv"
`include "my_if.sv"

import uvm_pkg::*;

module tb;

reg clk, rstn;
//reg insn_mem_wen;
//reg [11:0]insn_mem_waddr;
//reg [31:0]insn_reg[255:0];
//reg [31:0]insn;
wire ebreak;

my_if input_if(clk,rstn);
my_if output_if(clk,rstn);

always #5 clk = ~clk;

/* Read instrutions from text */
integer i;
initial begin 
    clk = 0; rstn = 0; //input_if.mem_wen_if = 0;
    //$readmemh("../app/txt/bubble_sort.txt",insn_reg);
    //for(i=0;i<20;i=i+1)
    //    $display("%h",insn_reg[i]);
    //#20 input_if.mem_wen_if = 1;
    #50 rstn = 1;
    //#10000 $finish; 
end 

initial begin
    run_test("my_env");
end

initial begin
    uvm_config_db#(virtual my_if)::set(null, "uvm_test_top.i_agt.drv", "vif", input_if); //输入接口传递给driver 
    uvm_config_db#(virtual my_if)::set(null, "uvm_test_top.i_agt.i_mon", "vif", input_if); //输入接口传递给输入monitor 
    uvm_config_db#(virtual my_if)::set(null, "uvm_test_top.o_agt.o_mon", "vif", output_if); //输出接口传递给输出monitor 
end

always @(posedge clk) begin 
    if(ebreak == 1) begin 
        $display("=====EBREAK=====\nEnvironment Break\n");
        $finish;
    end 
end 

/* Write instructions to instructions memory */
/*always @(posedge clk) begin
    if(!insn_mem_wen) begin 
        insn_mem_waddr <= -1;
    end
    else begin 
        insn <= insn_reg[insn_mem_waddr];
        insn_mem_waddr <= insn_mem_waddr + 1;
    end 
end*/ 

assign output_if.reg_if = i_cpu_soc.i_cpu.i_registers.regfile;

cpu_soc i_cpu_soc(
    .clk_i(clk),
    .rstn_i(rstn),
    .insn_mem_wen_i(input_if.mem_wen_if),
    .insn_mem_waddr_i(input_if.mem_waddr_if),
    .insn_i(input_if.insn_if),
    .ebreak_o(ebreak)
);

endmodule

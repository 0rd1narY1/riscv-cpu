`ifndef MY_IF__SV
`define MY_IF__SV

interface my_if(
    input clk,
    input rstn
);
  logic [3:0]mem_wen_if;
  logic [11:0]mem_waddr_if;
  logic [31:0]insn_if;
  logic [31:0]reg_if[31:1];
endinterface
`endif

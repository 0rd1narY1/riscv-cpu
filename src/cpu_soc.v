//`timescale 1ns/1ps

module cpu_soc(
    input clk_i,
    input rstn_i,
    input [3:0]insn_mem_wen_i,      //Instructions memory write enable
    input [11:0]insn_mem_waddr_i,   //Instructions memory write address
    input [31:0]insn_i,             //Instructions read from text
    output ebreak_o                 //Ebreak signal
);

    /* Ports */ 
    wire [31:0]pc;
    wire [31:0]insn;
    wire [31:0]data_to_cpu, data_from_cpu;
    wire [3:0]data_mem_wr_ctrl;
    wire [11:0]data_addr;
    wire ebreak;

    /* CPU Core */
    cpu i_cpu(
        .clk_i(clk_i),
        .rstn_i(rstn_i),
        .insn_i(insn),
        .data_i(data_to_cpu),
        .pc_o(pc),
        .data_o(data_from_cpu),
        .mem_wr_o(data_mem_wr_ctrl),
        .data_addr_o(data_addr),
        .ebreak_o(ebreak)
    );

    assign ebreak_o = ebreak;
    
    /* Instructions Memory */
    memory #(.ADDR_WIDTH(12), .DATA_WIDTH(32))
        i_insn_mem(
            .clk_i(clk_i),
            .rw_ctrl_i(insn_mem_wen_i),
            .waddr_i(insn_mem_waddr_i),
            .raddr_i(pc[13:2]),
            .wdata_i(insn_i),
            .data_o(insn)
        );

    /* Data Memory */
    memory #(.ADDR_WIDTH(12), .DATA_WIDTH(32))
        i_data_mem(
            .clk_i(clk_i),
            .rw_ctrl_i(data_mem_wr_ctrl),
            .waddr_i(data_addr),
            .raddr_i(data_addr),
            .wdata_i(data_from_cpu),
            .data_o(data_to_cpu)
        );

endmodule

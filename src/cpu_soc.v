//`timescale 1ns/1ps

module cpu_soc(
    input clk_i,
    input rstn_i,
    input insn_mem_wen_i,           //Instructions memory write enable
    input [11:0]insn_mem_waddr_i,   //Instructions memory write address
    input [31:0]insn_i,             //Instructions read from text
    output ebreak_o                 //Ebreak signal
);

    /* Ports */ 
    wire [31:0]pc;
    wire [31:0]insn;
    wire [31:0]data_to_cpu, data_from_cpu;
    wire data_mem_wr_ctrl;
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
            .we_i(insn_mem_wen_i),
            .rw_i(insn_mem_waddr_i),
            .ra_i(pc[13:2]),
            .rb_i(/*Unused*/),
            .wdata_i(insn_i),
            .data_a_o(insn),
            .data_b_o(/*Unused*/)
        );

    /* Data Memory */
    memory #(.ADDR_WIDTH(12), .DATA_WIDTH(32))
        i_data_mem(
            .clk_i(clk_i),
            .we_i(data_mem_wr_ctrl),
            .rw_i(data_addr),
            .ra_i(data_addr),
            .rb_i(/*Unused*/),
            .wdata_i(data_from_cpu),
            .data_a_o(data_to_cpu),
            .data_b_o(/*Unused*/)
        );

endmodule

//`timescale 1ns/1ps

module cpu(
    input clk_i,
    input rstn_i,
    //ifu interfaces
    input [31:0]insn_i,         //Instructions from instructions memory
    output [31:0]pc_o,
    //lsu interfaces
    input [31:0]data_i,         //Data from data memory
    output [31:0]data_o,        //Data to be written into data memory
    output mem_wr_o,            //Data memory read/write control
    output [1:0]rwtype_o,        //Write data width type(4 bytes, 2 bytes, 1 bytes)
    output [11:0]data_addr_o,   //Data memory read/write address
    //other interface
    output ebreak_o             //Ebreak signal
);

    /* Instructions Fetch ports */
    wire [31:0]pc;
    wire [31:0]insn;
    /* Decoder ports */
    wire [6:0]opcode;
    wire [2:0]funct3;
    wire [6:0]funct7;
    wire [4:0]rd;
    wire [4:0]rs1;
    wire [4:0]rs2;
    wire [31:0]imm;
    /* Control Unit ports */
    wire branch;            //Branch signal
    wire jump;              //Jump signal
    wire jumpr;             //JumpR signal
    wire alu_a_src;         //Select ALU operator A 
    wire [1:0]alu_b_src;    //Select ALU operator B 
    wire [3:0]alu_ctr;      //ALU control signal 
    wire mem_to_reg;        //Select Data memory output to register set 
    wire reg_wr;            //Register set read/write control 
    wire [3:0]mem_wr;       //Data memory read/write control 
    wire [2:0]ext_op;       //Immediate number extender control 
    wire ebreak;            //Ebreak signal
    /* Register Set ports */
    wire [31:0]rs1_data, rs2_data;
    /* ALU ports */
    wire zero;
    wire [31:0]alu_out;
    /*LSU ports*/
    wire mem_wr_ctrl;       //Direct r/w control to data memory
    wire [11:0]mem_data_addr;
    wire [31:0]data_to_mem; //Data to be stored into memory
    wire [31:0]data_mem_to_reg; //Memory data to be loaded into registers
    /*Internal Buses*/
    wire ifu_valid;
    wire idu_valid, idu_ready;
    wire exu_ready;

    /* Instructions Fetch*/ 
    ifu i_ifu(
        .clk_i(clk_i),
        .rstn_i(rstn_i),
        .imm_i(imm),
        .rs1_data_i(rs1_data),
        .jump_i(jump),
        .jumpr_i(jumpr),
        .branch_i(branch),
        .zero_i(zero),
        .ALUctr_i(alu_ctr),
        .insn_i(insn_i),
        .pc_o(pc),
        .funct3_i(funct3),
        .idu_ready_i(idu_ready),
        .ifu_valid_o(ifu_valid),
        .insn_o(insn)
    );

    assign pc_o = pc;
    assign exu_ready = 1;
    /* Decoder */
    decoder i_decoder(
        .clk_i(clk_i),
        .rstn_i(rstn_i),
        .insn_i(insn),
        .ifu_valid_i(ifu_valid),
        .idu_ready_o(idu_ready),
        .exu_ready_i(exu_ready),
        .idu_valid_o(idu_valid),
        .ext_op_i(ext_op),
        .opcode_o(opcode),
        .funct3_o(funct3),
        .funct7_o(funct7),
        .rd_o(rd),
        .rs1_o(rs1),
        .rs2_o(rs2),
        .imm_o(imm)
    );

    /* Control Unit */
    ctrlu i_ctrlu(
        .opcode_i(opcode),
        .funct3_i(funct3),
        .funct7_i(funct7),
        .branch_o(branch),
        .jump_o(jump),
        .jumpr_o(jumpr),
        .alu_a_src_o(alu_a_src),
        .alu_b_src_o(alu_b_src),
        .alu_ctr_o(alu_ctr),
        .mem_to_reg_o(mem_to_reg),
        .reg_wr_o(reg_wr),
        .mem_wr_o(mem_wr),
        .ext_op_o(ext_op),
        .ebreak_o(ebreak)
    );

    assign ebreak_o = ebreak;

    /* Register Set */
    wire [31:0]registers_wdata; //Data to be written in, which is selected between alu result and data memory

    regfile #(.ADDR_WIDTH(5), .DATA_WIDTH(32))
        i_registers(
            .clk_i(clk_i),
            .rstn_i(rstn_i),
            .we_i(reg_wr),
            .rw_i(rd),
            .ra_i(rs1),
            .rb_i(rs2),
            .wdata_i(registers_wdata),
            .data_a_o(rs1_data),
            .data_b_o(rs2_data)
        );

    assign data_o = rs2_data; //Data to data memory

    /* ALU */
    //Select alu operators 
    wire [31:0]operator_a, operator_b;
    assign operator_a = alu_a_src?pc:rs1_data;
    assign operator_b = alu_b_src[1]?imm:(alu_b_src[0]?32'd4:rs2_data);

    alu i_alu(
       .A(operator_a),
       .B(operator_b),
       .ALUctr(alu_ctr),
       .Zero(zero),
       .ALUOut(alu_out)
    );
    

    /*LSU*/
    lsu i_lsu(
        .rw_ctrl_i(mem_wr),
        .alu_addr_i(alu_out),
        .data_i(data_i),
        .mem_wr_o(mem_wr_ctrl),
        .rwtype_o(rwtype_o),
        .data_addr_o(mem_data_addr),
        .data_o(data_o),
        .data_reg_to_mem_i(rs2_data),
        .data_mem_to_reg_o(data_mem_to_reg)
    );
    assign registers_wdata = mem_to_reg?data_mem_to_reg:alu_out;  //Select data to be written to register 
    //assign data_o = data_to_mem;         //Data to be written into data memory
    assign mem_wr_o = mem_wr_ctrl;       //Data memory read/write control
    assign data_addr_o = mem_data_addr;  //Data memory read/write address

endmodule

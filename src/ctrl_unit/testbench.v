`timescale 1ns/1ps

module testbench;

    reg [6:0]opcode;
    reg [2:0]funct3;
    wire branch, jump, alu_a_src, mem_to_reg, reg_wr, mem_wr;
    wire [1:0]alu_b_src;
    wire [3:0]alu_ctr;
    wire [2:0]ext_op;
    
    initial begin 
        opcode = 7'b0; funct3 = 3'b0;
        #10 opcode = 7'b0110011; 
        #10 funct3 = 3'b010;
        #10 funct3 = 3'b011;
        #10 opcode = 7'b0010011; funct3 = 3'b0;
        #10 funct3 = 3'b110;
        #10 opcode = 7'b0110111;
        #10 opcode = 7'b0000011; funct3 = 3'b010;
        #10 opcode = 7'b0100011; funct3 = 3'b010;
        #10 opcode = 7'b1100011; funct3 = 3'b0;
        #10 opcode = 7'b1101111;
        #20 $finish;
    end 

    ctrlu i_ctrlu(
        .opcode_i(opcode),
        .funct3_i(funct3),
        .branch_o(branch),
        .jump_o(jump),
        .alu_a_src_o(alu_a_src),
        .alu_b_src_o(alu_b_src),
        .alu_ctr_o(alu_ctr),
        .mem_to_reg_o(mem_to_reg),
        .reg_wr_o(reg_wr),
        .mem_wr_o(mem_wr),
        .ext_op_o(ext_op)
    );

endmodule

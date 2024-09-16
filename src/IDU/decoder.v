//`timescale 1ns/1ps

module decoder(
    input [31:0]insn_i,
    input [2:0]ext_op_i,    //Select immediate number extended
    output [6:0]opcode_o,
    output [2:0]funct3_o,
    output [6:0]funct7_o,
    output [4:0]rd_o,
    output [4:0]rs1_o,
    output [4:0]rs2_o,
    output reg [31:0]imm_o
);

    wire [31:0]immI, immU, immS, immB, immJ;
    
    assign opcode_o = insn_i[6:0];
    assign funct3_o = insn_i[14:12];
    assign funct7_o = insn_i[31:25];
    assign rd_o = insn_i[11:7];
    assign rs1_o = insn_i[19:15];
    assign rs2_o = insn_i[24:20];
    assign immI = {{20{insn_i[31]}}, insn_i[31:20]};
    assign immU = {insn_i[31:12], 12'b0};
    assign immS = {{20{insn_i[31]}}, insn_i[31:25], insn_i[11:7]};
    assign immB = {{20{insn_i[31]}}, insn_i[7], insn_i[30:25], insn_i[11:8], 1'b0};
    assign immJ = {{12{insn_i[31]}}, insn_i[19:12], insn_i[20], insn_i[30:21], 1'b0};

    /* Select immediate number by ext_op_i */
    always @* begin 
        case(ext_op_i)
            3'b000:     imm_o = immI;
            3'b001:     imm_o = immU;
            3'b010:     imm_o = immS;
            3'b011:     imm_o = immB;
            3'b100:     imm_o = immJ;
            default:    imm_o = 32'bx;
        endcase
    end 

endmodule

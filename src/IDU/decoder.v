//`timescale 1ns/1ps

module decoder(
    input clk_i,
    input rstn_i,
    //Interfaces with IFU
    input [31:0]insn_i,     //Instructions from the IFU
    input ifu_valid_i,      //ifu valid signal
    output reg idu_ready_o, //idu responses ready signal
    //Interfaces with EXU(ALU)
    input exu_ready_i,      //exu responses ready signal
    output reg idu_valid_o,     //idu valid signal
    //Control signal interfaces
    input [2:0]ext_op_i,    //Select immediate number extended
    //Decode outputs
    output reg [6:0]opcode_o,
    output reg [2:0]funct3_o,
    output reg [6:0]funct7_o,
    output reg [4:0]rd_o,
    output reg [4:0]rs1_o,
    output reg [4:0]rs2_o,
    output reg [31:0]imm_o
);
    reg state_d, state_q;

    /*Decoder*/
    reg [31:0]imm_d, immI, immU, immS, immB, immJ;
    reg [6:0]opcode_d, funct7_d;
    reg [2:0]funct3_d;
    reg [4:0]rd_d, rs1_d, rs2_d;

    always @* begin 
        opcode_d = opcode_o;
        funct3_d = funct3_o;
        funct7_d = funct7_o;
        rd_d     =     rd_o;
        rs1_d    =    rs1_o;
        rs2_d    =    rs2_o;
        imm_d    =    imm_o;
        if(ifu_valid_i && idu_ready_o)begin 
            opcode_d = insn_i[6:0];
            funct3_d = insn_i[14:12];
            funct7_d = insn_i[31:25];
            rd_d = insn_i[11:7];
            rs1_d = insn_i[19:15];
            rs2_d = insn_i[24:20];
            immI = {{20{insn_i[31]}}, insn_i[31:20]};
            immU = {insn_i[31:12], 12'b0};
            immS = {{20{insn_i[31]}}, insn_i[31:25], insn_i[11:7]};
            immB = {{20{insn_i[31]}}, insn_i[7], insn_i[30:25], insn_i[11:8], 1'b0};
            immJ = {{12{insn_i[31]}}, insn_i[19:12], insn_i[20], insn_i[30:21], 1'b0};
            case(ext_op_i)
                3'b000:     imm_d = immI;
                3'b001:     imm_d = immU;
                3'b010:     imm_d = immS;
                3'b011:     imm_d = immB;
                3'b100:     imm_d = immJ;
                default:    imm_d = 32'bx;
            endcase
        end
    end

    /*IFU-IDU Bus*/ 
    always @* begin 
        idu_ready_o = 0;
        idu_valid_o = 0; 
        if(ifu_valid_i) begin 
            idu_ready_o = 1;
            idu_valid_o = 1;
        end 
    end 

    always @(posedge clk_i) begin 
        if(!rstn_i) begin 
            opcode_o <= 'b0;
            funct3_o <= 'b0;
            funct7_o <= 'b0;
            rd_o     <= 'b0;
            rs1_o    <= 'b0;
            rs2_o    <= 'b0;
            imm_o    <= 'b0;
        end 
        else begin 
            opcode_o <= 'b0;
            funct3_o <= 'b0;
            funct7_o <= 'b0;
            rd_o     <= 'b0;
            rs1_o    <= 'b0;
            rs2_o    <= 'b0;
            imm_o    <= 'b0;
            if(idu_valid_o && exu_ready_i) begin 
                opcode_o <= opcode_d;
                funct3_o <= funct3_d;
                funct7_o <= funct7_d;
                rd_o     <=     rd_d;
                rs1_o    <=    rs1_d;
                rs2_o    <=    rs2_d;
                imm_o    <=    imm_d;
            end 
        end 
    end 

endmodule

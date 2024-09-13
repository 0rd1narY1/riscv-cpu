//`timescale 1ns/1ps

module ctrlu(
    input [6:0]opcode_i,        //Instruction opcode
    input [2:0]funct3_i,        //Instruction funct3
    input [6:0]funct7_i,        //Instruction funct7
    output branch_o,            //Branch signal
    output jump_o,              //Jump signal
    output jumpr_o,             //JumpR signal
    output alu_a_src_o,         //Select ALU operator A 
    output [1:0]alu_b_src_o,    //Select ALU operator B 
    output [3:0]alu_ctr_o,      //ALU control signal 
    output mem_to_reg_o,        //Select Data memory output to register set 
    output reg_wr_o,            //Register set read/write control 
    output mem_wr_o,            //Data memory read/write control 
    output [2:0]ext_op_o,       //Immediate number extender control 
    output ebreak_o             //Ebreak signal
);

    reg [16:0]ctrl_signal;
    assign {branch_o, jump_o, jumpr_o, alu_a_src_o, alu_b_src_o[1:0], alu_ctr_o[3:0], mem_to_reg_o, reg_wr_o, mem_wr_o, ext_op_o[2:0], ebreak_o} = ctrl_signal;

    always @* begin 
        case(opcode_i)
            7'b0110011: begin //R-Type
                            case(funct3_i)
                                3'b000: begin 
                                            if(funct7_i == 7'b0)
                                                ctrl_signal = 17'b0000000000010xxx0; //add
                                            else if(funct7_i == 7'b0100000)
                                                ctrl_signal = 17'b0000001000010xxx0; //sub
                                        end 
                                3'b001:     ctrl_signal = 17'b0000001001010xxx0; //sll
                                3'b010:     ctrl_signal = 17'b0000000010010xxx0; //slt
                                3'b011:     ctrl_signal = 17'b0000000011010xxx0; //sltu
                                3'b100:     ctrl_signal = 17'b0000000111010xxx0; //xor
                                3'b101: begin 
                                            if(funct7_i == 7'b0)
                                                ctrl_signal = 17'b0000001010010xxx0; //srl
                                            else if(funct7_i == 7'b0100000)
                                                ctrl_signal = 17'b0000001011010xxx0; //sra
                                        end 
                                3'b110:     ctrl_signal = 17'b0000000110010xxx0; //or
                                3'b111:     ctrl_signal = 17'b0000000001010xxx0; //and
                                default:    ctrl_signal = 17'b0;
                            endcase
                        end
            7'b0010011: begin //I-Type
                            case(funct3_i)
                                3'b000:     ctrl_signal = 17'b00001000000100000; //addi
                                3'b001:     ctrl_signal = 17'b00001010010100000; //slli
                                3'b010:     ctrl_signal = 17'b00001000100100000; //slti

                                3'b011:     ctrl_signal = 17'b00001000110100000; //sltiu
                                3'b100:     ctrl_signal = 17'b00001001110100000; //xori
                                3'b101: begin 
                                            if(funct7_i == 7'b0)
                                                ctrl_signal = 17'b00001010100100000; //srli
                                            else if(funct7_i == 7'b0100000)
                                                ctrl_signal = 17'b00001010110100000; //srai
                                        end 
                                3'b110:     ctrl_signal = 17'b00001001100100000; //ori
                                3'b111:     ctrl_signal = 17'b00001000010100000; //andi
                                default:    ctrl_signal = 17'b0;
                            endcase
                        end 
            7'b0110111:         ctrl_signal = 17'b000x1011110100010; //lui
            7'b0010111:         ctrl_signal = 17'b00011000000100010; //auipc
            7'b0000011: begin
                            case(funct3_i)
                                3'b010:     ctrl_signal = 17'b00001000001100000; //lw
                                default:    ctrl_signal = 17'b0;
                            endcase
                        end
            7'b0100011: begin
                            case(funct3_i)
                                3'b010:     ctrl_signal = 17'b0000100000x010100; //sw
                                default:    ctrl_signal = 17'b0;
                            endcase
                        end
            7'b1100011: begin //B-Type
                            case(funct3_i)
                                3'b000,3'b001:     ctrl_signal = 17'b1000001000x000110; //beq,bne
                                3'b100,3'b101:     ctrl_signal = 17'b1000000010x000110; //blt,bge
                                3'b110,3'b111:     ctrl_signal = 17'b1000000011x000110; //bltu,bgeu
                                default:    ctrl_signal = 17'b0;
                            endcase
                        end
            7'b1101111:         ctrl_signal = 17'b01010100000101000; //jal
            7'b1100111:         ctrl_signal = 17'b00110100000100000; //jalr TODO:To be tested
            7'b1110011:         ctrl_signal = 17'bxxxxxxxxxxxxxxxx1; //ebreak
            default:            ctrl_signal = 17'b0;
        endcase
    end 

endmodule

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
    output [3:0]mem_wr_o,       //Data memory read/write control 
    output [2:0]ext_op_o,       //Immediate number extender control 
    output ebreak_o             //Ebreak signal
);

    reg [19:0]ctrl_signal;
    assign {branch_o, jump_o, jumpr_o, alu_a_src_o, alu_b_src_o[1:0], alu_ctr_o[3:0], mem_to_reg_o, reg_wr_o, mem_wr_o[3:0], ext_op_o[2:0], ebreak_o} = ctrl_signal;

    always @* begin 
        //Maintain default value
        ctrl_signal = 20'b0;
        case(opcode_i)
            7'b0110011: begin //R-Type
                            case(funct3_i)
                                3'b000: begin 
                                            if(funct7_i == 7'b0)
                                                ctrl_signal = 20'b0000000000010000xxx0; //add
                                            else if(funct7_i == 7'b0100000)
                                                ctrl_signal = 20'b0000001000010000xxx0; //sub
                                        end 
                                3'b001:     ctrl_signal = 20'b0000001001010000xxx0; //sll
                                3'b010:     ctrl_signal = 20'b0000000010010000xxx0; //slt
                                3'b011:     ctrl_signal = 20'b0000000011010000xxx0; //sltu
                                3'b100:     ctrl_signal = 20'b0000000111010000xxx0; //xor
                                3'b101: begin 
                                            if(funct7_i == 7'b0)
                                                ctrl_signal = 20'b0000001010010000xxx0; //srl
                                            else if(funct7_i == 7'b0100000)
                                                ctrl_signal = 20'b0000001011010000xxx0; //sra
                                        end 
                                3'b110:     ctrl_signal = 20'b0000000110010000xxx0; //or
                                3'b111:     ctrl_signal = 20'b0000000001010000xxx0; //and
                                default:    ctrl_signal = 20'b0;
                            endcase
                        end
            7'b0010011: begin //I-Type
                            case(funct3_i)
                                3'b000:     ctrl_signal = 20'b00001000000100000000; //addi
                                3'b001:     ctrl_signal = 20'b00001010010100000000; //slli
                                3'b010:     ctrl_signal = 20'b00001000100100000000; //slti

                                3'b011:     ctrl_signal = 20'b00001000110100000000; //sltiu
                                3'b100:     ctrl_signal = 20'b00001001110100000000; //xori
                                3'b101: begin 
                                            if(funct7_i == 7'b0)
                                                ctrl_signal = 20'b00001010100100000000; //srli
                                            else if(funct7_i == 7'b0100000)
                                                ctrl_signal = 20'b00001010110100000000; //srai
                                        end 
                                3'b110:     ctrl_signal = 20'b00001001100100000000; //ori
                                3'b111:     ctrl_signal = 20'b00001000010100000000; //andi
                                default:    ctrl_signal = 20'b0;
                            endcase
                        end 
            7'b0110111:         ctrl_signal = 20'b000x1011110100000010; //lui
            7'b0010111:         ctrl_signal = 20'b00011000000100000010; //auipc
            7'b0000011: begin
                            case(funct3_i)
                                3'b000:     ctrl_signal = 20'b00001000001100000000; //lb 
                                3'b001:     ctrl_signal = 20'b00001000001100010000; //lh
                                3'b010:     ctrl_signal = 20'b00001000001100100000; //lw
                                3'b100:     ctrl_signal = 20'b00001000001100110000; //lbu
                                3'b101:     ctrl_signal = 20'b00001000001101000000; //lhu
                                default:    ctrl_signal = 20'b0;
                            endcase
                        end
            7'b0100011: begin
                            case(funct3_i)
                                3'b000:     ctrl_signal = 20'b0000100000x010000100; //sb
                                3'b001:     ctrl_signal = 20'b0000100000x010010100; //sh
                                3'b010:     ctrl_signal = 20'b0000100000x010100100; //sw
                                default:    ctrl_signal = 20'b0;
                            endcase
                        end
            7'b1100011: begin //B-Type
                            case(funct3_i)
                                3'b000,3'b001:     ctrl_signal = 20'b1000001000x000000110; //beq,bne
                                3'b100,3'b101:     ctrl_signal = 20'b1000000010x000000110; //blt,bge
                                3'b110,3'b111:     ctrl_signal = 20'b1000000011x000000110; //bltu,bgeu
                                default:    ctrl_signal = 20'b0;
                            endcase
                        end
            7'b1101111:         ctrl_signal = 20'b01010100000100001000; //jal
            7'b1100111:         ctrl_signal = 20'b00110100000100000000; //jalr
            7'b1110011:         ctrl_signal = 20'bxxxxxxxxxxxxxxxxxxx1; //ebreak
            default:            ctrl_signal = 20'b0;
        endcase
    end 

endmodule

class my_model extends uvm_component;
    uvm_blocking_get_port #(my_insn_transaction) port; //接收输入agent发送的transaction的端口
    uvm_analysis_port #(my_reg_transaction) ap; //向scoreboard发送transaction的端口


    `uvm_component_utils(my_model);

    function new(string name = "my_model", uvm_component parent);
        super.new(name, parent);
    endfunction

    extern function void build_phase(uvm_phase phase);
    extern virtual task main_phase(uvm_phase phase);    

endclass

function void my_model::build_phase(uvm_phase phase);
    super.build_phase(phase);
    port = new("port",this);
    ap = new("ap",this);
endfunction

task my_model::main_phase(uvm_phase phase);
    my_insn_transaction insn_tr;
    my_reg_transaction reg_tr;

    bit [31:0]regfile[31:0]; //Model's registers
    logic [31:0]insn, pc;
    logic [6:0]opcode;
    logic [6:0]funct7;
    logic [2:0]funct3;
    logic [4:0]rd, rs1, rs2;
    logic [31:0]imm, rd_data, rs1_data, rs2_data, alu_a, alu_b, alu_out;
    logic [15:0]ctrl_signal;
    logic branch, jump, jumpr, alu_a_src, mem_to_reg, reg_wr, mem_wr;
    logic [1:0]alu_b_src;
    logic [3:0]alu_ctr;
    logic [2:0]ext_op;
    logic ebreak;
    int i=0;

    super.main_phase(phase);
    while (1) begin
        `uvm_info("my_model", "Generate EXPECTED Values", UVM_LOW)
        port.get(insn_tr); //输入指令
        $display("model insn");
        insn_tr.print();
        reg_tr = new("reg_tr"); //输出寄存器数据
        /*IFU*/ 
        insn = insn_tr.insn_reg[pc/4];
        pc += 4;
        `uvm_info("my_model", "Decoder", UVM_LOW)
        /*Decoder*/
        opcode = insn[6:0];
        funct3 = insn[14:12];
        funct7 = insn[31:25];
        rd = insn[11:7];
        rs1 = insn[19:15];
        rs2 = insn[24:20];
        case (ext_op)
            3'b000:     imm = {{20{insn[31]}}, insn[31:20]};
            3'b001:     imm = {insn[31:12], 12'b0};
            3'b010:     imm = {{20{insn[31]}}, insn[31:25], insn[11:7]};
            3'b011:     imm = {{20{insn[31]}}, insn[7], insn[30:25], insn[11:8], 1'b0};
            3'b100:     imm = {{12{insn[31]}}, insn[19:12], insn[20], insn[30:21], 1'b0};
            default:    imm = 32'bx; 
        endcase
        /*Control Unit*/ 
        case(opcode)
            7'b0110011: begin //R-Type
                            case(funct3)
                                3'b000: begin 
                                            if(funct7 == 7'b0)
                                                ctrl_signal = 17'b0000000000010xxx0; //add
                                            else if(funct7 == 7'b0100000)
                                                ctrl_signal = 17'b0000001000010xxx0; //sub
                                        end 
                                3'b001:     ctrl_signal = 17'b0000001001010xxx0; //sll
                                3'b010:     ctrl_signal = 17'b0000000010010xxx0; //slt
                                3'b011:     ctrl_signal = 17'b0000000011010xxx0; //sltu
                                3'b100:     ctrl_signal = 17'b0000000111010xxx0; //xor
                                3'b101: begin 
                                            if(funct7 == 7'b0)
                                                ctrl_signal = 17'b0000001010010xxx0; //srl
                                            else if(funct7 == 7'b0100000)
                                                ctrl_signal = 17'b0000001011010xxx0; //sra
                                        end 
                                3'b110:     ctrl_signal = 17'b0000000110010xxx0; //or
                                3'b111:     ctrl_signal = 17'b0000000001010xxx0; //and
                                default:    ctrl_signal = 17'b0;
                            endcase
                        end
            7'b0010011: begin //I-Type
                            case(funct3)
                                3'b000:     ctrl_signal = 17'b00001000000100000; //addi
                                3'b001:     ctrl_signal = 17'b00001010010100000; //slli
                                3'b010:     ctrl_signal = 17'b00001000100100000; //slti

                                3'b011:     ctrl_signal = 17'b00001000110100000; //sltiu
                                3'b100:     ctrl_signal = 17'b00001001110100000; //xori
                                3'b101: begin 
                                            if(funct7 == 7'b0)
                                                ctrl_signal = 17'b00001010100100000; //srli
                                            else if(funct7 == 7'b0100000)
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
                            case(funct3)
                                3'b010:     ctrl_signal = 17'b00001000001100000; //lw
                                default:    ctrl_signal = 17'b0;
                            endcase
                        end
            7'b0100011: begin
                            case(funct3)
                                3'b010:     ctrl_signal = 17'b0000100000x010100; //sw
                                default:    ctrl_signal = 17'b0;
                            endcase
                        end
            7'b1100011: begin //B-Type
                            case(funct3)
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
        {branch, jump, jumpr, alu_a_src, alu_b_src[1:0], alu_ctr[3:0], mem_to_reg, reg_wr, mem_wr, ext_op[2:0], ebreak} = ctrl_signal;
                
        `uvm_info("my_model", "ALU", UVM_LOW)
        /*ALU*/ 
        case(alu_ctr)
            4'b0000: alu_out = alu_a + alu_b;
            4'b0001: alu_out = alu_a & alu_b;
            4'b0010: alu_out = ($signed(alu_a) < $signed(alu_b)) ? 1 : 0;
            4'b0011: alu_out = (alu_a < alu_b) ? 1 : 0;
            4'b0110: alu_out = alu_a | alu_b;
            4'b0111: alu_out = alu_a ^ alu_b;
            4'b1000: alu_out = alu_a - alu_b;
            4'b1001: alu_out = alu_a << alu_b[4:0];
            4'b1010: alu_out = alu_a >> alu_b[4:0];
            4'b1011: alu_out = $signed(alu_a) >>> alu_b[4:0];
            4'b1111: alu_out = alu_b;
            default: alu_out = 'b0;
        endcase
            
        /*Regfile*/
        rs1_data = regfile[rs1];
        rs2_data = regfile[rs2];
        if(reg_wr)
            regfile[rd] = alu_out;
            
        regfile[11] = 32'h00002000 + i ;
        i++;
        reg_tr.cpu_reg = regfile[31:1];
        ap.write(reg_tr);
        `uvm_info("my_model", "Send EXPECTED Values to Scoreboard", UVM_LOW)
    end
endtask

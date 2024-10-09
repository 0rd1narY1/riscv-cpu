//`timescale 1ns/1ps

module ifu(
    input clk_i,
    input rstn_i,
    //Jump and branch value interfaces
    input [31:0]imm_i,          //Immediate number from the imm_extender
    input [31:0]rs1_data_i,     //RS1 data from the regfile
    //Control signal interfaces
    input jump_i,               //Jump signal from the ctrl_unit
    input jumpr_i,              //JumpR signal from the ctrl_unit
    input branch_i,             //Branch signal from the ctrl_unit 
    input zero_i,               //Zero output from the alu
    input [3:0]ALUctr_i,        //ALUctr signal from the ctrl_unit 
    //Interfaces with instruction memory
    input [31:0]insn_i,         //
    output reg [31:0]pc_o,      //Current PC to fetch the new instruction in the instruction memory
    //Interfaces with IDU
    input [2:0]funct3_i,        //funct3 signal from the decoder
    input idu_ready_i,        //idu responses ready signal
    output reg ifu_valid_o,       //ifu sends valid signal
    output [31:0]insn_o         //Pass instructions to idu
);
    parameter BASE_ADDR = 32'h00000000;
    parameter IDLE = 0, WAIT_READY = 1;
    reg state_d, state_q;
    reg [31:0]insn_d, insn_q;
    
    /* PC increment */
    //Assume pc + 4 or pc + imm 
    wire [31:0]pc_increment;
    //Use ALUctr_i to determine branch type(beq,bne,blt,bge,bltu,bgeu)
    reg branch_condition;
    assign pc_increment = ((branch_i & branch_condition) | jump_i | jumpr_i)?imm_i:32'd4;
    always @* begin 
        branch_condition = 0; //Default
        case(ALUctr_i)
            4'b1000:begin 
                        if(funct3_i == 3'b000) //beq
                            branch_condition = zero_i;
                        else if(funct3_i == 3'b001) //bne
                            branch_condition = ~zero_i; 
                    end
            4'b0010:begin 
                        if(funct3_i == 3'b100) //blt
                            branch_condition = ~zero_i;
                        else if(funct3_i == 3'b101) //bge
                            branch_condition = zero_i;
                    end 
            4'b0011:begin 
                        if(funct3_i == 3'b110) //bltu
                            branch_condition = ~zero_i;
                        else if(funct3_i == 3'b111) //bgeu
                            branch_condition = zero_i;
                    end 
            default:        branch_condition = 0;
        endcase
    end 
    
    /* Get the next PC */
    reg [31:0]next_pc;
    reg issue_insn; //There is a new instruction to be issue
    always @* begin 
        if(~jumpr_i)
            next_pc = pc_o + pc_increment;
        else begin //jalr needs to set the lsb to 0 
            next_pc = rs1_data_i + pc_increment;
            next_pc = {next_pc[31:1],1'b0};
        end 
        if(state_q == WAIT_READY && !idu_ready_i) begin //WAIT_READY且未完成握手,不更新指令
            next_pc = pc_o;
        end
        //If there is a new instruction, then set issue_insn = 1;
        issue_insn = 0;
        if(pc_o == BASE_ADDR || pc_o != next_pc)
            issue_insn = 1;
    end 
    
    /* Update PC */
    always @(posedge clk_i) begin 
        if(!rstn_i) begin 
            pc_o <= BASE_ADDR;
        end 
        else begin 
            pc_o <= next_pc;
        end 
    end 

   /*IFU-IDU Bus*/
   //Define next state and handshake signal
   always @* begin 
       insn_d = insn_i;
       case(state_q)
           IDLE:    begin 
                        ifu_valid_o = issue_insn; //0 or 1
                        if(!issue_insn) begin 
                            state_d = IDLE;
                        end 
                        else begin 
                            state_d = WAIT_READY;
                        end 
                    end 
           WAIT_READY: begin 
                            if(!idu_ready_i) begin 
                                state_d = WAIT_READY;
                                insn_d = insn_q;
                            end
                            else begin 
                                state_d = IDLE;
                                insn_d = insn_i;
                            end 
                       end
           default: begin    state_d = IDLE; insn_d = insn_q; end
       endcase
   end 
    
   /*Update state*/ 
   assign insn_o = insn_q;
   always @(posedge clk_i) begin 
       if(!rstn_i) begin 
           state_q <= IDLE;
           insn_q  <= 'b0;
       end 
       else begin 
           state_q <= state_d;
           insn_q  <= insn_d;
       end 
   end 

endmodule

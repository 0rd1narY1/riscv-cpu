//`timescale 1ns/1ps

module ifu(
    input clk_i,
    input rstn_i,
    input [31:0]imm_i,          //Immediate number from the imm_extender
    input [31:0]rs1_data_i,     //RS1 data from the regfile
    input jump_i,               //Jump signal from the ctrl_unit
    input jumpr_i,              //JumpR signal from the ctrl_unit
    input branch_i,             //Branch signal from the ctrl_unit 
    input zero_i,               //Zero output from the alu
    input [3:0]ALUctr_i,        //ALUctr signal from the ctrl_unit 
    input [2:0]funct3_i,        //funct3 signal from the decoder
    output reg [31:0]pc_o       //Current PC to fetch the new instruction in the instruction memory
);

    /* PC increment */
    //Assume pc + 4 or pc + imm 
    wire [31:0]pc_increment;
    //Use ALUctr_i to determine branch type(beq,bne,blt,bge,bltu,bgeu)
    reg branch_condition;
    assign pc_increment = ((branch_i & branch_condition) | jump_i | jumpr_i)?imm_i:32'd4;
    always @* begin 
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
    always @* begin 
        if(~jumpr_i)
            next_pc = pc_o + pc_increment;
        else begin //jalr needs to set the lsb to 0 
            next_pc = rs1_data_i + pc_increment;
            next_pc = {next_pc[31:1],1'b0};
        end 
    end 
    /* Update PC */
    always @(posedge clk_i) begin 
        if(!rstn_i) 
            pc_o <= 32'h00000000;
        else 
            pc_o <= next_pc;
    end 

endmodule

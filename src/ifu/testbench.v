`timescale 1ns/1ps

module testbench;
    reg clk, rstn, jump, branch, zero;
    reg [31:0]imm;
    wire [31:0]pc;

    initial begin 
        clk = 0; rstn = 1; jump = 0; branch = 0; zero = 0;
        #10 rstn = 0;
        #10 rstn = 1;
        #10 jump = 0; branch = 0; zero = 0; imm = 32'h0;
        #50 jump = 1; imm = 32'b00001000;
        #10 jump = 0;
        #50 branch = 1; zero = 1; imm = 32'h0000000a;
        #10 branch = 0; zero = 0; imm =32'b0;
        #50 $finish;
    end 

    always #5 clk = ~clk;


    ifu i_ifu(
        .clk_i(clk),
        .rstn_i(rstn),
        .imm_i(imm),
        .jump_i(jump),
        .branch_i(branch),
        .zero_i(zero),
        .pc_o(pc)
    );
endmodule

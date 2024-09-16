//`timescale 1ns/1ps

module memory #(parameter ADDR_WIDTH = 0, DATA_WIDTH = 32)(
	input clk_i,
    input mem_wr_i,
	input [ADDR_WIDTH-1:0]waddr_i,
	input [ADDR_WIDTH-1:0]raddr_i,
	input [DATA_WIDTH-1:0]wdata_i,
	output [DATA_WIDTH-1:0]data_o
);
	reg [DATA_WIDTH-1:0]memory[2**ADDR_WIDTH-1:0];
    reg [DATA_WIDTH-1:0]data_o_q;

	/*Write Data*/
	always @(posedge clk_i) begin
        if(mem_wr_i)
            memory[waddr_i] <= wdata_i;
	end

	/*Read Data*/
    always @* begin 
        if(!mem_wr_i)
            data_o_q = memory[raddr_i];
    end 
	assign data_o = data_o_q;

endmodule

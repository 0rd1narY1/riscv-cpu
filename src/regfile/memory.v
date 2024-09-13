//`timescale 1ns/1ps

module memory #(parameter ADDR_WIDTH = 0, DATA_WIDTH = 32)(
	input clk_i,
	input we_i,
	input [ADDR_WIDTH-1:0]rw_i,
	input [ADDR_WIDTH-1:0]ra_i,
	input [ADDR_WIDTH-1:0]rb_i,
	input [DATA_WIDTH-1:0]wdata_i,
	output [DATA_WIDTH-1:0]data_a_o,
	output [DATA_WIDTH-1:0]data_b_o
);
	reg [DATA_WIDTH-1:0]memory[2**ADDR_WIDTH-1:0];

	/*Write Data*/
	always @(posedge clk_i) begin
		if(we_i)
			memory[rw_i] <= wdata_i;
	end

	/*Read Data*/
	assign data_a_o = memory[ra_i];
	assign data_b_o = memory[rb_i];

endmodule

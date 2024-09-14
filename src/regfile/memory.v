//`timescale 1ns/1ps

module memory #(parameter ADDR_WIDTH = 0, DATA_WIDTH = 32)(
	input clk_i,
	input [3:0]rw_ctrl_i, //[3] is r/w control signal, and [2:0] is r/w type control signal
	input [ADDR_WIDTH-1:0]waddr_i,
	input [ADDR_WIDTH-1:0]raddr_i,
	input [DATA_WIDTH-1:0]wdata_i,
	output [DATA_WIDTH-1:0]data_o
);
	reg [DATA_WIDTH-1:0]memory[2**ADDR_WIDTH-1:0];
    reg [DATA_WIDTH-1:0]data_o_q;

	/*Write Data*/
	always @(posedge clk_i) begin
        if(rw_ctrl_i[3])
		    case(rw_ctrl_i[2:0])
			    3'b000: memory[waddr_i] <= {{24{wdata_i[31]}}, wdata_i[7:0]}; //sb 
                3'b001: memory[waddr_i] <= {{16{wdata_i[31]}}, wdata_i[15:0]}; //sh
                3'b010: memory[waddr_i] <= wdata_i; //sw
                default: memory[waddr_i] <= 32'bx;
            endcase
	end

	/*Read Data*/
    always @* begin 
        if(!rw_ctrl_i[3])
            case(rw_ctrl_i[2:0])
                3'b000: data_o_q = {{24{memory[raddr_i][31]}}, memory[raddr_i][7:0]}; //lb
                3'b001: data_o_q = {{16{memory[raddr_i][31]}}, memory[raddr_i][15:0]}; //lh
                3'b010: data_o_q = memory[raddr_i]; //lw
                3'b011: data_o_q = {24'b0, memory[raddr_i][7:0]}; //lbu
                3'b100: data_o_q = {16'b0, memory[raddr_i][15:0]}; //lhu
                default: data_o_q = 32'bx;
            endcase
    end 
	assign data_o = data_o_q;

endmodule

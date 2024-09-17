//`timescale 1ns/1ps

module memory #(parameter ADDR_WIDTH = 0, DATA_WIDTH = 32)(
	input clk_i,
    input mem_wr_i,
    input [1:0]rwtype_i,
	input [ADDR_WIDTH-1:0]waddr_i,
	input [ADDR_WIDTH-1:0]raddr_i,
	input [DATA_WIDTH-1:0]wdata_i,
	output [DATA_WIDTH-1:0]data_o
);
	reg [DATA_WIDTH-1:0]memory[2**ADDR_WIDTH-1:0];
    reg [DATA_WIDTH-1:0]data_o_q;
    reg [ADDR_WIDTH-1:0]row_waddr;
    reg [ADDR_WIDTH-1:0]row_raddr;
    reg [DATA_WIDTH-1:0]column_waddr;
    reg [DATA_WIDTH-1:0]column_raddr;

    /*Address Mapping*/ 
    always @* begin 
        row_waddr = waddr_i >> 2;
        row_raddr = raddr_i >> 2;
        case(waddr_i % 4) //0: 0 bytes alignment; 1,3: 1 bytes alignment; 2: 2 bytes alignment;
            0:          column_waddr = 0;
            1:          column_waddr = 32'd8;
            2:          column_waddr = 32'd16;
            3:          column_waddr = 32'd24;
            default:    column_waddr = 0;
        endcase
        case(raddr_i % 4) //0: 0 bytes alignment; 1,3: 1 bytes alignment; 2: 2 bytes alignment;
            0:          column_raddr = 0;
            1:          column_raddr = 32'd8;
            2:          column_raddr = 32'd16;
            3:          column_raddr = 32'd24;
            default:    column_raddr = 0;
        endcase
    end 

	/*Write Data*/
	always @(posedge clk_i) begin
        if(mem_wr_i) begin 
            case(rwtype_i)
                2'b00:      memory[row_waddr][column_waddr +: 8]    <= wdata_i[7:0];
                2'b01:      memory[row_waddr][column_waddr +: 16]   <= wdata_i[15:0];
                2'b10:      memory[row_waddr]                       <= wdata_i;
                default:    memory[row_waddr]                       <= wdata_i;
            endcase
        end 
	end

	/*Read Data*/
    always @* begin 
        if(!mem_wr_i) begin 
            case(rwtype_i) 
                2'b00:      data_o_q = {24'b0, memory[row_raddr][column_raddr +: 8]};
                2'b01:      data_o_q = {16'b0, memory[row_raddr][column_raddr +: 16]};
                2'b10:      data_o_q = memory[row_raddr];
                default:    data_o_q = memory[row_raddr];
            endcase
        end 
    end 
	assign data_o = data_o_q;

endmodule

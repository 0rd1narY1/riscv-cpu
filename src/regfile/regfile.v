//`timescale 1ns/1ps

module regfile #(parameter ADDR_WIDTH = 0, DATA_WIDTH = 32)(
	input clk_i,
    input rstn_i,
	input we_i,
	input [ADDR_WIDTH-1:0]rw_i,
	input [ADDR_WIDTH-1:0]ra_i,
	input [ADDR_WIDTH-1:0]rb_i,
	input [DATA_WIDTH-1:0]wdata_i,
	output reg [DATA_WIDTH-1:0]data_a_o,
	output reg [DATA_WIDTH-1:0]data_b_o
);
	reg [DATA_WIDTH-1:0]regfile[2**ADDR_WIDTH-1:1];
    wire [DATA_WIDTH-1:0]reg_x0;
    assign reg_x0 = 32'b0;  //Register x0 is constant 0 

	/*Write Data*/
    integer i;
	always @(posedge clk_i) begin
        if(!rstn_i) begin 
            for(i=1;i<32;i=i+1)
                regfile[i] <= 32'b0;
        end 
		else if(we_i && (rw_i != 5'b0)) //Can't write to x0
			regfile[rw_i] <= wdata_i;
	end

	/*Read Data*/
    always @* begin 
	    data_a_o = (ra_i==5'b0)?reg_x0:regfile[ra_i];
	    data_b_o = (rb_i==5'b0)?reg_x0:regfile[rb_i];
    end 

endmodule

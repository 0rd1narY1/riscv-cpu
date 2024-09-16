module lsu(
    input clk_i,
    input rstn_i,
    //Interface with ctrlu
	input [3:0]rw_ctrl_i, //[3] is r/w control signal, and [2:0] is r/w type control signal
    //Interface with alu
    input [31:0]alu_addr_i,     //32 bits addr from alu
    //Interfaces with data memory
    input [31:0]data_i,         //Data from data memory
    output mem_wr_o,            //Data memory read/write control
    output [11:0]data_addr_o,   //Data memory read/write address
    output [31:0]data_o,        //Data to be written into data memory
    //Interfaces with regfile
    input [31:0]data_reg_to_mem_i,  //Data to be stored into memory
    output [31:0]data_mem_to_reg_o  //Data to be loaded into regfile
);
    reg [31:0]ld_data, st_data;
    
    assign mem_wr_o = rw_ctrl_i[3]; //1 for write and 0 for read
    assign data_addr_o = alu_addr_i[11:0];
    /*Load*/
    always @* begin 
        if(!rw_ctrl_i[3])
            case(rw_ctrl_i[2:0])
                3'b000:     ld_data = {{24{data_i[31]}}, data_i[7:0]}; //lb
                3'b001:     ld_data = {{16{data_i[31]}}, data_i[15:0]}; //lh
                3'b010:     ld_data = data_i; //lw
                3'b011:     ld_data = {24'b0, data_i[7:0]}; //lbu
                3'b100:     ld_data = {16'b0, data_i[15:0]}; //lhu
                default:    ld_data = 32'bx;
            endcase
    end 
	assign data_mem_to_reg_o = ld_data;

    /*Write*/
	always @* begin
        if(!rstn_i)
            st_data = 32'b0;
        else
            if(rw_ctrl_i[3])
		        case(rw_ctrl_i[2:0])
			        3'b000:     st_data = {24'b0, data_reg_to_mem_i[7:0]}; //sb 
                    3'b001:     st_data = {16'b0, data_reg_to_mem_i[15:0]}; //sh
                    3'b010:     st_data = data_reg_to_mem_i; //sw
                    default:    st_data = 32'bx;
                endcase
	end
    assign data_o = st_data;

endmodule

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
    output [1:0]rwtype_o,
    output [11:0]data_addr_o,   //Data memory read/write address
    output [31:0]data_o,        //Data to be written into data memory
    //Interfaces with regfile
    input [31:0]data_reg_to_mem_i,  //Data to be stored into memory
    output [31:0]data_mem_to_reg_o  //Data to be loaded into regfile
);
    reg [31:0]ld_data, st_data;
    reg [1:0]rwtype;
    
    assign mem_wr_o = rw_ctrl_i[3]; //1 for write and 0 for read
    assign data_addr_o = alu_addr_i[11:0];
    /*Load*/
    always @* begin 
        if(!rw_ctrl_i[3])
            case(rw_ctrl_i[2:0])
                3'b000: begin 
                            rwtype  = 2'b00;
                            ld_data = {{24{data_i[7]}}, data_i[7:0]}; //lb
                        end
                3'b001: begin 
                            rwtype  = 2'b01;
                            ld_data = {{16{data_i[15]}}, data_i[15:0]}; //lh
                        end 
                3'b010: begin 
                            rwtype  = 2'b10;
                            ld_data = data_i; //lw
                        end 
                3'b011: begin 
                            rwtype  = 2'b00;
                            ld_data = {24'b0, data_i[7:0]}; //lbu
                        end
                3'b100: begin 
                            rwtype  = 2'b01;
                            ld_data = {16'b0, data_i[15:0]}; //lhu
                        end
                default: begin rwtype = 2'bxx; ld_data = 32'bx; end
            endcase
    end 
	assign data_mem_to_reg_o = ld_data;

    /*Write*/
	always @* begin
        if(!rstn_i)
            st_data = 32'b0;
        else
            if(rw_ctrl_i[3])
                st_data = data_reg_to_mem_i;
		        case(rw_ctrl_i[2:0])
			        3'b000:     rwtype = 2'b00; //sb 
                    3'b001:     rwtype = 2'b01; //sh
                    3'b010:     rwtype = 2'b10; //sw
                    default:    rwtype = 2'b10;
                endcase
	end
    assign data_o = st_data;
    assign rwtype_o = rwtype;

endmodule

//`timescale 1ns/1ps

module alu #(parameter DATA_WIDTH = 32)(
	input [DATA_WIDTH-1:0]A,
	input [DATA_WIDTH-1:0]B,
	input [3:0]ALUctr,
	output Zero,
	output reg [DATA_WIDTH-1:0]ALUOut
);
	assign Zero = (ALUOut==0);
	always @(ALUctr,A,B) begin
		case(ALUctr)
			4'b0000:ALUOut = A + B;         //auipc,add,addi,lw,sw,jal
            4'b0001:ALUOut = A & B;         //and,andi
			4'b0010:ALUOut = ($signed(A) < $signed(B)) ? 1 : 0; //slt,slti,blt,bge
			4'b0011:ALUOut = (A < B) ? 1 : 0; //sltu,sltiu,bltu,bgeu
			4'b0110:ALUOut = A | B;         //or,ori
            4'b0111:ALUOut = A ^ B;         //xor,xori
			4'b1000:ALUOut = A - B;         //sub,beq,bne
            4'b1001:ALUOut = A << B[4:0];   //sll,slli
            4'b1010:ALUOut = A >> B[4:0];   //srl,srli
            4'b1011:ALUOut = $signed(A) >>> B[4:0]; //sra,srai
            //4'b1100:ALUOut = ;
            //4'b1101:ALUOut = ;
            //4'b1110:ALUOut = ;
            4'b1111:ALUOut = B;             //(srcB) lui
			default:ALUOut = 'b0;
		endcase
	end

endmodule

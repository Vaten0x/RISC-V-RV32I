module decoder
    import rv32i_pkg::*;
(
    input [31:0] instr,
    output [6:0] opcode,
    output [4:0] rd,
    output [4:0] rs1,
    output [4:0] rs2,
    output [2:0] funct3,
    output [6:0] funct7,
    output logic reg_write,
    output logic [2:0] imm_sel,
    output logic alu_src_b,
    output logic [3:0] alu_op
);

    assign opcode = instr[6:0];

    assign rd = instr[11:7];

    assign rs1 = instr[19:15];
    assign rs2 = instr[24:20];

    assign funct3 = instr[14:12];
    assign funct7 = instr[31:25];

    always_comb begin
        case (opcode) 
            7'b0110011: begin //R-type
                reg_write = 1'b1;
                alu_src_b = 1'b0; //register

                if (funct3 == 3'b000 && ~instr[30]) alu_op = 4'b0000; //add
                else if (funct3 == 3'b000 && instr[30]) alu_op = 4'b0001; //sub
                else if (funct3 == 3'b001) alu_op = 4'b0010; //sll
                else if (funct3 == 3'b010) alu_op = 4'b0011; //slt
                else if (funct3 == 3'b011) alu_op = 4'b0100; //sltu
                else if (funct3 == 3'b100) alu_op = 4'b0101; //xor
                else if (funct3 == 3'b101 && ~instr[30]) alu_op = 4'b0110; //srl
                else if (funct3 == 3'b101 && instr[30]) alu_op = 4'b0111; //sra
                else if (funct3 == 3'b110) alu_op = 4'b1000; //or
                else if (funct3 == 3'b111) alu_op = 4'b1001; //and
            end
            7'b0010011: begin //R-type with immediate
                reg_write = 1'b1;
                imm_sel = IMM_I;
                alu_src_b = 1'b1; //immediate

                //TODO: implement the rest for I type operations as well
            end
            default: begin //at default, do add operation
                reg_write = 1'b1;
                alu_src_b = 1'b0; //register
                alu_op = 4'b0000;
            end
        endcase

    end


    


endmodule
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
    output logic alu_src_a, //1 means using rs1
    output logic alu_src_b, //1 means using rs2
    output logic [3:0] alu_op
);

    assign opcode = instr[6:0];

    assign rd = instr[11:7];

    assign rs1 = instr[19:15];
    assign rs2 = instr[24:20];

    assign funct3 = instr[14:12];
    assign funct7 = instr[31:25];

    always_comb begin
        //add defaults to avoid latches before case statement
        reg_write = 1'b0;
        imm_sel = 3'b000;
        alu_src_a = 1'b0;
        alu_src_b = 1'b0;
        alu_op = 4'b0000;

        case (opcode) 
            7'b0110011: begin //R-type
                reg_write = 1'b1;
                alu_src_a = 1'b1;
                alu_src_b = 1'b1; //register

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
                alu_src_a = 1'b1;
                alu_src_b = 1'b0; //immediate

                if (funct3 == 3'b000) alu_op = 4'b0000; //addi
                // no subi
                else if (funct3 == 3'b001) alu_op = 4'b0010; //slli
                else if (funct3 == 3'b010) alu_op = 4'b0011; //slti
                else if (funct3 == 3'b011) alu_op = 4'b0100; //sltiu
                else if (funct3 == 3'b100) alu_op = 4'b0101; //xori
                else if (funct3 == 3'b101 && ~instr[30]) alu_op = 4'b0110; //srli
                else if (funct3 == 3'b101 && instr[30]) alu_op = 4'b0111; //srai
                else if (funct3 == 3'b110) alu_op = 4'b1000; //ori
                else if (funct3 == 3'b111) alu_op = 4'b1001; //andi
            end
            7'b0110111: begin //U-type LUI - puts imm straight to rd using alu_op 1010
                reg_write = 1'b1;
                imm_sel = IMM_U;
                alu_src_a = 1'b0; //not using rs1
                alu_src_b = 1'b0; //not using rs2
                alu_op = 4'b1010; // return b operand
            end
            7'b0010111: begin //U-type AUIPC - adds pc + imm to rd
                reg_write = 1'b1;
                imm_sel = IMM_U;
                alu_src_a = 1'b0; //not using rs1
                alu_src_b = 1'b0; //not using rs2
                alu_op = 4'b0000; //add
            end

            default: begin //at default, dont write it to a register
                reg_write = 1'b0; //disable reg write
                imm_sel = IMM_I;
                alu_src_a = 1'b0;
                alu_src_b = 1'b0;
                alu_op = 4'b0000;
            end
        endcase
    end
endmodule
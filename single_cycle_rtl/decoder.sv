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
    output [31:0] imm,
    output reg_write,
    output [2:0] imm_sel,
    output alu_src_b,
    output [3:0] alu_op
);

    assign opcode = instr[6:0];

    assign rd = instr[11:7];

    assign rs1 = instr[19:15];
    assign rs2 = instr[24:20];

    assign funct3 = instr[14:12];
    assign funct7 = instr[31:25];

    case (opcode) 
        7'b0110011: begin //R-type
            alu_op = funct3;
            alu_src_b = 1'b0; //register
        end
        7'b0010011: begin //R-type with immediate
            alu_op = funct3;
            imm_sel = IMM_I;
            alu_src_b = 1'b1; //immediate
        end
    endcase


endmodule
// Implementing just for ADDI for now

// https://docs.riscv.org/reference/isa/v20260120/unpriv/rv-32-64g.html
// ADDI: 
/*
 31        20 19  15 14  12 11   7 6      0
|  imm[11:0] | rs1  | 000  |  rd  | 0010011 |  - I-type
                     funct3         opcode
*/

// addi rd, rs1, imm means rd = rs1 + sign_extended(imm)

module decoder(
    input logic [31:0] instr
    
    output logic [11:0] imm,
    output logic rs1,
    output logic [2:0] funct3,
    output logic [5:0] opcode,
    output logic reg_write
);

    // For I-type:
    assign imm = instr[31:20];
    assign rs1 = instr[19:15];
    assign funct3 = instr[14:12];
    assign rd = instr[11:7];
    assign opcode = instr[6:0];

endmodule
module decoder(
    input [31:0] instr,
    output [6:0] opcode,
    output [5:0] rd,
    output [5:0] rs1,
    output [5:0] rs2,
    output [3:0] funct3
);

    assign opcode = instr[6:0]; //TODO: hardset to IMM_I, I-type for now, change logic later

    assign rd = instr[11:7]; //TODO: hardset to IMM_I, I-type for now, change logic later

    assign rs1 = instr[19:15]; //TODO: hardset to IMM_I, I-type for now, change logic later
    assign rs2 = 5'b00000; //TODO: hardset to some value, I-type for now, change logic later

    assign funct3 = instr[14:12]; //TODO: hardset to IMM_I, I-type for now, change logic later


endmodule
module cpu_top
    import rv32i_pkg::*;
(
    input logic clk,
    input logic rst_n
);

    // Implementing just for ADDI for now

    // https://docs.riscv.org/reference/isa/v20260120/unpriv/rv-32-64g.html
    // ADDI: 
    /*
    31        20 19  15 14  12 11   7 6      0
    |  imm[11:0] | rs1  | 000  |  rd  | 0010011 |  - I-type
                        funct3         opcode
    */

    logic [31:0] instr;

    logic [31:0] imm;
    logic [4:0] rs1;
    logic [2:0] funct3;
    logic [4:0] rd;
    logic [6:0] opcode;

    assign rs1 = instr[19:15]; //TODO: hardset to IMM_I, I-type for now, change logic later
    assign funct3 = instr[14:12]; //TODO: hardset to IMM_I, I-type for now, change logic later
    assign rd = instr[11:7]; //TODO: hardset to IMM_I, I-type for now, change logic later
    assign opcode = instr[6:0]; //TODO: hardset to IMM_I, I-type for now, change logic later

    logic we;
    logic [4:0] rs2;

    assign we = 1'b1; //TODO: hardset to some value, I-type for now, change logic later
    assign rs2 = 5'b00000; //TODO: hardset to some value, I-type for now, change logic later

    logic [31:0] rd1, rd2;
    logic [31:0] ALU_result;

    logic [31:0] pc;
    logic [31:0] next_pc;

    pc PC(
        .clk(clk),
        .rst_n(rst_n),
        .next_pc(next_pc),
        .pc(pc)
    );

    instr_mem INSTR_MEM(
        .addr(pc),
        .instr(instr)
    );

    regfile REGFILE(
        .clk(clk),
        .rst_n(rst_n),
        .we(we),
        .rs1(rs1),
        .rs2(rs2),
        .write_addr(rd),
        .write_data(ALU_result), //TODO: hardset to IMM_I, I-type for now, change logic later
        .rd1(rd1), //TODO: hardset to IMM_I, I-type for now, change logic later
        .rd2(rd2) //TODO: hardset to IMM_I, I-type for now, change logic later
    );

    alu ALU(
        .a(rd1), //TODO: hardset to IMM_I, I-type for now, change logic later
        .b(imm), //TODO: hardset to IMM_I, I-type for now, change logic later
        .op(4'b0000), //TODO: hardset to ADD operation, I-type for now, change logic later
        .result(ALU_result) //TODO: hardset to IMM_I, I-type for now, change logic later
    );

    imm_gen IMM_GEN(
        .inst(instr),
        .imm_sel(IMM_I), //TODO: hardset to IMM_I, I-type for now, change logic later
        .imm(imm)
    );

endmodule
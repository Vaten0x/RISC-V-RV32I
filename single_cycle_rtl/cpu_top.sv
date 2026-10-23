module cpu_top
    import rv32i_pkg::*;
(
    input logic clk,
    input logic rst_n
);

    logic [31:0] instr;

    //instruction components
    logic [6:0] opcode;
    logic [4:0] rd;
    logic [4:0] rs1, rs2;
    logic [2:0] funct3;
    logic [6:0] funct7;
    logic reg_write;
    logic [2:0] imm_sel;
    logic alu_src_b; //0 is reg, 1 is imm
    logic [3:0] alu_op;

    logic [31:0] rd1, rd2;
    logic [31:0] ALU_result;

    logic [31:0] pc;
    logic [31:0] next_pc;

    logic [31:0] imm;

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

    decoder DECODER(
        .instr(instr),
        .opcode(opcode),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2),
        .funct3(funct3),
        .funct7(funct7),
        .reg_write(reg_write),
        .imm_sel(imm_sel),
        .alu_src_b(alu_src_b),
        .alu_op(alu_op)
    );

    regfile REGFILE(
        .clk(clk),
        .rst_n(rst_n),
        .reg_write(reg_write),
        .rs1(rs1),
        .rs2(rs2),
        .write_addr(rd),
        .write_data(ALU_result),
        .rd1(rd1),
        .rd2(rd2)
    );

    alu ALU(
        .a(rd1),
        .b(alu_src_b ? imm : rd2),
        .alu_op(alu_op),
        .result(ALU_result)
    );

    imm_gen IMM_GEN(
        .inst(instr),
        .imm_sel(imm_sel),
        .imm(imm)
    );

endmodule
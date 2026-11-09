package rv32i_pkg;

    typedef enum logic [2:0] {
        IMM_I = 3'b000,
        IMM_S = 3'b001,
        IMM_B = 3'b010,
        IMM_U = 3'b011,
        IMM_J = 3'b100
    } imm_sel_t;

    typedef struct packed {
        logic [31:0] pc;
        logic [31:0] next_pc;
        logic [31:0] instr;
        logic valid;
    } IF_ID_t;

    typedef struct packed {
        logic [31:0] next_pc;
        logic [31:0] pc;
        logic branch;
        logic jump;
        logic [3:0] alu_op;
        logic [2:0] funct3;
        logic [31:0] imm;
        logic alu_src_a;
        logic alu_src_b;
        logic [31:0] rd1;
        logic [31:0] rd2;
        logic mem_write;
        logic mem_load;
        logic reg_write;
        logic [4:0] rd;
        logic valid;
    } ID_EX_t;

    typedef struct packed {
        logic [31:0] next_pc;
        logic jump;
        logic [31:0] rd2;
        logic mem_write;
        logic [31:0] ALU_result;
        logic mem_load;
        logic reg_write;
        logic [4:0] rd;
        logic valid;
    } EX_MEM_t;

    typedef struct packed {
        logic [31:0] next_pc;
        logic jump;
        logic [31:0] ALU_result;
        logic [31:0] read_data;
        logic mem_load;
        logic reg_write;
        logic [4:0] rd;
        logic valid;
    } MEM_WB_t;

endpackage
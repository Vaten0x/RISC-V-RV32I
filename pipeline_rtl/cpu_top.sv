module cpu_top
    import rv32i_pkg::*;
(
    input logic clk,
    input logic rst_n
);

    IF_ID_t IF_ID_regs;
    ID_EX_t ID_EX_regs;
    EX_MEM_t EX_MEM_regs;
    MEM_WB_t MEM_WB_regs;

    logic [31:0] instr;

    //instruction components
    logic [6:0] opcode;
    logic [4:0] rd;
    logic [4:0] rs1, rs2;
    logic [2:0] funct3;
    logic [6:0] funct7;
    logic reg_write;
    logic jump;
    logic [2:0] imm_sel;
    logic alu_src_a; //1 means using rs1
    logic alu_src_b; //1 means using rs2
    logic [3:0] alu_op;
    logic [31:0] rd1, rd2;
    logic [31:0] ALU_result;

    // For program counter
    logic [31:0] pc;
    logic [31:0] next_pc;
    assign next_pc = pc + 32'h4;

    logic [31:0] imm;
    logic [31:0] mux_out;

    // For data_mem components
    logic mem_load;
    logic mem_write; //write_en for DATA_MEM
    logic [31:0] read_data;

    // For branch
    logic branch; //decoder finds the instr to be a B type command
    logic take_branch; //branch_decoder says to take the branch

    // For data forwarding
    logic [31:0] forwarded_rd1;
    logic [31:0] forwarded_rd2;

    // IF/ID
    always_ff @(posedge clk) begin
        if (~rst_n) begin
            IF_ID_regs <= '0;
        end else begin
            IF_ID_regs.pc <= pc;
            IF_ID_regs.next_pc <= next_pc;
            IF_ID_regs.instr <= instr;
        end
    end

    // ID/EX
    always_ff @(posedge clk) begin
        if (~rst_n) begin
            ID_EX_regs <= '0;
        end else begin
            ID_EX_regs.next_pc <= IF_ID_regs.next_pc;
            ID_EX_regs.pc <= IF_ID_regs.pc;
            ID_EX_regs.branch <= branch;
            ID_EX_regs.jump <= jump;
            ID_EX_regs.alu_op <= alu_op;
            ID_EX_regs.funct3 <= funct3;
            ID_EX_regs.imm <= imm;
            ID_EX_regs.alu_src_a <= alu_src_a;
            ID_EX_regs.alu_src_b <= alu_src_b;
            ID_EX_regs.rs1 <= rs1;
            ID_EX_regs.rs2 <= rs2;
            ID_EX_regs.rd1 <= rd1;
            ID_EX_regs.rd2 <= rd2;
            ID_EX_regs.mem_write <= mem_write;
            ID_EX_regs.mem_load <= mem_load;
            ID_EX_regs.reg_write <= reg_write;
            ID_EX_regs.rd <= rd;
        end
    end

    // EX/MEM
    always_ff @(posedge clk) begin
        if (~rst_n) begin
            EX_MEM_regs <= '0;
        end else begin
            EX_MEM_regs.next_pc <= ID_EX_regs.next_pc;
            EX_MEM_regs.jump <= ID_EX_regs.jump;
            EX_MEM_regs.rd2 <= forwarded_rd2;
            EX_MEM_regs.mem_write <= ID_EX_regs.mem_write;
            EX_MEM_regs.ALU_result <= ALU_result;
            EX_MEM_regs.mem_load <= ID_EX_regs.mem_load;
            EX_MEM_regs.reg_write <= ID_EX_regs.reg_write;
            EX_MEM_regs.rd <= ID_EX_regs.rd;
        end
    end

    // data forward MEM/WB to EX
    always_comb begin
        if (MEM_WB_regs.reg_write == 1'b1 && MEM_WB_regs.rd != 5'd0) begin
            if (MEM_WB_regs.rd == ID_EX_regs.rs1) forwarded_rd1 = mux_out;
            else forwarded_rd1 = ID_EX_regs.rd1;
            if (MEM_WB_regs.rd == ID_EX_regs.rs2) forwarded_rd2 = mux_out;
            else forwarded_rd2 = ID_EX_regs.rd2;
        end else begin
            forwarded_rd1 = ID_EX_regs.rd1;
            forwarded_rd2 = ID_EX_regs.rd2;
        end
    end

    // MEM/WB
    always_ff @(posedge clk) begin
        if (~rst_n) begin
            MEM_WB_regs <= '0;
        end else begin
            MEM_WB_regs.next_pc <= EX_MEM_regs.next_pc;
            MEM_WB_regs.jump <= EX_MEM_regs.jump;
            MEM_WB_regs.ALU_result <= EX_MEM_regs.ALU_result;
            MEM_WB_regs.read_data <= read_data;
            MEM_WB_regs.mem_load <= EX_MEM_regs.mem_load;
            MEM_WB_regs.reg_write <= EX_MEM_regs.reg_write;
            MEM_WB_regs.rd <= EX_MEM_regs.rd;
        end
    end

    // IF - Instruction Fetch Stage

    pc PC(
        .clk(clk),
        .rst_n(rst_n),
        .next_pc(ID_EX_regs.jump || (ID_EX_regs.branch && take_branch) ? ALU_result : next_pc), //TODO: figure out stalling
        .pc(pc)
    );

    instr_mem INSTR_MEM(
        .addr(pc),
        .instr(instr)
    );

    // ID - Instruction Decode Stage

    imm_gen IMM_GEN(
        .instr(IF_ID_regs.instr),
        .imm_sel(imm_sel),
        .imm(imm)
    );

    decoder DECODER(
        .instr(IF_ID_regs.instr),
        .opcode(opcode),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2),
        .funct3(funct3),
        .funct7(funct7),
        .reg_write(reg_write),
        .jump(jump),
        .branch(branch),
        .mem_load(mem_load),
        .mem_write(mem_write),
        .imm_sel(imm_sel),
        .alu_src_a(alu_src_a),
        .alu_src_b(alu_src_b),
        .alu_op(alu_op)
    );

    // EX - Execute Stage

    alu ALU(
        .a(ID_EX_regs.alu_src_a ? forwarded_rd1 : ID_EX_regs.pc),
        .b(ID_EX_regs.alu_src_b ? forwarded_rd2 : ID_EX_regs.imm),
        .alu_op(ID_EX_regs.alu_op),
        .result(ALU_result)
    );

    branch_decoder BRANCH_DECODER(
        .rd1(forwarded_rd1),
        .rd2(forwarded_rd2),
        .funct3(ID_EX_regs.funct3),
        .take_branch(take_branch)
    );

    // MEM - Memory Stage

    data_mem DATA_MEM(
        .clk(clk),
        .rst_n(rst_n),
        .write_en(EX_MEM_regs.mem_write),
        .address(EX_MEM_regs.ALU_result),
        .write_data(EX_MEM_regs.rd2),
        .read_data(read_data)
    );

    // WB - Writeback Stage, the rs1, rs2, rd1, rd2 are used by the instruction in ID stage

    regfile REGFILE(
        .clk(clk),
        .rst_n(rst_n),
        .reg_write(MEM_WB_regs.reg_write),
        .rs1(rs1),
        .rs2(rs2),
        .write_addr(MEM_WB_regs.rd),
        .write_data(mux_out),
        .rd1(rd1),
        .rd2(rd2)
    );

    /*
        If jump=1, we write next_pc
        If mem_load=1, we write read_data
        both 0, we write ALU_result
        otherwise just write 32'd0
    */
    mux4to1 MUX4TO1(
        .sel({MEM_WB_regs.jump, MEM_WB_regs.mem_load}),
        .input1(MEM_WB_regs.next_pc),
        .input2(MEM_WB_regs.read_data),
        .input3(MEM_WB_regs.ALU_result),
        .input4(32'd0),
        .mux_out(mux_out)
    );

endmodule
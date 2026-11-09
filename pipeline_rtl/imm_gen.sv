module imm_gen 
    import rv32i_pkg::*;
(
    input logic [31:0] instr,
    input logic [2:0] imm_sel,
    output logic [31:0] imm
);

    //have to build the formats of different immediate encoiding variants, chapter 2.1.3 in riscv-isa-manual

    //we can do this either by having the immediate generator look at the opcode or the decoder outputs an imm_sel signal for 3 bits tells all the 5 formats we have which is I, S, B, U and J

    // but for my case i think it's cleaner to have the logic for checking the inst logic in the decoder, so it would be better for that.

    always_comb begin
        case (imm_sel)
            IMM_I: begin
                imm[11:0] = inst[31:20];
                imm[31:12] = {20{inst[31]}};
            end
            IMM_S: begin
                imm[11:0] = { inst[31:25], inst[11:7] };
                imm[31:12] = {20{inst[31]}};
            end
            IMM_B: begin
                imm[0] = 1'd0;
                imm[10:1] = { inst[30:25], inst[11:8] };
                imm[11] = inst[7];
                imm[31:12] = {20{inst[31]}};
            end
            IMM_U: begin
                imm[11:0] = 12'd0;
                imm[31:12] = inst[31:12];
            end
            IMM_J: begin
                imm[0] = 1'd0;
                imm[10:1] = inst[30:21];
                imm[11] = inst[20];
                imm[19:12] = inst[19:12];
                imm[31:20] = {12{inst[31]}};
            end
            default: imm = 32'd0;
        endcase
    end


endmodule
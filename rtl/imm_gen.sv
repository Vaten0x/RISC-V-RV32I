module imm_gen (
    input logic [31:0] inst,
    input logic [2:0] imm_sel,
    output logic [31:0] imm
);

    typedef enum logic [2:0] {
        IMM_I = 3'b000,
        IMM_S = 3'b001,
        IMM_B = 3'b010,
        IMM_U = 3'b011,
        IMM_J = 3'b100
    } imm_sel_t;

    //have to build the formats of different immediate encoiding variants, chapter 2.1.3 in riscv-isa-manual

    //we can do this either by having the immediate generator look at the opcode or the decoder outputs an imm_sel signal for 3 bits tells all the 5 formats we have which is I, S, B, U and J

    // but for my case i think it's cleaner to have the logic for checking the inst logic in the decoder, so it would be better for that.

    always_comb begin
        case (imm_sel)
            IMM_I: imm[11:0] = inst[31:20];
            IMM_S: imm[11:0] = { inst[31:25], inst[11:7] };
            IMM_B: imm[10:1] = { inst[30:25], inst[11:8] };
            IMM_U: imm[31:12] = inst[31:12];
            IMM_J: begin
                imm[10:1] = inst[30:21];
                imm[19:12] = inst[19:12];
            end
        endcase
    end


endmodule
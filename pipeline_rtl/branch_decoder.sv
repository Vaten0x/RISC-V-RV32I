module branch_decoder(
    input logic [31:0] rd1, rd2,
    input logic [2:0] funct3,
    output logic take_branch
);

    always_comb begin
        case(funct3)
            3'b000: take_branch = (rd1 == rd2); //BEQ - taken when rd1 == rd2
            3'b001: take_branch = (rd1 != rd2); //BNE - taken when rd1 != rd2
            3'b100: take_branch = ($signed(rd1) < $signed(rd2)); //BLT - taken when rd1 < rd2 (signed)
            3'b101: take_branch = ($signed(rd1) >= $signed(rd2)); //BGE - taken when rd1 >= rd2 (signed)
            3'b110: take_branch = (rd1 < rd2); //BLTU - taken when rd1 < rd2 (unsigned)
            3'b111: take_branch = (rd1 >= rd2); //BGEU - taken when rd1 >= rd2 (unsigned)
            default: take_branch = 0;
        endcase
    end

endmodule
module alu(
    input [31:0] a, b,
    input [3:0] alu_sel,
    output logic [31:0] result
);

    wire [4:0] shift = b[4:0];

    always_comb begin
        case(alu_sel) 
            4'b0000: result = a + b; //add
            4'b0001: result = a - b; //sub
            4'b0010: result = a << shift; //sll
            4'b0011: result = (a[31] != b[31]) ? {31'b0, a[31]} : {31'b0, a < b}; //slt (signed) [boolean for a < b] - set less than
            4'b0100: result = {31'b0, a < b}; //sltu (unsigned) - set less than unsigned
            4'b0101: result = a ^ b; //xor
            4'b0110: result = a >> shift; //srl
            4'b0111: result = (a >> shift) | (a[31] ? ~(32'hFFFFFFFF >> shift) : 32'b0); //sra - shift right arithmetic
            4'b1000: result = a | b; //or
            4'b1001: result = a & b; //and
            default: result = 0;
        endcase
    end
endmodule 
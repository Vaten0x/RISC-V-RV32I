
// Lab 6 change: status flag
//    status[0] = zero flag
//    status[1] = negative flag
//    status[2] = overflow flag

module ALU(Ain,Bin,ALUop,out,status);
    input [15:0] Ain, Bin;
    input [1:0] ALUop;
    output reg [15:0] out;
    output [2:0] status;

    wire signA = Ain[15]; // sign of Ain
    wire signB = Bin[15]; // sign of Bin
    wire isSub = (~ALUop[1])&ALUop[0]; // detects if its sub

    wire xor1 = isSub ^ signB;
    wire xor2 = signA ^ xor1;
    wire xor3 = signA ^ out[15]; // NOTE: account for sub

    assign status[0] = ~|out;          // Zero Flag
    assign status[1] = out[15];       // Negative Flag
    assign status[2] = (~xor2)&(xor3); // Overflow flag

    always_comb begin

        case (ALUop)

            2'b00: out = Ain + Bin;

            2'b01: out = Ain - Bin;

            2'b10: out = Ain & Bin;

            2'b11: out = ~Bin;
                
            default: out = 16'bx;

        endcase

    end

endmodule
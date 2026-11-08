module mux4to1(
    input logic [1:0] sel,
    input logic [31:0] input1, input2, input3, input4,
    output logic [31:0] mux_out
);

    always_comb begin
        case(sel)
            2'b10: mux_out = input1;
            2'b01: mux_out = input2;
            2'b00: mux_out = input3;
            default mux_out = input4; //input 4 is just 32'd0
        endcase
    end

endmodule
module pc(
    input logic clk,
    input logic rst_n,
    input logic jump,
    output logic [31:0] next_pc,
    output logic [31:0] pc
);

    always_ff @(posedge clk) begin
        if (~rst_n) begin
            pc <= 32'd0; //set it to 0 for rst for now 
        end else begin
            pc <= next_pc;
        end
    end

    assign next_pc = pc + 32'h4;

endmodule
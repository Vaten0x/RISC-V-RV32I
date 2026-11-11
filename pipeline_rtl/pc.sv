module pc(
    input logic clk,
    input logic rst_n,
    input logic load_use_hazard,
    input logic [31:0] next_pc,
    output logic [31:0] pc
);

    always_ff @(posedge clk) begin
        if (~rst_n) begin
            pc <= 32'd0; //set it to 0 for rst for now 
        end else if (load_use_hazard) begin
            pc <= pc;
        end else begin
            pc <= next_pc;
        end
    end

endmodule
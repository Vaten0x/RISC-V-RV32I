module regfile( 
    input logic clk,
    input logic rst_n,
    input logic we,
    input logic [4:0] rs1, rs2, 
    input logic [4:0] write_addr,
    input logic [31:0] write_data,

    output logic [31:0] rd1, rd2
);

    logic [31:0] regs [31:0];

    //this is the part where i need to do the write commands 
    always_ff @(posedge clk) begin
        if (~rst_n) begin
            for (int i = 0; i < 32; i++) begin
                regs[i] <= 32'd0;
            end
        end else if (we && write_addr != 0) begin
            regs[write_addr] <= write_data;
        end
    end

    //this is for read, since it can be combinational compared to the write data part
    assign rd1 = (rs1 == 5'd0) ? 32'd0 : regs[rs1];
    assign rd2 = (rs2 == 5'd0) ? 32'd0 : regs[rs2];

endmodule
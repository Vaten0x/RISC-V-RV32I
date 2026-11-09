module regfile( 
    input logic clk,
    input logic rst_n,
    input logic reg_write,
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
        end else if (reg_write && write_addr != 0) begin
            regs[write_addr] <= write_data;
        end
    end

    //this is for read, since it can be combinational compared to the write data part
    //and if the write_addr (for EX) is the same as the read on rs (ID) then we can write it straight on without one cycle wait
    //also if address is 0, meaning it's reading x0, RISC-V spac says x0 always reads as 0 thats why such gates exists
    always_comb begin
        if (reg_write && (write_addr == rs1) && (write_addr == rs2) ) begin
            rd1 = (rs1 == 5'd0) ? 32'd0 : write_data;
            rd2 = (rs2 == 5'd0) ? 32'd0 : write_data;
        end else if (reg_write && (write_addr == rs1)) begin
            rd1 = (rs1 == 5'd0) ? 32'd0 : write_data;
            rd2 = (rs2 == 5'd0) ? 32'd0 : regs[rs2];
        end else if (reg_write && (write_addr == rs2)) begin
            rd1 = (rs1 == 5'd0) ? 32'd0 : regs[rs1];
            rd2 = (rs2 == 5'd0) ? 32'd0 : write_data;
        end else begin
            rd1 = (rs1 == 5'd0) ? 32'd0 : regs[rs1];
            rd2 = (rs2 == 5'd0) ? 32'd0 : regs[rs2];
        end
    end

    // assign rd1 = (rs1 == 5'd0) ? 32'd0 : regs[rs1];
    // assign rd2 = (rs2 == 5'd0) ? 32'd0 : regs[rs2];

endmodule
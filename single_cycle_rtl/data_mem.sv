module data_mem(
    input logic clk,
    input logic rst_n,
    input logic write_en,
    input logic [31:0] address,
    input logic [31:0] write_data,
    output logic [31:0] read_data
);

    logic [31:0] DATA_MEM [1023:0]; //4 KiB - 1024 entries of 32 bits or 4 bytes 

    always_ff @(posedge clk) begin
        if (~rst_n) begin
            for (int i = 0; i < 1024; i++) begin
                DATA_MEM[i] <= 32'b0;
            end
        end else if (write_en) begin
            DATA_MEM[address[11:2]] <= write_data; //same method from instr_mem.sv
        end
    end

    assign read_data = DATA_MEM[address[11:2]];
endmodule
module cpu_top_tb();
    logic clk;
    logic rst_n;
    int errors = 0;
    int cycles = 0;

    cpu_top CPU_TOP(
        .clk(clk),
        .rst_n(rst_n)
    );

    initial begin
        clk = 0; 
        forever #5 clk = ~clk; //100 MHz since freq = 1/T where T = 10ns 
    end

    task check_reg(input int r, input logic [31:0] expected);
        if (CPU_TOP.REGFILE.regs[r] !== expected) begin
            $display("ERROR CPU_TOP.REGFILE.regs[r]=%0d expected=%h", r, expected);
            // will show something like x6 expected=00000000 got=000000001
            errors += 1;
        end
    endtask

    initial begin
        @(posedge clk);
        rst_n = 0;
        repeat (2) @(posedge clk);
        @(negedge clk) rst_n = 1;

        while (CPU_TOP.REGFILE.regs[r] !== 8'h00000073) begin
            check_reg()
        end

        $finish;
    end
endmodule
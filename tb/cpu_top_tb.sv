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
            $display("ERROR r=%0d CPU_TOP.REGFILE.regs[r]=%h expected=%h", r, CPU_TOP.REGFILE.regs[r], expected);
            // will show something like x6 expected=00000000 got=000000001
            errors += 1;
        end
    endtask

    initial begin
        rst_n = 0;
        repeat (2) @(posedge clk);
        @(negedge clk) rst_n = 1;

        // 00000073 is the ecall
        while (CPU_TOP.INSTR_MEM.instr !== 32'h00000073 && cycles < 100) begin
            @(posedge clk);
            cycles += 1;
        end

        // tests/alu_ops.s 
        check_reg(0, 32'h00000000); //x0 should be tied to 0
        check_reg(1, 32'h00000005); //addi x1, x0, 5
        check_reg(2, 32'hFFFFFFFD); //addi x2, x0, -3
        check_reg(3, 32'h00000002); //add  x3, x1, x2
        check_reg(4, 32'h00000008); //sub  x4, x1, x2
        check_reg(5, 32'h00000001); //slt  x5, x2, x1 (this is 1 because x2 < x1)
        check_reg(6, 32'h00000000); //sltu x6, x2, x1 (0 since unsigned, sign doesnt matter)
        
        
        // check_reg(7, 32'h00000001); //srai x7, x2, 1 (x2 >> 1)
        // check_reg(8, 32'h00000001); //srli x8, x2, 28 (x2 >> 28)
        // check_reg(9, 32'h00000001); //xori x9, x1, 0xff
        // check_reg(10, 32'h00000001); //slli x10, x1, 4

        if (errors >= 1) begin
            $display("FAILED, errors=%0d, cycles=%0d", errors, cycles);
        end

        $finish;
    end
endmodule
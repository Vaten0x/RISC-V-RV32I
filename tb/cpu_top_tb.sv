// Runs one riscv-tests program on cpu_top and prints PASS or FAIL.
// Pick the test with a plusarg:  xsim cpu_sim -R -testplusarg TEST_add   (default: simple)
// (No "=" in the plusarg: Vivado's xsim.bat on Windows splits arguments at "=".)
// Hex files are in hex_files/ (rebuild commands are in README.md).
// Tests are linked at 0x80000000 (stock riscv-tests link.ld) but run from PC 0, so an
// address in build/<test>.dump = the PC in the waveform + 0x80000000.
//
// Each test ends on an ecall. At that point gp (x3) holds the result:
//   x3 == 1                  -> PASS
//   x3 == (n << 1) | 1       -> FAIL in test case n (search "TEST_*( n," in tests/riscv-tests/isa/rv64ui/<test>.S)
module cpu_top_tb();
    logic clk;
    logic rst_n;
    int cycles = 0;
    localparam int MAX_CYCLES = 10000;

    string test;
    string data_file;
    int fd;
    logic [31:0] gp;

    cpu_top CPU_TOP(
        .clk(clk),
        .rst_n(rst_n)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; //100 MHz since freq = 1/T where T = 10ns
    end

    initial begin
        if (!$value$plusargs("TEST_%s", test)) test = "simple";

        $readmemh({"hex_files/", test, ".hex"}, CPU_TOP.INSTR_MEM.INSTR_RAM);

        rst_n = 0;
        repeat (2) @(posedge clk);
        @(negedge clk) rst_n = 1;

        // data_mem clears itself during reset, so load the test's data after reset is released
        data_file = {"hex_files/", test, "_data.hex"};
        fd = $fopen(data_file, "r");
        if (fd != 0) begin
            $fclose(fd);
            $readmemh(data_file, CPU_TOP.DATA_MEM.DATA_MEM);
        end

        // 00000073 is the ecall
        while (CPU_TOP.INSTR_MEM.instr !== 32'h00000073 && cycles < MAX_CYCLES) begin
            @(posedge clk);
            cycles += 1;
        end

        gp = CPU_TOP.REGFILE.regs[3];
        if (cycles >= MAX_CYCLES) begin
            $display("FAIL %s: timeout after %0d cycles, pc=%h", test, cycles, CPU_TOP.pc);
        end else if (gp === 32'd1) begin
            $display("PASS %s: cycles=%0d", test, cycles);
        end else begin
            $display("FAIL %s: test case %0d failed (gp=%h), pc=%h, cycles=%0d", test, gp >> 1, gp, CPU_TOP.pc, cycles);
        end

        $finish;
    end
endmodule

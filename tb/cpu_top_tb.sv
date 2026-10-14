module cpu_top_tb();
    logic clk;
    logic rst_n;

    initial begin
        clk = 0;
        rst_n = 0;
        #5;
        rst_n = 1;
        forever #5 clk = ~clk; //100 MHz since freq = 1/T where T = 10ns 
    end

    cpu_top CPU_TOP(
        .clk(clk),
        .rst_n(rst_n)
    );

    initial begin
        $display()
    end


endmodule
module instr_mem(
    input logic [31:0] addr,
    output logic [31:0] instr
);

    logic [31:0] mem [1023:0]; //1024 word (32 bit) instructions 

    /*
        addr ...0000  ->  slot 0  =  mem[0]
        addr ...0100  ->  slot 1  =  mem[1]
        addr ...1000  ->  slot 2  =  mem[2]
        addr ...1100  ->  slot 3  =  mem[3]

        we wanna just remove the last two bits and change one hot encoding to decimal value to index on mem

        so instr[31:0] = if addr == 32'd0, mem[0] 
        else instr[31:0] = mem[hot-encoding of addr[31:2] to decimal]
    */

    //32'h00500093; //addi x1, x0, 5 (x1 = 5)

    always_comb begin
        if (addr == 32'd0) begin
            instr = mem[0];
        end else begin
            instr = mem[addr[31:2]];
        end

    end

endmodule

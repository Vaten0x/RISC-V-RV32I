module instr_mem(
    input logic [31:0] addr,
    output logic [31:0] instr
);

    logic [31:0] INSTR_RAM [1023:0]; //1024 word (32 bit) instructions 

    /*
        addr ...0000  ->  slot 0  =  INSTR_RAM[0]
        addr ...0100  ->  slot 1  =  INSTR_RAM[1]
        addr ...1000  ->  slot 2  =  INSTR_RAM[2]
        addr ...1100  ->  slot 3  =  INSTR_RAM[3]

        note that 2^10 is 1024, so we only need 10 bits of addr for INSTR_RAM indexing

        we wanna just remove the last two bits and use it to index it

        dropping the last two bits does the same effect as dividing by 4

        byte address 0  -> word 0
        byte address 4  -> word 1
        byte address 8  -> word 2
        byte address 12 -> word 3

        instr[31:0] = INSTR_RAM[addr[11:2]]
    */

    //for the sim, tb/cpu_top_tb.sv loads the program into INSTR_RAM (pick it with -testplusarg TEST_<name>)

    assign instr = INSTR_RAM[addr[11:2]];

endmodule

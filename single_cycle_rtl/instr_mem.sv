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

        instr[31:0] = INSTR_RAM[addr[11:2]]
    */

    //this is for the sim
    initial $readmemh("hex_files/program1.hex", INSTR_RAM);

    assign instr = INSTR_RAM[addr[11:2]];

endmodule

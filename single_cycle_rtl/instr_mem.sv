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

        we wanna just remove the last two bits and change one hot encoding to decimal value to index on mem

        so instr[31:0] = if addr == 32'd0, INSTR_RAM[0] 
        else instr[31:0] = INSTR_RAM[hot-encoding of addr[31:2] to decimal]
    */

    //Program 1:
    //32'h00500093; //addi x1, x0, 5 (x1 = 5)

    //this is for the sim
    initial $readmemh("C:\Users\renew\Downloads\vscode\RISC-V-RV32I\hex_files\program1.hex", INSTR_RAM);

    assign instr = INSTR_RAM[addr[31:2]];

endmodule

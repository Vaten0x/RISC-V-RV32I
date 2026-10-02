`define DATAWIDTH 16

module datapath(clk, readnum, vsel, loada, loadb, shift, asel, bsel, ALUop, loadc, loads, writenum, write, mdata, sximm8, PC, sximm5, status_out, datapath_out);

    input clk;
    input [2:0] readnum;
    input [1:0] vsel; // This was changed from lab5
    input loada;
    input loadb;
    input [1:0] shift;
    input asel;
    input bsel;
    input [1:0] ALUop;
    input loadc;
    input loads;
    input [2:0] writenum;
    input write;
    // input [`DATAWIDTH-1:0] datapath_in; // NOTE: this is changed to mdata

    output [`DATAWIDTH-1:0] datapath_out;
    output [2:0] status_out; // NOTE: Z_out was changed to status_out

// Lab 6 additions

    // Regfile Mux

    input [`DATAWIDTH-1:0] mdata; // output of memory block, lab 7 stuff, so for now assign all 0
    input [`DATAWIDTH-1:0] sximm8; // intermediate input, assume it is sign extended

    input [7:0] PC; // PC thing for lab 7, so for now assign all 0
    wire [`DATAWIDTH-1:0] zerosPlusPC; 
    assign zerosPlusPC = {{8{1'bx}},PC};

        // C is datapath_out

    wire [`DATAWIDTH-1:0] data_in; // data_in declaration was moved here

    // The follwing is the new mux, with the selecting selecting one of the 4 inputs in the order they are listed here from left to right
    Mux4in #(16) LAB6REGMUX (mdata,sximm8,zerosPlusPC,datapath_out,data_in,vsel);

    // Bin Changes
    input [`DATAWIDTH-1:0] sximm5; // I assume it is sign extended before going in

// Lab 5 stuff. Any changes have "//NOTE:"

    wire [`DATAWIDTH-1:0] out;
    
    wire [`DATAWIDTH-1:0] data_out;
    wire [`DATAWIDTH-1:0] sout;
    wire [`DATAWIDTH-1:0] loada_out;
    wire [`DATAWIDTH-1:0] in;
    wire [2:0] status;

    wire [`DATAWIDTH-1:0] Ain;
    wire [`DATAWIDTH-1:0] Bin;

    wire [`DATAWIDTH-1:0] R0,R1,R2,R3,R4,R5,R6,R7; // The following are the registers

    // RegisterFile LOGIC BLOCK 1 // NOTE: data_in is determined by LAB6REGMUX
    regfile REGFILE(data_in,writenum,write,readnum,clk,data_out);

    // loada LOGIC BLOCK 3
    vDFFE #(`DATAWIDTH) LOADA(clk,loada,data_out,loada_out);

    // loadb LOGIC BLOCK 4
    vDFFE #(`DATAWIDTH) LOADB(clk,loadb,data_out,in);

    // shifter LOGIC BLOCK 8
    shifter SHIFT(in, shift,sout);

    //NOTE: {11'b0},datapath_in[4:0] has been changed to sximm5
    // Mux LOGIC BLOCK 7 (sout and sximm5) 
    assign Bin = (bsel == 1'b0) ? sout : sximm5;

    // Mux LOGIC BLOCK 6 (loada_out and 16'b0)
    assign Ain = (asel == 1'b0) ? loada_out : 16'b0000000000000000;

    // ALU LOGIC BLOCK 2
    ALU ALU(Ain,Bin,ALUop,out,status);

    // status Flip flop LOGIC BLOCK 10
    vDFFE #(3) STATUS(clk,loads,status,status_out);

    // loadc LOGIC BLOCK 5
    vDFFE #(`DATAWIDTH) LOADC(clk,loadc,out, datapath_out);

endmodule

// takes in 2 bit select and arbitrary bit input
module Mux4in(in0,in1,in2,in3,out,sel);

  parameter inWidth = 16;
  input [inWidth-1:0] in0,in1,in2,in3;
  input [1:0] sel;
  output reg [inWidth-1:0] out;

  always @(*) begin
    case(sel)
      3'b00 : out = in0;
      3'b01 : out = in1;
      3'b10 : out = in2;
      3'b11 : out = in3;
      default out = {inWidth{1'bx}};
    endcase
  end

endmodule


`define DATAWIDTH 16

module regfile(data_in,writenum,write,readnum,clk,data_out);
  input [15:0] data_in;
  input [2:0] writenum, readnum;
  input write, clk;
  output [15:0] data_out;

  wire [7:0] decodedWriteNum;
  Dec #(3,8) DEC1 (writenum,decodedWriteNum); // Decodes 3 bit input for writenm into 8-bit one hot

  wire [7:0] doWeWrite; 
  assign doWeWrite = {8{write}}; // Makes an 8-bit bus, with all bits containing the write signal

  wire [7:0] whichRegisterToWrite;
  assign whichRegisterToWrite = doWeWrite & decodedWriteNum; // Makes an 8-bit bus that determines which register is being written to

  wire [`DATAWIDTH-1:0] R0,R1,R2,R3,R4,R5,R6,R7; // The following are the registers

  vDFFE #(`DATAWIDTH) REG0 (clk,whichRegisterToWrite[0],data_in,R0);
  vDFFE #(`DATAWIDTH) REG1 (clk,whichRegisterToWrite[1],data_in,R1);
  vDFFE #(`DATAWIDTH) REG2 (clk,whichRegisterToWrite[2],data_in,R2);
  vDFFE #(`DATAWIDTH) REG3 (clk,whichRegisterToWrite[3],data_in,R3);
  vDFFE #(`DATAWIDTH) REG4 (clk,whichRegisterToWrite[4],data_in,R4);
  vDFFE #(`DATAWIDTH) REG5 (clk,whichRegisterToWrite[5],data_in,R5);
  vDFFE #(`DATAWIDTH) REG6 (clk,whichRegisterToWrite[6],data_in,R6);
  vDFFE #(`DATAWIDTH) REG7 (clk,whichRegisterToWrite[7],data_in,R7);

  Mux8in #(`DATAWIDTH) OUTSEL (R0,R1,R2,R3,R4,R5,R6,R7,data_out,readnum); // The following outputs the register selected by readnum

endmodule

// a - binary input (n bits wide)
// b - one hot output (m bits wide)
module Dec(a, b) ;
  parameter n=2 ;
  parameter m=4 ;
  input [n-1:0] a ;
  output [m-1:0] b ;
  wire [m-1:0] b = 1 << a ;
endmodule

module vDFFE(clk,en,in,out);
  parameter n=1;
  input clk, en;
  input[n-1:0] in;
  output [n-1:0] out;
  reg [n-1:0] out;
  wire [n-1:0] nxtout;

  assign nxtout = en ? in : out;

  always @(posedge clk)
    out = nxtout;
endmodule

// takes in 3 bit select and arbitrary bit input
module Mux8in(in0,in1,in2,in3,in4,in5,in6,in7,out,sel);
  parameter inWidth = 16;
  input [inWidth-1:0] in0,in1,in2,in3,in4,in5,in6,in7;
  input [2:0] sel;
  output reg [inWidth-1:0] out;

  always @(*) begin
    case(sel)
      3'b000 : out = in0;
      3'b001 : out = in1;
      3'b010 : out = in2;
      3'b011 : out = in3;
      3'b100 : out = in4;
      3'b101 : out = in5;
      3'b110 : out = in6;
      3'b111 : out = in7;
      default out = {inWidth{1'bx}};
    endcase
  end

endmodule



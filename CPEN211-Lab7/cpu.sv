module cpu(clk,reset,mem_cmd,mem_addr,mdata,datapath_out);

  input clk, reset;

  // The following are changed from lab 6
  // input [15:0] in;
  // output [15:0] out;
  // output N, V, Z;
  // output w; // this is the done signal

  // LAB 7 ADDITIONS
  input [15:0] mdata; //For Stage 2, changed from read_data to mdata
  output [8:0] mem_addr;
  output [1:0] mem_cmd;
  output [15:0] datapath_out;

  // Instruction register
  wire load_ir;
  wire [15:0] instruction;
  vDFFE #(16) INSTR_REG(clk,load_ir,mdata,instruction);

  // Instruction Decoder
  wire [2:0] opcode   = instruction[15:13];
  wire [1:0] op       = instruction[12:11];
  wire [2:0] Rm       = instruction[2:0];
  wire [2:0] Rd       = instruction[7:5];
  wire [2:0] Rn       = instruction[10:8];
  wire [1:0] shift    = instruction[4:3];
  wire [7:0] imm8     = instruction[7:0];
  wire [4:0] imm5     = instruction[4:0];
  wire [1:0] ALUop    = instruction[12:11];

  wire [2:0] readWritenum;
  wire [2:0] nsel; // nsel is one hot
  Mux3in #(3) REG_SEL (Rm,Rd,Rn,nsel,readWritenum);

  wire [7:0] sx8 = imm8[7] ? 8'b11111111 : 8'b00000000;
  wire [10:0] sx5 = imm8[4] ? 11'b11111111111 : 11'b00000000000;

  wire [15:0] sximm8 = {sx8,imm8};
  wire [15:0] sximm5 = {sx5,imm5};

  // stateMachine
  wire [1:0] vsel; 
  wire loada;
  wire loadb;
  wire asel;
  wire bsel;
  wire loadc;
  wire loads;
  wire write;

    // lab 7 stuff
  wire load_pc;
  wire reset_pc;
  wire [1:0] mem_cmd;
  wire addr_sel;
  wire load_addr; // Stage 2 addition
  wire [8:0] data_addr; // Stage 2 addition

  stateMachine FSM (reset,clk,opcode,op,vsel,loada,loadb,asel,bsel,loadc,loads,write,nsel,load_pc,reset_pc,mem_cmd,addr_sel,load_ir,load_addr);
  
  // datapath
  wire [2:0] status_out; // idk what this is for now

    // Lab 7 inputs
  wire [8:0] PC; 

    // Lab 7 Additions
  datapath DP (clk, readWritenum, vsel, loada, loadb, shift, asel, bsel, ALUop, loadc, loads, readWritenum, write, mdata, sximm8, PC[7:0], sximm5, status_out, datapath_out);

  // PC
  wire [8:0] add_plus1, next_pc;

    // Adder block
  plus1 #(9) ADDER (PC,add_plus1);

    // reset MUX
  assign next_pc = reset_pc ? 9'b000000000 : add_plus1;

    // Actual Program counter
  vDFFE #(9) PROGRAMCOUNTER (clk,load_pc,next_pc,PC);

    // Data Address Register
  vDFFE #(9) DATAADDRREG (clk,load_addr,datapath_out[8:0],data_addr); //notice that it will just the bottom 9 bits of datapath_out

    // Address Select Mux
  assign mem_addr = addr_sel ? PC : data_addr; // not disconnected anymore, data_addr is the output of the data address register

endmodule

module Mux3in(in1,in2,in3,sel,out);

  parameter n = 3;
  input [n-1:0] in1;
  input [n-1:0] in2;
  input [n-1:0] in3;
  input [2:0] sel;
  output reg [n-1:0] out;

  // The following always block determines which output is selected
  always_comb begin
    casex (sel)
      3'b001 : out = in1;
      3'b010 : out = in2;
      3'b100 : out = in3;
      default: out = 3'bxxx;
    endcase
  end
  
endmodule

module plus1 (in,out);

  parameter n = 9;
  input [n-1:0] in;
  output [n-1:0] out;

  assign out = in+1'b1;

endmodule
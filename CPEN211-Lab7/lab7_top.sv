
////// NEED TO CHANGE TO LAB 7 STUFF

// MREAD State
`define MREAD 2'b11
`define MNONE 2'b00
`define MWRITE 2'b10
`define LED_OUT_ADDR 9'b100000000
`define SWITCH_IN_ADDR 9'b101000000

module lab7_top(KEY,SW,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);

  // file parameter
  parameter filename = "data.txt"; 

    //Memory 0: MOV R0, #8
    //Memory 1: LDR R0, [R0] // R0 = 0x140
    //Memory 2: LDR R2, [R0] // R2 = value on SW0 through Sw7 on DE1 - Soc
    //Memory 3: MOV R3, R2, LSL#1 //R3 = R2 << 1 (which is 2*R2)
    //Memory 4: MOV R1, #9
    //Memory 5: LDR R1, [R1] // R1 = 0x100
    //Memory 6: STR R3, [R1] // display the contents of R3 on red LEDs
    //Memory 7: HALT
    //Memory 8: 8 has 0x0140
    //Memory 9: 9 has 0x0100

  input [3:0] KEY;
  input [9:0] SW;
  output [9:0] LEDR;
  output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

  // input assignments
  wire clk = ~KEY[0];
  wire reset = ~KEY[1];

  // Stage 1
  wire [1:0] mem_cmd;
  wire [8:0] mem_addr; // last bit is for negative or smth idk
  reg [15:0] read_data;
  wire [15:0] write_data; // For Stage 2 (changed datapath_out -> write_data)
  wire [15:0] dout;

  // Stage 2
  wire write;

  // RAM
  RAM #(16,8,filename) MEM (.clk(clk),
          .read_address(mem_addr[7:0]),
          .write_address(mem_addr[7:0]),
          .write(write), // For Stage 2, changed from 1'b0 to write, check line 47 for more details
          .din(write_data), // For stage 2 changed to read_data
          .dout(dout) );

  // Tri-state Inverter block
  wire isMREAD;
  wire isMWRITE; // For Stage 2 
  wire isZero;

  equals #(2) MREADCHECK (mem_cmd, `MREAD, isMREAD);
  equals #(1) ZEROCHECK (mem_addr[8], 1'b0, isZero);
  equals #(2) MWRITECHECK (mem_cmd, `MWRITE, isMWRITE); // For Stage 2

  assign write = isMWRITE & isZero; //For Stage 2

  wire triStateTrigger = isMREAD & isZero;

  // CPU 
  cpu CPU (clk,reset,mem_cmd,mem_addr,read_data,write_data);

  // I/O 

    // Switch Inputs
  wire switchOn;
  switchIn SWITCHES (mem_cmd,mem_addr,switchOn);

    // LED Outputs
  wire load_LED;
  ledOut LEDS (mem_cmd,mem_addr,load_LED);

  vDFFE #(8) LEDREG (clk,load_LED,write_data[7:0],LEDR[7:0]);

  // read_data assignment
  always_comb begin
    casex({triStateTrigger,switchOn})
      2'b10 : read_data = dout;
      2'b01 : read_data = {{8{1'b0}},SW[7:0]};
      default : read_data = {8{1'bz}};
    endcase
  end

endmodule

// Equals Module
module equals (in1,in2,out);

  parameter n = 2;

  input [n-1:0] in1, in2;
  output reg out;

  // determines the equality of in1 and in2
  always_comb begin
    if (in1 === in2) begin
      out = 1'b1;
    end
    else begin
      out = 1'b0;
    end
  end

endmodule

// Determines the output for the LED
module ledOut (mem_cmd,mem_addr,load_LED);

  input [1:0] mem_cmd;
  input [8:0] mem_addr;

  output load_LED;

  wire isMWRITE, isLED;

  equals #(2) ISMWRITE (mem_cmd,`MWRITE,isMWRITE);

  equals #(9) ISLEDON (mem_addr,`LED_OUT_ADDR,isLED);

  assign load_LED = isMWRITE & isLED;

endmodule

module switchIn (mem_cmd,mem_addr,SWout);

  input [1:0] mem_cmd;
  input [8:0] mem_addr;
  output SWout;

  equals #(2) ISMREAD (mem_cmd,`MREAD,isMREAD);

  equals #(9) ISSWITCH (mem_addr,`SWITCH_IN_ADDR,isSWITCH);

  assign SWout = isMREAD & isSWITCH;

endmodule















































// INSTRUCTIONS:
//
// You can use this file to demo your Lab6 on your DE1-SoC.  
// 
// You will need to fill in the sseg module as by default it will just print
// F's on HEX0 through HEX3.  YOU SHOULD NOT need to change the signal names
// inside the lab6_top module because the auto-grader will assume the same
// interface.


// DE1-SOC INTERFACE SPECIFICATION for lab6_top.v code in this file:
//
// clk input to datpath has rising edge when KEY0 is *pressed* 
//
// HEX5 contains the status register output on the top (Z), middle (N) and
// bottom (V) segment.
//
// HEX3, HEX2, HEX1, HEX0 are wired to out which should show the contents
// of your register C.
//
// When SW[9] is set to 0, SW[7:0] changes the lower 8 bits of the 16-bit 
// input "in". LEDR[8:0] will show the upper 8-bits of 16-bit input "in".
//
// When SW[9] is set to 1, SW[7:0] changes the upper 8 bits of the 16-bit
// input "in". LEDR[8:0] will show the lower 8-bits of 16-bit input "in".
//
// The rising edge of clk occurs at the moment when you press KEY0.
// The input reset is 1 as long as you press (and hold) KEY1.
// The input s is 1 as long as you press (and hold) KEY2.
// The input load is 1 as long as you press (and hold) KEY3.

module lab6_top(KEY,SW,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,CLOCK_50);
  input [3:0] KEY;
  input [9:0] SW;
  output [9:0] LEDR; 
  output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  input CLOCK_50;

  wire [15:0] out, ir;
  input_iface IN(CLOCK_50, SW, ir, LEDR[7:0]);

  wire Z, N, V;
  cpu U( .clk   (~KEY[0]), // recall from Lab 4 that KEY0 is 1 when NOT pushed
         .reset (~KEY[1]), 
         .s     (~KEY[2]),
         .load  (~KEY[3]),
         .in    (ir),
         .out   (out),
         .Z     (Z),
         .N     (N),
         .V     (V),
         .w     (LEDR[9]) );

  assign HEX5[0] = ~Z;
  assign HEX5[6] = ~N;
  assign HEX5[3] = ~V;

  // fill in sseg to display 4-bits in hexidecimal 0,1,2...9,A,B,C,D,E,F
  sseg H0(out[3:0],   HEX0);
  sseg H1(out[7:4],   HEX1);
  sseg H2(out[11:8],  HEX2);
  sseg H3(out[15:12], HEX3);
  assign HEX4 = 7'b1111111;
  assign {HEX5[2:1],HEX5[5:4]} = 4'b1111; // disabled
  assign LEDR[8] = 1'b0;
endmodule

module input_iface(clk, SW, ir, LEDR);
  input clk;
  input [9:0] SW;
  output [15:0] ir;
  output [7:0] LEDR;
  wire sel_sw = SW[9];  
  wire [15:0] ir_next = sel_sw ? {SW[7:0],ir[7:0]} : {ir[15:8],SW[7:0]};
  vDFF #(16) REG(clk,ir_next,ir);
  assign LEDR = sel_sw ? ir[7:0] : ir[15:8];  
endmodule         

// module vDFF(clk,D,Q);
//   parameter n=1;
//   input clk;
//   input [n-1:0] D;
//   output [n-1:0] Q;
//   reg [n-1:0] Q;
//   always @(posedge clk)
//     Q <= D;
// endmodule

// The sseg module below can be used to display the value of datpath_out on
// the hex LEDS the input is a 4-bit value representing numbers between 0 and
// 15 the output is a 7-bit value that will print a hexadecimal digit.  You
// may want to look at the code in Figure 7.20 and 7.21 in Dally but note this
// code will not work with the DE1-SoC because the order of segments used in
// the book is not the same as on the DE1-SoC (see comments below).

module sseg(in,segs);

// Definitions for outputs
  `define H_0 7'b1000000
  `define H_1 7'b1111001
  `define H_2 7'b0100100
  `define H_3 7'b0110000
  `define H_4 7'b0011001
  `define H_5 7'b0010010
  `define H_6 7'b0000010
  `define H_7 7'b1111000
  `define H_8 7'b0000000
  `define H_9 7'b0011000
  `define H_A 7'b0001000
  `define H_b 7'b0000011
  `define H_C 7'b1000110
  `define H_d 7'b0100001
  `define H_E 7'b0000110
  `define H_F 7'b0001110

  input [3:0] in;
  output reg [6:0] segs;

  always @(*) begin
    case(in) 
      0  : segs = `H_0;
      1  : segs = `H_1;
      2  : segs = `H_2;
      3  : segs = `H_3;
      4  : segs = `H_4;
      5  : segs = `H_5;
      6  : segs = `H_6;
      7  : segs = `H_7;
      8  : segs = `H_8;
      9  : segs = `H_9;
      10 : segs = `H_A;
      11 : segs = `H_b;
      12 : segs = `H_C;
      13 : segs = `H_d;
      14 : segs = `H_E;
      15 : segs = `H_F;

    endcase

  end

  // NOTE: The code for sseg below is not complete: You can use your code from
  // Lab4 to fill this in or code from someone else's Lab4.  
  //
  // IMPORTANT:  If you *do* use someone else's Lab4 code for the seven
  // segment display you *need* to state the following three things in
  // a file README.txt that you submit with handin along with this code: 
  //
  //   1.  First and last name of student providing code
  //   2.  Student number of student providing code
  //   3.  Date and time that student provided you their code
  //
  // You must also (obviously!) have the other student's permission to use
  // their code.
  //
  // To do otherwise is considered plagiarism.
  //
  // One bit per segment. On the DE1-SoC a HEX segment is illuminated when
  // the input bit is 0. Bits 6543210 correspond to:
  //
  //    0000
  //   5    1
  //   5    1
  //    6666
  //   4    2
  //   4    2
  //    3333
  //
  // Decimal value | Hexadecimal symbol to render on (one) HEX display
  //             0 | 0
  //             1 | 1
  //             2 | 2
  //             3 | 3
  //             4 | 4
  //             5 | 5
  //             6 | 6
  //             7 | 7
  //             8 | 8
  //             9 | 9
  //            10 | A
  //            11 | b
  //            12 | C
  //            13 | d
  //            14 | E
  //            15 | F

endmodule

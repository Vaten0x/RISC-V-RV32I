
`define STW 6

// MREAD State
`define MREAD 2'b11
`define MNONE 2'b00
`define MWRITE 2'b10

// State Encodings
// `define WAIT 5'b00000          // Wait state NOTE is relplaced by RST, IF1, IF2, UPC

`define MVI1 6'b000000          // R[Rn] = sx(im8)

`define MVR1 6'b000001          // R[Rd] = sh_Rm
`define MVR2 6'b000010
`define MVR3 6'b000011

`define ADD1 6'b000100         // R[Rd]=R[Rn]+sh_Rm
`define ADD2 6'b000101
`define ADD3 6'b000110
`define ADD4 6'b000111

`define CMP1 6'b001000       // status=f(R[Rn]-sh_Rm)
`define CMP2 6'b001001
`define CMP3 6'b001010
`define CMP4 6'b001011

`define AND1 6'b001100        // R[Rd]=R[Rn]&sh_Rm
`define AND2 6'b001101
`define AND3 6'b001110
`define AND4 6'b001111

`define MVN1 6'b010000        // R[Rd]= ~sh_Rm
`define MVN2 6'b010001
`define MVN3 6'b010010

  // Lab 7 additions
`define RST  6'b010011
`define IF1  6'b010100
`define IF2  6'b010101
`define UPC  6'b010110
`define DEC  6'b010111 // Decoding state

`define HALT 6'b011000

`define LDR1 6'b011001
`define LDR2 6'b011010
`define LDR3 6'b011011
`define LDR4 6'b011100
`define LDR5 6'b100001

`define STR1 6'b011101
`define STR2 6'b011110
`define STR3 6'b011111
`define STR4 6'b100000
`define STR5 6'b100010

// Datapath Output Encodings
/////////////////////109876543210
`define WAIT_OUT 12'b001000000000 // for the RST, IF1, IF2, UPC

/////////////////////109876543210
`define MVI1_OUT 12'b100010000001 // write to Rn

/////////////////////109876543210
`define MVR1_OUT 12'b001000100000 // load Rm into b
`define MVR2_OUT 12'b001000010100 // make it go to datapath_out by adding value with 0 and put to out
`define MVR3_OUT 12'b0010110000001 // write value of datapath_out to Rd

/////////////////////109876543210
`define ADD1_OUT 12'b100001000000 // load Rn onto a
`define ADD2_OUT 12'b001000100000 // load Rm onto b
`define ADD3_OUT 12'b001000000100 // add Rm and Rn together and put to out
`define ADD4_OUT 12'b010110000001 // write value of datapath_out to Rd

/////////////////////109876543210
`define CMP1_OUT 12'b100001000000 // load Rn onto a
`define CMP2_OUT 12'b001000100000 // load Rm onto b
`define CMP3_OUT 12'b001000000110 // update status and datapath_out

/////////////////////109876543210
`define AND1_OUT 12'b100001000000 // load Rn onto a
`define AND2_OUT 12'b001000100000 // load Rm onto b
`define AND3_OUT 12'b001000000100 // and Rm and Rn together and put to out
`define AND4_OUT 12'b010110000001 // write value of datapath_out to Rd

/////////////////////109876543210
`define MVN1_OUT 12'b001000100000 // load Rm into b
`define MVN2_OUT 12'b001000010100 // perform not B and put to out
`define MVN3_OUT 12'b010110000001 // write value of datapath_out to Rd

// Lab 7 additional commands

/////////////////////109876543210
`define LDR1_OUT 12'b100001000000 // load Rn onto a
`define LDR2_OUT 12'b001000001100 // perform Rn + simxx5 and update datapath_out
`define LDR3_OUT 12'b001000000000 // do nothing for datapath
`define LDR4_OUT 12'b001000000000 // do nothing for datapath, wait for mdata to have correct info
`define LDR5_OUT 12'b010000000001 // have mdata go into datapath and write to register rd

/////////////////////109876543210
`define STR1_OUT 12'b100001000000 // load Rn into a
`define STR2_OUT 12'b010000101100 // perform Rn + simxx5 and update datapath_out, as well as load Rd into b
`define STR3_OUT 12'b001000010100 // load Rd onto datapath out, with loada being 1 to pass 0 into adder
`define STR4_OUT 12'b001000000000 // do nothing
`define STR5_OUT 12'b001000000000 // do nothing

// PC Control Outputs //////////////////NEEED TO ADD [0] bit to be load_addr
///////////////////6543210 load_pc, reset_pc, mem_cmd, addr_sel, load_ir, load_addr
`define RST_OUT 7'b1100000  // reset_pc and load_pc are 1
`define IF1_OUT 7'b0011100  // mem_cmd = `MREAD, addr_sel = 1
`define IF2_OUT 7'b0011110  // mem_cmd = `MREAD, addr_sel = 1, load_ir = 1
`define UPC_OUT 7'b1011100  // load_pc is 1, addr_sel = 1,
`define CLC_OUT 7'b0000000  // PC control outputs for computation i.e. do nothing
`define HLT_OUT 7'b0000000  // PC control outputs for halt

`define LD1_OUT 7'b0000000 // Do nothing
`define LD2_OUT 7'b0000000 // Do nothing
`define LD3_OUT 7'b0000001 // load address onto Data Adress register, with load_addr = 1 so it goes to mem_addr
`define LD4_OUT 7'b0011000 // mem_cmd = `MREAD
`define LD5_OUT 7'b0011000 // Do nothing

`define ST1_OUT 7'b0000000 // Do nothing
`define ST2_OUT 7'b0000000 // Do nothing
`define ST3_OUT 7'b0000001 // load Rn + sximm5 onto Data Adress register, with load_addr = 1 so it goes to mem_addr
`define ST4_OUT 7'b0010000 // wait for mem_adr to update, with mem_cmd = `MWRITE
`define ST5_OUT 7'b0010000 // write Rd into memory, with addr_sel = 0 so it goes to mem_addr, with mem_cmd = `MWRITE

module stateMachine(reset,clk,opcode,op,vsel,loada,loadb,asel,bsel,loadc,loads,write,nsel,load_pc,reset_pc,mem_cmd,addr_sel,load_ir,load_addr);

  // machine control signals // NOTE: s is removed
  input reset, clk; 

  // Instruction signals
  input [2:0] opcode; 
  input [1:0] op; 

  // State Machine outputs / control signals for datapath
  output [1:0] vsel; 
  output loada;
  output loadb;
  output asel;
  output bsel;
  output loadc;
  output loads;
  output write;

  // done flag
  // output w; // NOTE: is removed for labv 7

  // Rn, Rd, Rm mux controller for instruction decoder. It is one-hot
  output [2:0] nsel;

///////////////////////////////////////////////
// Lab 7 Additional Outputs
  output load_pc;
  output reset_pc;
  output [1:0] mem_cmd;
  output addr_sel;
  output load_ir;
  output load_addr; // Stage 2 addition

///////////////////////////////////////////////

  // The concatenation of the PC control outputs
  reg [6:0] pc_control;

  assign load_pc        = pc_control[6];
  assign reset_pc       = pc_control[5];
  assign mem_cmd        = pc_control[4:3];
  assign addr_sel       = pc_control[2];
  assign load_ir        = pc_control[1];
  assign load_addr      = pc_control[0];

  // the concatenation of all datapath control signals
  reg [11:0] concatOut;

  // the assignment of concatOut to the respective outputs
  assign nsel           = concatOut[11:9];
  assign vsel           = concatOut[8:7]; 
  assign loada          = concatOut[6];
  assign loadb          = concatOut[5];
  assign asel           = concatOut[4];
  assign bsel           = concatOut[3];
  assign loadc          = concatOut[2];
  assign loads          = concatOut[1];
  assign write          = concatOut[0];

  // vDFF and reset
  reg [`STW-1:0] nxt;
  wire [`STW-1:0] rst_nxt_state,state;
  
  assign rst_nxt_state = reset ? `RST : nxt; // will go to wait state when reset is on

  vDFF #(`STW) DFF(clk,rst_nxt_state,state);

  // State transitions and output
  always_comb begin 
    casex({state,opcode,op})

      // Reset, IF1, IF2, UPC states
      {`RST,3'bxxx,2'bxx} : {nxt,concatOut,pc_control} = {`IF1,`WAIT_OUT,`RST_OUT};
      {`IF1,3'bxxx,2'bxx} : {nxt,concatOut,pc_control} = {`IF2,`WAIT_OUT,`IF1_OUT};
      {`IF2,3'bxxx,2'bxx} : {nxt,concatOut,pc_control} = {`UPC,`WAIT_OUT,`IF2_OUT};
      {`UPC,3'bxxx,2'bxx} : {nxt,concatOut,pc_control} = {`DEC,`WAIT_OUT,`UPC_OUT};

      // Decoding state
      {`DEC,3'b110,2'b10} : begin 
        if (opcode !== 3'b110) begin // If statement is needed b/c `DEC,3'bxxx,2'bxx matches to this case
          {nxt,concatOut,pc_control} = {`DEC,`WAIT_OUT,`CLC_OUT}; // assume it stays at DEC for invalid inputs
        end 
        else begin
          {nxt,concatOut,pc_control} = {`MVI1,`WAIT_OUT,`CLC_OUT}; // perform MOV immediate val
        end
      end
      {`DEC,3'b110,2'b00} : {nxt,concatOut,pc_control} = {`MVR1,`WAIT_OUT,`CLC_OUT}; // perform MOV register
      {`DEC,3'b101,2'b00} : {nxt,concatOut,pc_control} = {`ADD1,`WAIT_OUT,`CLC_OUT}; // perform ADD
      {`DEC,3'b101,2'b01} : {nxt,concatOut,pc_control} = {`CMP1,`WAIT_OUT,`CLC_OUT}; // perform CMP
      {`DEC,3'b101,2'b10} : {nxt,concatOut,pc_control} = {`AND1,`WAIT_OUT,`CLC_OUT}; // perform AND
      {`DEC,3'b101,2'b11} : {nxt,concatOut,pc_control} = {`MVN1,`WAIT_OUT,`CLC_OUT}; // perform MVN

      // Lab 7 additional commands
      {`DEC,3'b011,2'b00} : {nxt,concatOut,pc_control} = {`LDR1,`WAIT_OUT,`CLC_OUT}; // Perform LDR
      {`DEC,3'b100,2'b00} : {nxt,concatOut,pc_control} = {`STR1,`WAIT_OUT,`CLC_OUT}; // Perform STR
      {`DEC,3'b111,2'b00} : {nxt,concatOut,pc_control} = {`HALT,`WAIT_OUT,`HLT_OUT}; // go to HALT

      // If non x invalid command, go back to decode
      {`DEC,3'bxxx,2'bxx} : {nxt,concatOut,pc_control} = {`DEC,`WAIT_OUT,`CLC_OUT}; // assume it stays at DEC for invalid inputs

      ///////////////////////////////////////////////////////////////////

      // MOV immediate val
      {`MVI1,3'bxxx,2'bxx} : {nxt,concatOut,pc_control} = {`IF1,`MVI1_OUT,`CLC_OUT}; // movs immediate to Rn

      // MOV register
      {`MVR1,3'bxxx,2'bxx} : {nxt,concatOut,pc_control} = {`MVR2,`MVR1_OUT,`CLC_OUT};
      {`MVR2,3'bxxx,2'bxx} : {nxt,concatOut,pc_control} = {`MVR3,`MVR2_OUT,`CLC_OUT};
      {`MVR3,3'bxxx,2'bxx} : {nxt,concatOut,pc_control} = {`IF1,`MVR3_OUT,`CLC_OUT};

      // ADD
      {`ADD1,3'bxxx,2'bxx} : {nxt,concatOut,pc_control} = {`ADD2,`ADD1_OUT,`CLC_OUT};
      {`ADD2,3'bxxx,2'bxx} : {nxt,concatOut,pc_control} = {`ADD3,`ADD2_OUT,`CLC_OUT};
      {`ADD3,3'bxxx,2'bxx} : {nxt,concatOut,pc_control} = {`ADD4,`ADD3_OUT,`CLC_OUT};
      {`ADD4,3'bxxx,2'bxx} : {nxt,concatOut,pc_control} = {`IF1,`ADD4_OUT,`CLC_OUT};

      // CMP
      {`CMP1,3'bxxx,2'bxx} : {nxt,concatOut,pc_control} = {`CMP2,`CMP1_OUT,`CLC_OUT};
      {`CMP2,3'bxxx,2'bxx} : {nxt,concatOut,pc_control} = {`CMP3,`CMP2_OUT,`CLC_OUT};
      {`CMP3,3'bxxx,2'bxx} : {nxt,concatOut,pc_control} = {`IF1,`CMP3_OUT,`CLC_OUT};

      // AND
      {`AND1,3'bxxx,2'bxx} : {nxt,concatOut,pc_control} = {`AND2,`ADD1_OUT,`CLC_OUT};
      {`AND2,3'bxxx,2'bxx} : {nxt,concatOut,pc_control} = {`AND3,`ADD2_OUT,`CLC_OUT};
      {`AND3,3'bxxx,2'bxx} : {nxt,concatOut,pc_control} = {`AND4,`ADD3_OUT,`CLC_OUT};
      {`AND4,3'bxxx,2'bxx} : {nxt,concatOut,pc_control} = {`IF1,`ADD4_OUT,`CLC_OUT};

      // MVN
      {`MVN1,3'bxxx,2'bxx} : {nxt,concatOut,pc_control} = {`MVN2,`MVN1_OUT,`CLC_OUT};
      {`MVN2,3'bxxx,2'bxx} : {nxt,concatOut,pc_control} = {`MVN3,`MVN2_OUT,`CLC_OUT};
      {`MVN3,3'bxxx,2'bxx} : {nxt,concatOut,pc_control} = {`IF1,`MVN3_OUT,`CLC_OUT};

      ///////////////////////////////////////////////////////////
      // Lab 7 additional commands

      // LDR
      {`LDR1,3'bxxx,2'bxx} : {nxt,concatOut,pc_control} = {`LDR2,`LDR1_OUT,`LD1_OUT};
      {`LDR2,3'bxxx,2'bxx} : {nxt,concatOut,pc_control} = {`LDR3,`LDR2_OUT,`LD2_OUT};
      {`LDR3,3'bxxx,2'bxx} : {nxt,concatOut,pc_control} = {`LDR4,`LDR3_OUT,`LD3_OUT};
      {`LDR4,3'bxxx,2'bxx} : {nxt,concatOut,pc_control} = {`LDR5,`LDR4_OUT,`LD4_OUT};
      {`LDR5,3'bxxx,2'bxx} : {nxt,concatOut,pc_control} = {`IF1,`LDR5_OUT,`LD5_OUT};

      // STR
      {`STR1,3'bxxx,2'bxx} : {nxt,concatOut,pc_control} = {`STR2,`STR1_OUT,`ST1_OUT};
      {`STR2,3'bxxx,2'bxx} : {nxt,concatOut,pc_control} = {`STR3,`STR2_OUT,`ST2_OUT};
      {`STR3,3'bxxx,2'bxx} : {nxt,concatOut,pc_control} = {`STR4,`STR3_OUT,`ST3_OUT};
      {`STR4,3'bxxx,2'bxx} : {nxt,concatOut,pc_control} = {`STR5,`STR4_OUT,`ST4_OUT};
      {`STR5,3'bxxx,2'bxx} : {nxt,concatOut,pc_control} = {`IF1,`STR5_OUT,`ST5_OUT};

      // HALT
      {`HALT,3'bxxx,2'bxx} : {nxt,concatOut,pc_control} = {`HALT,`WAIT_OUT,`CLC_OUT};

      default: {nxt,concatOut,pc_control} = {25{1'bx}}; // default for debugging

    endcase
  end
  

endmodule

module vDFF(clk,in,out);
  parameter n=1;
  input clk;
  input[n-1:0] in;
  output [n-1:0] out;
  reg [n-1:0] out;
  always @(posedge clk)
    out = in;
endmodule
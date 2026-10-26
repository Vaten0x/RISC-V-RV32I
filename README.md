# RISC-V-RV32I

Using Vivado Simulator v2025.2 with Spike

# To run cpu_top_tb test and open the sim
xvlog -sv single_cycle_rtl/pkg/rv32i_pkg.sv single_cycle_rtl/alu.sv single_cycle_rtl/decoder.sv single_cycle_rtl/imm_gen.sv single_cycle_rtl/pc.sv single_cycle_rtl/instr_mem.sv single_cycle_rtl/regfile.sv single_cycle_rtl/cpu_top.sv tb/cpu_top_tb.sv

xelab cpu_top_tb -debug typical -s cpu_sim

# To test tooling with UVM, try running hello_uvm.sv inside /tb:
xvlog -sv -L uvm tb/hello_uvm.sv
xelab -L uvm tb_top -s hello_sim
xsim hello_sim -R

# To run ALU test
xvlog -sv rtl/alu.sv tb/alu_tb.sv
xelab alu_tb -s alu_sim
xsim alu_sim -R

# To run cpu_top_tb test for tests/alu_ops.s
xvlog -sv single_cycle_rtl/pkg/rv32i_pkg.sv single_cycle_rtl/alu.sv single_cycle_rtl/decoder.sv single_cycle_rtl/imm_gen.sv single_cycle_rtl/pc.sv single_cycle_rtl/instr_mem.sv single_cycle_rtl/regfile.sv single_cycle_rtl/cpu_top.sv tb/cpu_top_tb.sv
xelab cpu_top_tb -debug typical -s cpu_sim
xsim cpu_sim -R

waveform is:
xsim cpu_sim -gui

![Vivado Waveform](image-1.png)

# Open waveform with XSIm with ALU example
In the xelab step, add `-debug typical` flag
Then, xsim alu_sim -gui

# The spec
https://docs.riscv.org/reference/isa/v20260120/unpriv/unpriv-index.html

# RISCV RV32I Instructions
https://www.cs.unh.edu/~pjh/courses/cs520/15spr/riscv-rv32i-instructions.pdf

# Instructions Finished:
Decoded in `single_cycle_rtl/decoder.sv`. `tests/alu_ops.s` passes in `cpu_top_tb` and covers add, sub, slt, sltu, addi, xori, slli, srli, srai. Not yet run in a test: sll, xor, srl, sra, or, and, slti, sltiu, ori, andi.

R-type (register-register):
- [x] add
- [x] sub
- [x] sll
- [x] slt
- [x] sltu
- [x] xor
- [x] srl
- [x] sra
- [x] or
- [x] and

I-type (register-immediate):
- [x] addi
- [x] slti
- [x] sltiu
- [x] xori
- [x] ori
- [x] andi
- [x] slli
- [x] srli
- [x] srai

# Instructions To Do:
Loads (I-type):
- [ ] lb
- [ ] lh
- [ ] lw
- [ ] lbu
- [ ] lhu

Stores (S-type):
- [ ] sb
- [ ] sh
- [ ] sw

Branches (B-type):
- [ ] beq
- [ ] bne
- [ ] blt
- [ ] bge
- [ ] bltu
- [ ] bgeu

Jumps:
- [ ] jal (J-type)
- [ ] jalr (I-type)

Upper immediate (U-type):
- [ ] lui
- [ ] auipc

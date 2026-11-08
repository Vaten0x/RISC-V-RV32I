# RISC-V-RV32I

Using Vivado Simulator v2025.2 with Spike

## Scope
This project targets the unprivileged RV32I ISA only. Not planned:
- Privileged features (CSRs, traps, interrupts)
- FENCE, ECALL, EBREAK
- Byte/halfword loads and stores (LB, LH, LBU, LHU, SB, SH). Only LW/SW are supported.

# To run cpu_top_tb test and open the sim
xvlog -sv single_cycle_rtl/pkg/rv32i_pkg.sv single_cycle_rtl/alu.sv single_cycle_rtl/decoder.sv single_cycle_rtl/imm_gen.sv single_cycle_rtl/pc.sv single_cycle_rtl/instr_mem.sv single_cycle_rtl/regfile.sv single_cycle_rtl/data_mem.sv single_cycle_rtl/mux4to1.sv single_cycle_rtl/branch_decoder.sv single_cycle_rtl/cpu_top.sv tb/cpu_top_tb.sv

xelab cpu_top_tb -debug typical -s cpu_sim

# To test tooling with UVM, try running hello_uvm.sv inside /tb:
xvlog -sv -L uvm tb/hello_uvm.sv
xelab -L uvm tb_top -s hello_sim
xsim hello_sim -R

# To run ALU test
xvlog -sv rtl/alu.sv tb/alu_tb.sv
xelab alu_tb -s alu_sim
xsim alu_sim -R

# To run cpu_top_tb on one riscv-tests program (here: add)
xvlog -sv single_cycle_rtl/pkg/rv32i_pkg.sv single_cycle_rtl/alu.sv single_cycle_rtl/decoder.sv single_cycle_rtl/imm_gen.sv single_cycle_rtl/pc.sv single_cycle_rtl/instr_mem.sv single_cycle_rtl/regfile.sv single_cycle_rtl/data_mem.sv single_cycle_rtl/mux4to1.sv single_cycle_rtl/branch_decoder.sv single_cycle_rtl/cpu_top.sv tb/cpu_top_tb.sv
xelab cpu_top_tb -debug typical -s cpu_sim
xsim cpu_sim -R -testplusarg TEST_add

waveform is:
xsim cpu_sim -gui -testplusarg TEST_add

# To rebuild one test's hex files (WSL, here: lw; only lw and sw have a _data.hex)
mkdir -p build
riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles -I tests/riscv-tests/env/p -I tests/riscv-tests/isa/macros/scalar -T tests/riscv-tests/env/p/link.ld -o build/lw.elf tests/riscv-tests/isa/rv32ui/lw.S
riscv64-unknown-elf-objcopy -O verilog --verilog-data-width=4 -j .text.init --change-addresses -0x80000000 build/lw.elf hex_files/lw.hex
riscv64-unknown-elf-objcopy -O verilog --verilog-data-width=4 -j .data --change-addresses -0x80002000 build/lw.elf hex_files/lw_data.hex

![Vivado Waveform](image-1.png)

# Open waveform with XSIm with ALU example
In the xelab step, add `-debug typical` flag
Then, xsim alu_sim -gui

# The spec
https://docs.riscv.org/reference/isa/v20260120/unpriv/unpriv-index.html

# RISCV RV32I Instructions
https://www.cs.unh.edu/~pjh/courses/cs520/15spr/riscv-rv32i-instructions.pdf

# Instructions Finished:
Decoded in `single_cycle_rtl/decoder.sv`. Verified with the official [riscv-tests](https://github.com/riscv-software-src/riscv-tests) rv32ui suite (sub-word load/store tests excluded), all 32 passing.

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
- [x] lw
- [ ] lbu
- [ ] lhu

Stores (S-type):
- [ ] sb
- [ ] sh
- [x] sw

Branches (B-type):
- [x] beq
- [x] bne
- [x] blt
- [x] bge
- [x ] bltu
- [x] bgeu

Jumps:
- [x] jal (J-type)
- [x] jalr (I-type)

Upper immediate (U-type):
- [x] lui
- [x] auipc

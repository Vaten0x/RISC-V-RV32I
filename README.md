# RISC-V-RV32I

Using Vivado Simulator v2025.2 with Spike

# To run cpu_top_tb test and open the sim
xvlog -sv single_cycle_rtl/pkg/rv32i_pkg.sv single_cycle_rtl/*.sv tb/cpu_top_tb.sv
xelab cpu_top_tb -debug typical -s cpu_sim
xsim cpu_sim -gui

# To test tooling with UVM, try running hello_uvm.sv inside /tb:
xvlog -sv -L uvm tb/hello_uvm.sv
xelab -L uvm tb_top -s hello_sim
xsim hello_sim -R

# To run ALU test
xvlog -sv rtl/alu.sv tb/alu_tb.sv
xelab alu_tb -s alu_sim
xsim alu_sim -R

# Open waveform with XSIm with ALU example
In the xelab step, add `-debug typical` flag
Then, xsim alu_sim -gui

# The spec
https://docs.riscv.org/reference/isa/v20260120/unpriv/unpriv-index.html
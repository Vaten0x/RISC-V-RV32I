# RISC-V-RV32I

Using Vivado Simulator v2025.2 with Spike

# To test tooling with UVM, try running hello_uvm.sv inside /tb:
xvlog -sv -L uvm tb/hello_uvm.sv
xelab -L uvm tb_top -s hello_sim
xsim hello_sim -R
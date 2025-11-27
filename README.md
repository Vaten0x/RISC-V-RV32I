# RISC-V-RV32I

RISC-V with RV32I base instruction set (subset without memory loads/stores initially)

5-stage pipeline: IF → ID → EX → MEM → WB

(Optional) Custom servo extension on top of RV32I with AXI (to connect with the FPGA Bionic Robot Arm Project)

What I'm Skipping:

Load/store instr
Memory ordering instr
Privileged mode instr
CSR instr
interrupts/executions
hazard detection unit
forward/bypassing unit


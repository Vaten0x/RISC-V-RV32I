import uvm_pkg::*;
`include "uvm_macros.svh"

class hello_test extends uvm_test;
    `uvm_component_utils(hello_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task run_phase (uvm_phase phase);
        `uvm_info (get_name(), $sformatf("Hello UVM!"), UVM_LOW)
    endtask
endclass

module tb_top;
    initial run_test("hello_test");
endmodule

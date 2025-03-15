module dut (
    input logic input_data,
    input logic input_clk,
    output logic output_data,
    output logic output_clk
);
import uvm_pkg::*;
`include "uvm_macros.svh"
import rjptl_pkg_dut::*;

assign output_clk = input_clk;
assign output_data = input_data;

initial begin
    `uvm_info("dut", "Hello, I'm dut.", UVM_LOW)
    `uvm_info("dut", $sformatf("Checking enum of DUT, DUT_CHK: value: 'h%h", DUT_CHK), UVM_LOW)
end
endmodule
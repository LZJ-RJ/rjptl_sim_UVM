`timescale 1ps/1ps

module rj_top;

import uvm_pkg::*; // for run_test
`include "uvm_macros.svh"
import rjptl_pkg::*;

initial begin
    run_test("super_like_rj_test_case");
    // or use this way to run a difference test:
    //   +UVM_TESTNAME=YOUR_uvm_test
end

endmodule
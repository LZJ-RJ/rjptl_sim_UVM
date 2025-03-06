`timescale 1ps/1ps

module rj_top;

import uvm_pkg::*; // for run_test
`include "uvm_macros.svh"
import rjptl_pkg::*;

rj_if my_intf();
initial begin
    uvm_config_db #(virtual rj_if)::set(uvm_root::get(), "*.env01.i_agent", "rj_tx_if", my_intf);
    uvm_config_db #(virtual rj_if)::set(uvm_root::get(), "*.env01.o_agent", "rj_rx_if", my_intf);
end

initial begin
    // Gen clock on the interface
    // If clk_period is too short/fast, would let your simulation has reached the iteration limit: ** Error (suppressible): (vsim-3601) Iteration limit 10000000 reached at time 10 ps.
    static      int  clk_period = 100;
    static      real clk_h      = clk_period / 2;
    static      real clk_l      = clk_period - clk_h;
    if ($test$plusargs("test_runtime")) begin
        $display($sformatf("test runtime argument successfully"));
    end
    if ($value$plusargs("clk_period=%d", clk_period)) begin
        $display($sformatf("modify clk_period(=%0d) value by runtime argument successfully", clk_period));
    end
    clk_h      = clk_period / 2;
    clk_l      = clk_period - clk_h;
    forever my_intf.gen_tx_clk(clk_h, clk_l);
end

initial begin
    run_test("super_like_rj_test_case");
    // or use this way to run a difference test:
    //   +UVM_TESTNAME=YOUR_uvm_test
end

// dump waveform
initial begin
    `ifdef RJ_DUMP_VCD
        $dumpfile("rj_top.vcd");
        $dumpvars(0, rj_top);
        $dumpvars(0, rj_top.my_intf);
        $dumpon;
    `endif
end

endmodule
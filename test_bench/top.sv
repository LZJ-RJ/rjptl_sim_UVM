`timescale 1ps/1ps

module rj_top;

import uvm_pkg::*; // for run_test
`include "uvm_macros.svh"
import rjptl_pkg::*;

rj_intf_tx my_intf_tx();
rj_intf_rx my_intf_rx();

dut dut01 (
    .input_data(my_intf_tx.rj_lane[0]),
    .input_clk(my_intf_tx.rj_lane[1]),
    .output_data(my_intf_rx.rj_lane[0]),
    .output_clk(my_intf_rx.rj_lane[1])
);

initial begin
    uvm_config_db #(virtual rj_intf_tx)::set(uvm_root::get(), "*.env01.i_agent", "rj_intf_tx", my_intf_tx);
    uvm_config_db #(virtual rj_intf_rx)::set(uvm_root::get(), "*.env01.o_agent", "rj_intf_rx", my_intf_rx);
end

initial begin
    // Gen clock on the interface
    // If clk_period is too short/fast, would let your simulation has reached the iteration limit: ** Error (suppressible): (vsim-3601) Iteration limit 10000000 reached at time 10 ps.
    static      int  clk_period = 100;
    static      real clk_h      = clk_period / 2;
    static      real clk_l      = clk_period - clk_h;
    `uvm_info("top", "Hello, I'm top.", UVM_LOW)
    if ($test$plusargs("test_runtime")) begin
        `uvm_info("top", "test runtime argument successfully", UVM_LOW)
    end
    if ($value$plusargs("clk_period=%d", clk_period)) begin
        `uvm_info("top", $sformatf("modify clk_period(=%0d) value by runtime argument successfully", clk_period), UVM_LOW)
    end
    clk_h      = clk_period / 2;
    clk_l      = clk_period - clk_h;
    fork
        forever my_intf_tx.gen_tx_clk(clk_h, clk_l);
    join_none
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
        $dumpvars(0, rj_top.my_intf_tx);
        $dumpvars(0, rj_top.my_intf_rx);
        $dumpon;
    `endif
end

endmodule
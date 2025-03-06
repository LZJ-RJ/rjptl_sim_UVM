`timescale 1ps/1ps

package rjptl_pkg;

// Part 1 - Official UVM
import uvm_pkg::*;
`include "uvm_macros.svh"

// Part 2 - define class early to avoid compilation error
typedef class rj_transaction;
typedef class rj_env;
typedef class rj_agent;
typedef class rj_sequence;
typedef class rj_sequencer;
typedef class rj_driver;
typedef class rj_monitor;
typedef class rj_scoreboard;
typedef class rj_packet;

// Part 3 - includes all base files
`include "enum.svh"
`include "packet.sv"

`include "transaction.sv"
`include "env.sv"
`include "agent.sv"
`include "sequence.sv"
`include "sequencer.sv"

`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"

// Part 4 - Include all "uvm_test" and "uvm_sequence" 
`include "seq_test_lib.svh"

endpackage

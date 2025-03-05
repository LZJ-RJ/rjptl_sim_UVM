class rj_sequencer extends uvm_sequencer #(rj_transaction);
    `uvm_component_utils(rj_sequencer)
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task main_phase(uvm_phase phase);
    endtask
endclass
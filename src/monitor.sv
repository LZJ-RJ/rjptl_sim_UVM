class rj_monitor extends uvm_monitor;
    `uvm_component_utils(rj_monitor)
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction
endclass
class rj_base_test extends uvm_test;
    `uvm_component_utils(rj_base_test)

    rj_env env01;
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env01 = rj_env::type_id::create("env01", this);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
    endtask
endclass
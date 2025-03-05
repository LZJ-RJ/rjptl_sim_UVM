class super_like_rj_test_case extends rj_base_test;
    `uvm_component_utils(super_like_rj_test_case)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        uvm_config_db#(uvm_object_wrapper)::set(this,
            "env01.i_agent.seqr.main_phase",
            "default_sequence",
            super_like_rj_seq::type_id::get());
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        // `uvm_do(seq)
        `uvm_info("TEST", "Test is running...", UVM_LOW) // This is same as the function below.
        // uvm_report_info("TEST", "Test is running...", UVM_LOW);
    endtask
endclass
class rj_agent extends uvm_agent;
    `uvm_component_utils(rj_agent)

    rj_driver drv;
    rj_monitor mon;
    rj_sequencer seqr;
//     uvm_active_passive_enum is_active=UVM_ACTIVE; // super class has already defaultly set it.

//     rj_config cfg;
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        bit cfg_db_res;
        super.build_phase(phase);
        cfg_db_res = uvm_config_db#(uvm_active_passive_enum)::get(this, "", "is_active", is_active);
        if (!cfg_db_res) `uvm_error("rj_agent", "Getting uvm_config_db ERROR");

        mon = rj_monitor::type_id::create("mon", this);
        if (is_active == UVM_ACTIVE) begin
            drv = rj_driver::type_id::create("drv", this);
            seqr = rj_sequencer::type_id::create("seqr", this);
        end
        // cfg = rj_config::type_id::create("cfg", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        if (is_active == UVM_ACTIVE)
            drv.seq_item_port.connect(seqr.seq_item_export);
    endfunction
endclass
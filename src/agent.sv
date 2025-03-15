class rj_agent extends uvm_agent;
    `uvm_component_utils(rj_agent)

    rj_driver drv;
    rj_monitor mon;
    rj_sequencer seqr;
    virtual rj_intf_tx my_intf_tx;
    virtual rj_intf_rx my_intf_rx;
//     uvm_active_passive_enum is_active=UVM_ACTIVE; // super class has already defaultly set it.

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        bit cfg_db_res;
        super.build_phase(phase);
        cfg_db_res = uvm_config_db#(uvm_active_passive_enum)::get(this, "", "is_active", is_active);
        if (!cfg_db_res) `uvm_error("rj_agent", "Getting uvm_config_db ERROR");

        if (is_active == UVM_ACTIVE) begin
            drv = rj_driver::type_id::create("drv", this);
            seqr = rj_sequencer::type_id::create("seqr", this);
            mon = rj_monitor::type_id::create("mon_tx", this);
            void'(uvm_config_db#(virtual rj_intf_tx)::get(this, "", "rj_intf_tx", my_intf_tx));
            drv.assign_vi(my_intf_tx);
            mon.is_tx = 1;
            mon.assign_vi_tx(my_intf_tx);
        end else begin
            mon = rj_monitor::type_id::create("mon_rx", this);
            void'(uvm_config_db#(virtual rj_intf_rx)::get(this, "", "rj_intf_rx", my_intf_rx));
            mon.assign_vi_rx(my_intf_rx);
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        if (is_active == UVM_ACTIVE)
            drv.seq_item_port.connect(seqr.seq_item_export);
    endfunction
endclass
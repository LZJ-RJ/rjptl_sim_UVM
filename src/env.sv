class rj_env extends uvm_env;
    `uvm_component_utils(rj_env)
    rj_agent i_agent;
    rj_agent o_agent;
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        i_agent = rj_agent::type_id::create("i_agent", this);
        o_agent = rj_agent::type_id::create("o_agent", this);
        uvm_config_db#(uvm_active_passive_enum)::set(this, "i_agent", "is_active", UVM_ACTIVE);
        uvm_config_db#(uvm_active_passive_enum)::set(this, "o_agent", "is_active", UVM_PASSIVE);
    endfunction
endclass
class rj_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(rj_scoreboard)

    uvm_tlm_analysis_fifo #(rj_transaction) fifo_i;
    uvm_tlm_analysis_fifo #(rj_transaction) fifo_o;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        fifo_i = new("sb_fifo_i", this);
        fifo_o = new("sb_fifo_o", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);
        rj_transaction tr_i, tr_o;
        super.run_phase(phase);
        forever begin
            fork
                fifo_i.get(tr_i);
                fifo_o.get(tr_o);
            join
            `uvm_info("rj_scoreboard", $sformatf("SB Received input data: %p", tr_i.data_q), UVM_LOW)
            `uvm_info("rj_scoreboard", $sformatf("SB Received output data: %p", tr_o.data_q), UVM_LOW)
            if (tr_i.data_q != tr_o.data_q)
                `uvm_error("rj_scoreboard", "Comparing data from input and output failed.");
        end
    endtask
endclass
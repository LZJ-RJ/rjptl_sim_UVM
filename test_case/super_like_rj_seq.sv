class super_like_rj_seq extends rj_sequence;
    `uvm_object_utils(super_like_rj_seq)

    shortint pkt_num = 2;

    function new(string name = "super_like_rj_seq");
        super.new(name);
    endfunction

    task body();
        bit rand_res;
        rj_packet pkt;
        rj_transaction tr;
        if (starting_phase != null)
            starting_phase.raise_objection(this);

        // Send pkt to sequencer
        repeat (pkt_num) begin
            pkt = new("super_like_rj_seq__rj_pkt");
            tr = new("super_like_rj_seq__rj_tr");
            rand_res = pkt.randomize();
            if (!rand_res) `uvm_error("super_like_rj_seq", "pkt.randomize() failed");

            `uvm_info("super_like_rj_seq", pkt.sprint(1), UVM_LOW)
            tr.data_q = pkt.raw_byte_q;
            for (int i=0; i<RJ_PKT_SIZE; i++)
                `uvm_info("super_like_rj_seq", $sformatf("tr.data_q[i]: %b", tr.data_q[i]), UVM_LOW)

            start_item(tr);
            finish_item(tr);
        end
        if (starting_phase != null)
            starting_phase.drop_objection(this);
    endtask
endclass
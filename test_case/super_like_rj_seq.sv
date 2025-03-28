class super_like_rj_seq extends rj_sequence;
    `uvm_object_utils(super_like_rj_seq)

    shortint pkt_num = 2;

    function new(string name = "super_like_rj_seq");
        super.new(name);
    endfunction

    task body();
        rj_packet pkt;
        rj_transaction tr;
        if (starting_phase != null)
            starting_phase.raise_objection(this);

        // Send pkt to sequencer
        for (int i=0; i<pkt_num; i++) begin
            tr = new("super_like_rj_seq__rj_tr");
            pkt = gen_pkt(SUPER_LIKE);
            tr.data_q = pkt.raw_byte_q;
            start_item(tr);
            finish_item(tr);
        end
        if (starting_phase != null)
            starting_phase.drop_objection(this);
    endtask

    function rj_packet gen_pkt(rj_pkt_h_level_e l=SUPER_LIKE);
        bit rand_res;
        rj_packet pkt = new("super_like_rj_seq__rj_pkt");
        rand_res = pkt.randomize with {
            level_for_user == l;
        };
        if (!rand_res) `uvm_error("super_like_rj_seq", "gen_pkt(), pkt.randomize() failed");
        `uvm_info("super_like_rj_seq", pkt.sprint(1), UVM_LOW)

        return pkt;
    endfunction
endclass
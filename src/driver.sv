class rj_driver extends uvm_driver #(rj_transaction);
    `uvm_component_utils(rj_driver)

    rj_packet pkt_q[$];
    virtual rj_intf_tx intf;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    function void assign_vi(virtual rj_intf_tx intf);
        this.intf = intf;
    endfunction

    task main_phase(uvm_phase phase);
        // method 1 - nonblocking way, better like actual situation, but may use timeout mechanism
        rj_transaction tr;
        bit [7:0] raw_byte_q_local[$];
        bit is_timeout;
        uvm_config_db #(bit)::set(uvm_root::get(), "", "is_started", 1); // Prepared for TOP level

        forever begin
            seq_item_port.try_next_item(tr);
            if (tr == null) begin
                @(posedge intf.rj_lane[1]); // One Clk Delay
            end else begin
                for (int i=0; i<tr.data_q.size(); i++)
                    raw_byte_q_local.push_back(tr.data_q[i]);
                unpack_rj_pkt(raw_byte_q_local);
                drive_pkt(); // drive to interface
                #50; // wait for monitor finished, since monitor delay driver 50
                seq_item_port.item_done();
            end
        end
    endtask

    task drive_pkt();
        shortint pkt_size = pkt_q.size();
        for (int i=pkt_size-1; i>=0; i--) begin
            for (int j=0; j<RJ_PKT_SIZE; j++) begin
                for (int k=0; k<8; k++) begin
                    @ (posedge intf.rj_lane[1]);
                    intf.rj_lane[0] = pkt_q[i].raw_byte_q[j][k];
                end
            end
        end
        pkt_q.delete();
    endtask

    function void unpack_rj_pkt(inout bit [7:0] raw_byte_q_local[$]);
        while (raw_byte_q_local.size() >= RJ_PKT_SIZE) begin
            rj_packet pkt = new();
            pkt.raw_byte_q.delete();
            for (int i=0; i<RJ_PKT_SIZE; i++) begin
                pkt.raw_byte_q.push_back(raw_byte_q_local[0]);
                raw_byte_q_local.delete(0);
            end
            pkt.unpack();
            `uvm_info("driver", $sformatf("pkt.sprint(1): %s", pkt.sprint(1)), UVM_LOW)
            pkt_q.push_back(pkt);
        end
    endfunction
endclass
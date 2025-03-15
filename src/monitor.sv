class rj_monitor extends uvm_monitor;
    `uvm_component_utils(rj_monitor)

    uvm_tlm_analysis_fifo #(rj_transaction) fifo;

    virtual rj_intf_tx my_intf_tx;
    virtual rj_intf_rx my_intf_rx;
    bit is_tx=0;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        fifo = new("mon_fifo", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    function void assign_vi_tx(virtual rj_intf_tx my_intf);
        this.my_intf_tx = my_intf;
    endfunction
    function void assign_vi_rx(virtual rj_intf_rx my_intf);
        this.my_intf_rx = my_intf;
    endfunction

    task main_phase(uvm_phase phase);
        if (is_tx)
            wait (this.my_intf_tx != null);
        else
            wait (this.my_intf_rx != null);
        handle_intf();
    endtask

    task handle_intf();
        bit b_q[$];
        rj_packet pkt;
        rj_packet pkt_q[$]; // Wait be pushed into scoreboard
        fork
            forever begin
                // Get data from interface
                if (is_tx) begin
                    @ (negedge my_intf_tx.rj_lane[1]);
                    b_q.push_back(my_intf_tx.rj_lane[0]);
                end else begin
                    @ (negedge my_intf_rx.rj_lane[1]);
                    b_q.push_back(my_intf_rx.rj_lane[0]);
                end

                if (b_q.size() == 8*RJ_PKT_SIZE) begin
                    bit [7:0] b_q2;
                    shortint b_q_idx = 0;
                    pkt = new();
                    for (int i=0; i<RJ_PKT_SIZE; i++) begin
                        for (int j=0; j<8; j++) begin
                            b_q2[j] = b_q[b_q_idx];
                            b_q_idx++;
                        end
                        pkt.raw_byte_q.push_back(b_q2);
                    end

                    pkt.unpack();
                    `uvm_info("rj_monitor", pkt.sprint(1), UVM_LOW)
                    pkt_q.push_back(pkt);
                    b_q.delete();
                end
            end
            forever begin
                // Transmit data of interface to scoreboard
                shortint cur_pkt_q_size;
                wait (pkt_q.size());
                cur_pkt_q_size = pkt_q.size();
                for (int i=0; i<cur_pkt_q_size; i++) begin
                    rj_packet cur_pkt = pkt_q.pop_front();
                    rj_transaction tr = new();
                    tr.data_q = cur_pkt.raw_byte_q;
                    fifo.write(tr);
                end
            end
        join
    endtask
endclass
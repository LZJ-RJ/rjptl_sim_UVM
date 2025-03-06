class rj_driver extends uvm_driver #(rj_transaction);
    `uvm_component_utils(rj_driver)
    rj_packet pkt_q[$];

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task main_phase(uvm_phase phase);
        // method 1 - nonblocking way, better like actual situation, but may use timeout mechanism
        rj_transaction tr;
        bit [7:0] raw_byte_q_local[$];
        bit is_timeout;
        forever begin
            fork
                begin
                    seq_item_port.try_next_item(tr);
                end
                begin
                    #100; // Has to "over" than "the delay" of sequence transmitting each transaction
                    is_timeout = 1;
                end
            join_any
            if (is_timeout) begin
                `uvm_error("driver", "When seq_item_port.try_next_item(tr), it is timeout.")
                break;
            end
            if (tr == null) begin
                //     @(posedge vif.clk);
                #5; // Each Clk Delay
            end else begin
                //     drive_one_pkt(req); // drive to interface
                for (int i=0; i<tr.data_q.size(); i++)
                    raw_byte_q_local.push_back(tr.data_q[i]);
                unpack_rj_pkt(raw_byte_q_local);

                seq_item_port.item_done();
            end
        end
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
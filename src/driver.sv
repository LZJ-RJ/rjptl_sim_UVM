class rj_driver extends uvm_driver #(rj_transaction);
    `uvm_component_utils(rj_driver)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task main_phase(uvm_phase phase);
        // method 1 - nonblocking way, better like actual situation, but may use timeout mechanism
        rj_transaction tr;
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
                seq_item_port.item_done();
            end
        end
    endtask
endclass
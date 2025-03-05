class rj_sequence extends uvm_sequence #(rj_transaction);
    `uvm_object_utils(rj_sequence)
    function new(string name = "rj_sequence");
        super.new(name);
    endfunction

    virtual task body();
        rj_transaction tr;
        if (starting_phase != null)
            starting_phase.raise_objection(this);        
        repeat (3) begin
            tr = new("tr");
            start_item(tr); // 100: This is about priority, may use default: -1
            assert(tr.randomize() with {tr.data.size() == 200;});
            `uvm_info("rj_sequence", $sformatf("tr.data: %p", tr.data), UVM_LOW);
            finish_item(tr);
        //     #10; // Can add delay
        end

        if (starting_phase != null)
            starting_phase.drop_objection(this);
    endtask
endclass
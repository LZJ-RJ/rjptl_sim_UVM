class rj_transaction extends uvm_sequence_item;
    rand bit [7:0] data[$];

    `uvm_object_utils_begin(rj_transaction)
        // `uvm_field_int(data, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "rj_transaction");
        super.new(name);
    endfunction
endclass
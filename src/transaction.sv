class rj_transaction extends uvm_sequence_item;
    rand bit [7:0] data_q[$];
    constraint basic {
        data_q.size() > 0;
    }

//     `uvm_object_utils_begin(rj_transaction)
//         `uvm_field_array_int(data_q, UVM_ALL_ON)
//     `uvm_object_utils_end

    function new(string name = "rj_transaction");
        super.new(name);
    endfunction
endclass

class rj_transaction_a_byte extends uvm_sequence_item;
    rand bit [7:0] data;
    constraint basic {
        data != 0;
    }

//     `uvm_object_utils_begin(rj_transaction_a_byte)
//         `uvm_field_int(data, UVM_ALL_ON)
//     `uvm_object_utils_end

    function new(string name = "rj_transaction_a_byte");
        super.new(name);
    endfunction
endclass
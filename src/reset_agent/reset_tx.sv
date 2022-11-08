class reset_tx extends uvm_sequence_item;
    
    `uvm_object_utils(reset_tx)

    rand logic hreset;

    function new(string name = "reset_tx");
        super.new(name);

    endfunction


endclass
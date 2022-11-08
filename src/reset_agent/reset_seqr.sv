class reset_seqr extends uvm_sequencer#(reset_tx);

    `uvm_component_utils(reset_seqr)
    
    
    function new(string name = "reset_seqr", uvm_component parent);
        super.new(name, parent);
    endfunction


endclass: reset_seqr


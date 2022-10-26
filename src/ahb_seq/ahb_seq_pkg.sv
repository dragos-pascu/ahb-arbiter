package ahb_seq_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    
    `include "../ahb_slave_agent/memory.sv"

    `include "../ahb_seq/ahb_transaction.sv"
    `include "../ahb_seq/ahb_sequencer.sv"
    `include "../ahb_seq/slave_sequencer.sv"
    `include "../ahb_seq/ahb_vsequencer.sv"
    
    //`include "ahb_seq/ahb_slave_base_seq.sv"
    `include "../ahb_seq/virtual_base_sequence.sv"
    `include "../ahb_seq/sequence_lib.sv"
    `include "../ahb_seq/virtual_sequences_lib.sv"

endpackage
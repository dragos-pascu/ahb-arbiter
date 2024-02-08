class ahb_vsequencer extends uvm_sequencer#(ahb_transaction);

    `uvm_component_utils(ahb_vsequencer)

    ahb_sequencer master_seqr[master_number];
    slave_sequencer slave_seqr[slave_number];

    function new(string name = "ahb_vsequencer" , uvm_component parent);
        super.new(name,parent);
    endfunction 
endclass 
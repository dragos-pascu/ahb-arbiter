//https://www.chipverify.com/uvm/using-sequence-library

class ahb_sequence_library exteds uvm_sequence_library #(ahb_transaction);
    
    `uvm_object_utils(ahb_sequence_library)
    `uvm_sequence_library_utils(ahb_sequence_library)

    function new(string name="ahb_sequence_library");
        super.new(name);
        init_sequence_library();
    endfunction


endclass
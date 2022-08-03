class ahb_vseq extends uvm_sequence;
    
    `uvm_object_utils(ahb_vseq)
    `uvm_declare_p_sequencer(ahb_vsequencer)	

    // Constructor
    function new(string name="ahb_vseq");
        super.new(name);
    endfunction

   

    // Body task
    virtual task body();

          `uvm_info(get_type_name(), "Executing virtual sequence body", UVM_MEDIUM)

          // Add more functionality here if needed

    endtask //body

endclass
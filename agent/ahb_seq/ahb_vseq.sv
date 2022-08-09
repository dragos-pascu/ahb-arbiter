class ahb_vseq extends uvm_sequence;
    
    `uvm_object_utils(ahb_vseq)
    `uvm_declare_p_sequencer(ahb_vsequencer)	

    ahb_seq simple_seq;

    // Constructor
    function new(string name="ahb_vseq");
        super.new(name);
    endfunction


    virtual task pre_body();
        simple_seq = ahb_seq::type_id::create("simple_seq");
    endtask

    // Body task
    virtual task body();

        for (int i=0; i<master_number; ++i) begin
            simple_seq.start(p_sequencer.master_seqr[i]);
        end
        
          `uvm_info(get_type_name(), "Executing virtual sequence body", UVM_MEDIUM)


    endtask //body

endclass
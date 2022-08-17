class virtual_base_sequence extends uvm_sequence;
    
    `uvm_object_utils(virtual_base_sequence)
    `uvm_declare_p_sequencer(ahb_vsequencer)	

    // sequences handles

    function new(string name="virtual_base_sequence");
        super.new(name);
    endfunction


    virtual task pre_body();
        if(starting_phase !=null)
            starting_phase.raise_objection(this, get_type_name());
    endtask

    virtual task post_body();
        if (starting_phase != null) begin
            starting_phase.drop_objection(this, get_type_name());
        end
    endtask

    virtual task body();
        `uvm_info(get_type_name(),"Inside body of virtual base seq.",UVM_MEDIUM)

    endtask
    

endclass
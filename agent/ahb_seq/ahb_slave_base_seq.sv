class ahb_slave_base_seq extends uvm_sequence#(ahb_transaction);
    `uvm_object_utils(ahb_slave_base_seq)
    `uvm_declare_p_sequencer(slave_sequencer)

    ahb_transaction temp_item;
    function new(string name = "ahb_slave_base_seq");
        super.new(name);
    endfunction

    virtual task body();
 
        `uvm_info(get_type_name(),"Call ahb_slave_base_seq", UVM_MEDIUM)
        temp_item = ahb_transaction::type_id::create("temp_item");
        start_item(temp_item);
        if(!temp_item.randomize() with {
            (temp_item.hresp == OKAY);
            (temp_item.hready == 1);
        } )
        `uvm_fatal(get_type_name(), "Can't randomize the item!")
        finish_item(temp_item);
        // forever begin
            
            
        //     ahb_transaction temp_item = ahb_transaction::type_id::create("temp_item");
        //     p_sequencer.m_request_fifo.get(temp_item);
            
               
        //     //code response with cases.      
        // end

    endtask

endclass
class ahb_slave_base_seq extends uvm_sequence#(ahb_transaction);
    `uvm_object_utils(ahb_slave_base_seq)
    `uvm_declare_p_sequencer(slave_sequencer)

    function new(string name = "ahb_slave_base_seq");
        super.new(name);
    endfunction

    virtual task body();
 
        `uvm_info(get_type_name(),"Call ahb_slave_base_seq", UVM_MEDIUM)
        
        forever begin
            //get este blocant , provides a new transcation
            //`uvm_info(get_type_name(),"Inside slave_base_seq body", UVM_MEDIUM)
            ahb_transaction temp_item = ahb_transaction::type_id::create("temp_item");
            p_sequencer.m_request_fifo.get(temp_item);
            $display("Ruleaza slave_base_seq");
            
            //code response with cases.      
        end
    endtask

endclass
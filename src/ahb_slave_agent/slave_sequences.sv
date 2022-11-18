//sequences for slave
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
            (hresp == OKAY);
            (no_of_waits.size == 1);
        } )
        `uvm_fatal(get_type_name(), "Can't randomize the item!")
        finish_item(temp_item);

    endtask

endclass

class slave_response_seq extends ahb_slave_base_seq;
    `uvm_object_utils(slave_response_seq)

    ahb_transaction req;
    function new(string name = "slave_response_seq");
        super.new(name);
    endfunction

    virtual task body();
        forever begin
        
        p_sequencer.m_request_fifo.get(req);
        `uvm_info(get_type_name(),"Inside body of slave_response_seq.",UVM_MEDIUM)

            case (req.hwrite)
                
                READ: begin
                    `uvm_do(req)
                end

                WRITE: begin
                    `uvm_do(req)    
                end

            endcase

        end
    endtask
    
    
endclass
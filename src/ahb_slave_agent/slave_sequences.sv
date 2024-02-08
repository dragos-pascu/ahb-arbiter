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
                    `uvm_do_with(req,{req.hresp == OKAY;/*req.no_of_waits.size == 1;*/})
                end

                WRITE: begin
                    `uvm_do_with(req,{req.hresp == OKAY;/*req.no_of_waits.size == 1;*/})
                end

            endcase

        end
    endtask
    
    
endclass
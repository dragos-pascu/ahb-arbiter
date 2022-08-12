class ahb_slave_base_seq extends uvm_sequence#(ahb_transaction);
    `uvm_object_utils(ahb_slave_base_seq)

    function new(string name = "ahb_slave_base_seq");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_info(get_type_name(),"Call ahb_slave_base_seq", UVM_LOW)
        forever begin
            //p_sequencer.m_request_fifo.get(m_req);
            //code response         

        end
    endtask

endclass
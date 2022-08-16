class ahb_base_seq extends uvm_sequence #(ahb_transaction);
    
    `uvm_object_utils(ahb_base_seq)

    virtual task pre_body();
        if(starting_phase !=null)
            starting_phase.raise_objection(this, get_type_name());
    endtask

    virtual task post_body();
        if (starting_phase != null) begin
            starting_phase.drop_objection(this, get_type_name());
        end
    endtask

    function new(string name = "ahb_base_seq");
        super.new(name);
    endfunction


    virtual task body();
        `uvm_info(get_type_name(),"Call ahb_base_seq", UVM_LOW)
        repeat(2) begin
        `uvm_do(req)
        end
    endtask



    
endclass

class simple_write_sequence extends ahb_base_seq;
    
endclass
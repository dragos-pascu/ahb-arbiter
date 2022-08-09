class ahb_base_seq extends uvm_sequence #(ahb_transaction);
    
    `uvm_object_utils(ahb_base_seq)

    function new(string name = "ahb_seq");
        super.new(name);
    endfunction


    virtual task body();
        `uvm_info(get_type_name(),"Call ahb_seq", UVM_LOW)
        repeat(5) begin
        `uvm_do(req)
        end
    endtask

    
endclass

class simple_write_sequence extends ahb_base_seq;
    
endclass
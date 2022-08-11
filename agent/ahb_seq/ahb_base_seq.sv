class ahb_base_seq extends uvm_sequence #(ahb_transaction);
    
    `uvm_object_utils(ahb_base_seq)

    //see uvm docs, uvm_sequence has a builtin handle req and rsp of sequence item type

    function new(string name = "ahb_base_seq");
        super.new(name);
    endfunction


    virtual task body();
        `uvm_info(get_type_name(),"Call ahb_base_seq", UVM_LOW)
        repeat(5) begin
        `uvm_do(req)
        end
    endtask



    
endclass

class simple_write_sequence extends ahb_base_seq;
    
endclass
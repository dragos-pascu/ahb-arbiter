class reset_base_seq extends uvm_sequence#(reset_tx);
    `uvm_object_utils(reset_base_seq)


    function new(string name = "reset_base_seq");
            super.new(name);
    endfunction

endclass: reset_base_seq


class reset_seq extends reset_base_seq;
    `uvm_object_utils(reset_seq)

    function new(string name = "reset_seq");
        super.new(name);
    endfunction

    task body();
        repeat(3) begin
        reset_tx req = reset_tx::type_id::create("req");
            // `uvm_do(req);
            start_item(req);
        if(!req.randomize())
            `uvm_fatal(get_type_name(), "Single read randomize failed!")
        finish_item(req);
        end
        
        
    endtask

endclass: reset_seq



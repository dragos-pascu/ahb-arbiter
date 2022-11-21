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
        reset_tx req = reset_tx::type_id::create("req");
        `uvm_do(req);
    endtask

endclass: reset_seq



class set_seq extends reset_base_seq;

    `uvm_object_utils(set_seq)

    function new(string name = "set_seq");
        super.new(name);

    endfunction

    task body();
        req = reset_tx::type_id::create("req");
        start_item(req);
            assert(req.randomize() with {hreset == 1;});
        finish_item(req);
    endtask


endclass: set_seq


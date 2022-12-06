class reset_tx extends uvm_sequence_item;
    
    `uvm_object_utils(reset_tx)

    rand int ticks_before_reset;
    rand int ticks_during_reset;

    function new(string name = "reset_tx");
        super.new(name);

    endfunction

    constraint ticks_before_reset_c {
                ticks_before_reset > 100;
                ticks_before_reset < 400;
    }

    constraint ticks_during_reset_c {
                ticks_during_reset > 0;
                ticks_during_reset < 10;
    }

endclass
//sequences for master
class simple_write_sequence extends uvm_sequence#(ahb_transaction);
    
    `uvm_object_utils(simple_write_sequence)

    function new(string name="simple_write_sequence");
        super.new(name);
    endfunction

    
    virtual task body();
        `uvm_info(get_type_name(),"Inside body of simple_write_sequence.",UVM_MEDIUM)

        req = ahb_transaction::type_id::create("req");
        repeat(2)begin
        start_item(req);
        // if(!req.randomize())
        //     `uvm_fatal(get_type_name(), "Single write randomize failed!")
        if(!req.randomize() with {
            (hburst == SINGLE);
            (hwrite == WRITE); 
            (htrans[0] == NONSEQ); 
            } )
            `uvm_fatal(get_type_name(), "Single write randomize failed!")
            req.hwdata[0] = $urandom();
        finish_item(req);
        get_response(req);
        end
        `uvm_info(get_type_name(), "Single write sequence finished", UVM_MEDIUM)

    endtask


endclass


class incr_write_4sequence extends uvm_sequence#(ahb_transaction);
    
    `uvm_object_utils(incr_write_4sequence)

    function new(string name="incr_write_4sequence");
        super.new(name);
    endfunction

    
    virtual task body();
        `uvm_info(get_type_name(),"Inside body of incr_write_4sequence.",UVM_MEDIUM)

        req = ahb_transaction::type_id::create("req");
        repeat(1)begin
        start_item(req);
        if(!req.randomize() with {
            (hburst == INCR4);
            (hwrite == WRITE); 
            (htrans[0] == NONSEQ); 
            } )
            `uvm_fatal(get_type_name(), "INCR4 write randomize failed!")
        finish_item(req);
        get_response(req);
        end
        `uvm_info(get_type_name(), "INCR4 sequence finished", UVM_MEDIUM)

    endtask


endclass

class wrap_write_4sequence extends uvm_sequence#(ahb_transaction);
    
    `uvm_object_utils(wrap_write_4sequence)

    function new(string name="wrap_write_4sequence");
        super.new(name);
    endfunction

    
    virtual task body();
        `uvm_info(get_type_name(),"Inside body of wrap_write_4sequence.",UVM_MEDIUM)

        req = ahb_transaction::type_id::create("req");
        repeat(1)begin
        start_item(req);
        if(!req.randomize() with {
            (hburst == WRAP4);
            (hwrite == WRITE); 
            (htrans[0] == NONSEQ); 
            } )
            `uvm_fatal(get_type_name(), "Wrap4 write randomize failed!")
        finish_item(req);
        get_response(req);
        end
        `uvm_info(get_type_name(), "Wrap4 write sequence finished", UVM_MEDIUM)

    endtask


endclass
//sequences for master
class single_write_sequence extends uvm_sequence#(ahb_transaction);
    
    `uvm_object_utils(single_write_sequence)

    function new(string name="single_write_sequence");
        super.new(name);
    endfunction

    
    virtual task body();
        `uvm_info(get_type_name(),"Inside body of single_write_sequence.",UVM_MEDIUM)

        req = ahb_transaction::type_id::create("req");
        repeat(2)begin
        start_item(req);
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

class single_read_sequence extends uvm_sequence#(ahb_transaction);
    
    `uvm_object_utils(single_read_sequence)

    function new(string name="single_read_sequence");
        super.new(name);
    endfunction

    
    virtual task body();
        `uvm_info(get_type_name(),"Inside body of single_read_sequence.",UVM_MEDIUM)

        req = ahb_transaction::type_id::create("req");
        repeat(2)begin
        start_item(req);
        if(!req.randomize() with {
            (hburst == SINGLE);
            (hwrite == READ); 
            (htrans[0] == NONSEQ); 
            } )
            `uvm_fatal(get_type_name(), "Single read randomize failed!")
            req.hwdata[0] = $urandom();
        finish_item(req);
        get_response(req);
        end
        `uvm_info(get_type_name(), "Single read sequence finished", UVM_MEDIUM)

    endtask


endclass



class incr_write_sequence extends uvm_sequence#(ahb_transaction);
    
    `uvm_object_utils(incr_write_sequence)

    function new(string name="incr_write_sequence");
        super.new(name);
    endfunction

    
    virtual task body();
        `uvm_info(get_type_name(),"Inside body of incr_write_sequence.",UVM_MEDIUM)

        req = ahb_transaction::type_id::create("req");
        repeat(30)begin
        start_item(req);
        if(!req.randomize() with {
            (hburst == INCR);
            (hsize == WORD);
            (hwrite == WRITE); 
            (htrans[0] == NONSEQ); 
            } )
            `uvm_fatal(get_type_name(), "INCR write randomize failed!")

        finish_item(req);
        get_response(req);
        end
        `uvm_info(get_type_name(), "INCR sequence finished", UVM_MEDIUM)

    endtask


endclass

class incr_read_sequence extends uvm_sequence#(ahb_transaction);
    
    `uvm_object_utils(incr_read_sequence)

    function new(string name="incr_read_sequence");
        super.new(name);
    endfunction

    
    virtual task body();
        `uvm_info(get_type_name(),"Inside body of incr_read_sequence.",UVM_MEDIUM)

        req = ahb_transaction::type_id::create("req");
        repeat(10)begin
        start_item(req);
        if(!req.randomize() with {
            (hburst == INCR);
            (hsize == WORD);
            (hwrite == READ); 
            (htrans[0] == NONSEQ); 
            } )
            `uvm_fatal(get_type_name(), "INCR read randomize failed!")

        finish_item(req);
        get_response(req);
        end
        `uvm_info(get_type_name(), "INCR read sequence finished", UVM_MEDIUM)

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
        repeat(3)begin
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
        `uvm_info(get_type_name(), "INCR4 write sequence finished", UVM_MEDIUM)

    endtask


endclass

class incr_read_4sequence extends uvm_sequence#(ahb_transaction);
    
    `uvm_object_utils(incr_read_4sequence)

    function new(string name="incr_read_4sequence");
        super.new(name);
    endfunction

    
    virtual task body();
        `uvm_info(get_type_name(),"Inside body of incr_read_4sequence.",UVM_MEDIUM)

        req = ahb_transaction::type_id::create("req");
        repeat(1)begin
        start_item(req);
        if(!req.randomize() with {
            (hburst == INCR4);
            (hwrite == READ); 
            (htrans[0] == NONSEQ); 
            } )
            `uvm_fatal(get_type_name(), "INCR4 read randomize failed!")
        finish_item(req);
        get_response(req);
        end
        `uvm_info(get_type_name(), "INCR4 read sequence finished", UVM_MEDIUM)

    endtask


endclass

class incr_write_8sequence extends uvm_sequence#(ahb_transaction);
    
    `uvm_object_utils(incr_write_8sequence)

    function new(string name="incr_write_8sequence");
        super.new(name);
    endfunction

    
    virtual task body();
        `uvm_info(get_type_name(),"Inside body of incr_write_8sequence.",UVM_MEDIUM)

        req = ahb_transaction::type_id::create("req");
        repeat(1)begin
        start_item(req);
        if(!req.randomize() with {
            (hburst == INCR8);
            (hwrite == WRITE); 
            (htrans[0] == NONSEQ); 
            } )
            `uvm_fatal(get_type_name(), "INCR8 write randomize failed!")
        finish_item(req);
        get_response(req);
        end
        `uvm_info(get_type_name(), "INCR8 sequence finished", UVM_MEDIUM)

    endtask


endclass

class incr_read_8sequence extends uvm_sequence#(ahb_transaction);
    
    `uvm_object_utils(incr_read_8sequence)

    function new(string name="incr_read_8sequence");
        super.new(name);
    endfunction

    
    virtual task body();
        `uvm_info(get_type_name(),"Inside body of incr_read_8sequence.",UVM_MEDIUM)

        req = ahb_transaction::type_id::create("req");
        repeat(1)begin
        start_item(req);
        if(!req.randomize() with {
            (hburst == INCR8);
            (hwrite == READ); 
            (htrans[0] == NONSEQ); 
            } )
            `uvm_fatal(get_type_name(), "INCR8 read randomize failed!")
        finish_item(req);
        get_response(req);
        end
        `uvm_info(get_type_name(), "INCR8 read sequence finished", UVM_MEDIUM)

    endtask


endclass

class incr_write_16sequence extends uvm_sequence#(ahb_transaction);
    
    `uvm_object_utils(incr_write_16sequence)

    function new(string name="incr_write_16sequence");
        super.new(name);
    endfunction

    
    virtual task body();
        `uvm_info(get_type_name(),"Inside body of incr_write_16sequence.",UVM_MEDIUM)

        req = ahb_transaction::type_id::create("req");
        repeat(2)begin
        start_item(req);
        if(!req.randomize() with {
            (hburst == INCR16);
            (hwrite == WRITE); 
            (htrans[0] == NONSEQ); 
            } )
            `uvm_fatal(get_type_name(), "INCR16 write randomize failed!")
        finish_item(req);
        get_response(req);
        end
        `uvm_info(get_type_name(), "INCR16 sequence finished", UVM_MEDIUM)

    endtask


endclass

class incr_read_16sequence extends uvm_sequence#(ahb_transaction);
    
    `uvm_object_utils(incr_read_16sequence)

    function new(string name="incr_read_16sequence");
        super.new(name);
    endfunction

    
    virtual task body();
        `uvm_info(get_type_name(),"Inside body of incr_read_16sequence.",UVM_MEDIUM)

        req = ahb_transaction::type_id::create("req");
        repeat(2)begin
        start_item(req);
        if(!req.randomize() with {
            (hburst == INCR16);
            (hwrite == READ); 
            (htrans[0] == NONSEQ); 
            } )
            `uvm_fatal(get_type_name(), "INCR16 read randomize failed!")
        finish_item(req);
        get_response(req);
        end
        `uvm_info(get_type_name(), "INCR16 read sequence finished", UVM_MEDIUM)

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
        repeat(2)begin
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

class wrap_read_4sequence extends uvm_sequence#(ahb_transaction);
    
    `uvm_object_utils(wrap_read_4sequence)

    function new(string name="wrap_read_4sequence");
        super.new(name);
    endfunction

    
    virtual task body();
        `uvm_info(get_type_name(),"Inside body of wrap_read_4sequence.",UVM_MEDIUM)

        req = ahb_transaction::type_id::create("req");
        repeat(2)begin
        start_item(req);
        if(!req.randomize() with {
            (hburst == WRAP4);
            (hwrite == READ); 
            (htrans[0] == NONSEQ); 
            } )
            `uvm_fatal(get_type_name(), "Wrap4 read randomize failed!")
        finish_item(req);
        get_response(req);
        end
        `uvm_info(get_type_name(), "Wrap4 read sequence finished", UVM_MEDIUM)

    endtask


endclass


class wrap_write_8sequence extends uvm_sequence#(ahb_transaction);
    
    `uvm_object_utils(wrap_write_8sequence)

    function new(string name="wrap_write_8sequence");
        super.new(name);
    endfunction

    
    virtual task body();
        `uvm_info(get_type_name(),"Inside body of wrap_write_8sequence.",UVM_MEDIUM)

        req = ahb_transaction::type_id::create("req");
        repeat(2)begin
        start_item(req);
        if(!req.randomize() with {
            (hburst == WRAP8);
            (hwrite == WRITE); 
            (htrans[0] == NONSEQ); 
            } )
            `uvm_fatal(get_type_name(), "WRAP8 write randomize failed!")
        finish_item(req);
        get_response(req);
        end
        `uvm_info(get_type_name(), "WRAP8 write sequence finished", UVM_MEDIUM)

    endtask


endclass

class wrap_read_8sequence extends uvm_sequence#(ahb_transaction);
    
    `uvm_object_utils(wrap_read_8sequence)

    function new(string name="wrap_read_8sequence");
        super.new(name);
    endfunction

    
    virtual task body();
        `uvm_info(get_type_name(),"Inside body of wrap_read_8sequence.",UVM_MEDIUM)

        req = ahb_transaction::type_id::create("req");
        repeat(2)begin
        start_item(req);
        if(!req.randomize() with {
            (hburst == WRAP8);
            (hwrite == READ); 
            (htrans[0] == NONSEQ); 
            } )
            `uvm_fatal(get_type_name(), "WRAP8 READ randomize failed!")
        finish_item(req);
        get_response(req);
        end
        `uvm_info(get_type_name(), "WRAP8 read sequence finished", UVM_MEDIUM)

    endtask


endclass

class wrap_write_16sequence extends uvm_sequence#(ahb_transaction);
    
    `uvm_object_utils(wrap_write_16sequence)

    function new(string name="wrap_write_16sequence");
        super.new(name);
    endfunction

    
    virtual task body();
        `uvm_info(get_type_name(),"Inside body of wrap_write_16sequence.",UVM_MEDIUM)

        req = ahb_transaction::type_id::create("req");
        repeat(2)begin
        start_item(req);
        if(!req.randomize() with {
            (hburst == WRAP16);
            (hwrite == WRITE); 
            (htrans[0] == NONSEQ); 
            } )
            `uvm_fatal(get_type_name(), "WRAP16 write randomize failed!")
        finish_item(req);
        get_response(req);
        end
        `uvm_info(get_type_name(), "WRAP16 write sequence finished", UVM_MEDIUM)

    endtask


endclass

class wrap_read_16sequence extends uvm_sequence#(ahb_transaction);
    
    `uvm_object_utils(wrap_read_16sequence)

    function new(string name="wrap_read_16sequence");
        super.new(name);
    endfunction

    
    virtual task body();
        `uvm_info(get_type_name(),"Inside body of wrap_read_16sequence.",UVM_MEDIUM)

        req = ahb_transaction::type_id::create("req");
        repeat(2)begin
        start_item(req);
        if(!req.randomize() with {
            (hburst == WRAP16);
            (hwrite == READ); 
            (htrans[0] == NONSEQ); 
            } )
            `uvm_fatal(get_type_name(), "WRAP16 read randomize failed!")
        finish_item(req);
        get_response(req);
        end
        `uvm_info(get_type_name(), "WRAP16 read sequence finished", UVM_MEDIUM)

    endtask


endclass

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
        temp_item = ahb_transaction::type_id::create("temp_item");
        start_item(temp_item);
        if(!temp_item.randomize() with {
            (hresp == OKAY);
            (no_of_waits.size == 3);
        } )
        `uvm_fatal(get_type_name(), "Can't randomize the item!")
        finish_item(temp_item);
        // forever begin
            
            
        //     ahb_transaction temp_item = ahb_transaction::type_id::create("temp_item");
        //     p_sequencer.m_request_fifo.get(temp_item);
            
               
        //     //code response with cases.      
        // end

    endtask

endclass


//sequences for master
class simple_write_sequence extends uvm_sequence#(ahb_transaction);
    
    `uvm_object_utils(simple_write_sequence)

    function new(string name="simple_write_sequence");
        super.new(name);
    endfunction

    
    virtual task body();
        `uvm_info(get_type_name(),"Inside body of simple_write_sequence.",UVM_MEDIUM)

        req = ahb_transaction::type_id::create("req");
        repeat(1)begin
        start_item(req);
        // if(!req.randomize())
        //     `uvm_fatal(get_type_name(), "Single write randomize failed!")
        if(!req.randomize() with {
            (hbusreq == 1);
            (hlock == 1);
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
            (hbusreq == 1);
            (hlock == 1);
            (hburst == INCR4);
            (hwrite == WRITE); 
            (htrans[0] == NONSEQ); 
            } )
            `uvm_fatal(get_type_name(), "INCR4 write randomize failed!")
        foreach (req.haddr[i]) begin
            req.post_randomize(req.haddr[i]);
        end
        finish_item(req);
        get_response(req);
        end
        `uvm_info(get_type_name(), "INCR4 sequence finished", UVM_MEDIUM)

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
            (hbusreq == 1);
            (hlock == 1);
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

class incr_write_16sequence extends uvm_sequence#(ahb_transaction);
    
    `uvm_object_utils(incr_write_16sequence)

    function new(string name="incr_write_16sequence");
        super.new(name);
    endfunction

    
    virtual task body();
        `uvm_info(get_type_name(),"Inside body of incr_write_16sequence.",UVM_MEDIUM)

        req = ahb_transaction::type_id::create("req");
        repeat(1)begin
        start_item(req);
        if(!req.randomize() with {
            (hbusreq == 1);
            (hlock == 1);
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
            (hbusreq == 1);
            (hlock == 1);
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


class wrap_write_8sequence extends uvm_sequence#(ahb_transaction);
    
    `uvm_object_utils(wrap_write_8sequence)

    function new(string name="wrap_write_8sequence");
        super.new(name);
    endfunction

    
    virtual task body();
        `uvm_info(get_type_name(),"Inside body of wrap_write_8sequence.",UVM_MEDIUM)

        req = ahb_transaction::type_id::create("req");
        repeat(1)begin
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

class wrap_write_16sequence extends uvm_sequence#(ahb_transaction);
    
    `uvm_object_utils(wrap_write_16sequence)

    function new(string name="wrap_write_16sequence");
        super.new(name);
    endfunction

    
    virtual task body();
        `uvm_info(get_type_name(),"Inside body of wrap_write_16sequence.",UVM_MEDIUM)

        req = ahb_transaction::type_id::create("req");
        repeat(1)begin
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

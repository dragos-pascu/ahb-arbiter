//sequences for master
class simple_write_sequence extends uvm_sequence#(ahb_transaction);
    
    `uvm_object_utils(simple_write_sequence)

    function new(string name="simple_write_sequence");
        super.new(name);
    endfunction

    virtual task pre_body();
        if(starting_phase !=null)
            starting_phase.raise_objection(this, get_type_name());
    endtask

    virtual task post_body();
        if (starting_phase != null) begin
            starting_phase.drop_objection(this, get_type_name());
        end
    endtask
    
    virtual task body();
        `uvm_info(get_type_name(),"Inside body of simple_write_sequence.",UVM_MEDIUM)

        req = ahb_transaction::type_id::create("req");
        repeat(2)begin
        start_item(req);
        // if(!req.randomize())
        //     `uvm_fatal(get_type_name(), "Single write randomize failed!")
        if(!req.randomize() with {
            (hburst == SINGLE);
            (hwrite==WRITE); 
            (htrans[0] == NONSEQ); 
            } )
            `uvm_fatal(get_type_name(), "Single write randomize failed!")
            req.hwdata[0] = $urandom();
        finish_item(req);
        end
        `uvm_info(get_type_name(), "sequence finished", UVM_MEDIUM)

    endtask


endclass
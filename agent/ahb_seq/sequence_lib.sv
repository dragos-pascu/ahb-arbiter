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
        repeat(1)begin
        start_item(req);
        if(!req.randomize() with {
            (req.hburst == SINGLE);
            (req.hwrite==WRITE); 
            (req.wait_cycles==0); } )
            `uvm_fatal(get_type_name(), "Single write randomize failed!")
        finish_item(req);
        end
        `uvm_info(get_type_name(), "sequence finished", UVM_MEDIUM)

    endtask


endclass
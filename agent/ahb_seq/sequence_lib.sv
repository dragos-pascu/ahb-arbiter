//sequences for master
class simple_write_sequence extends uvm_sequence#(ahb_transaction);
    
    `uvm_object_utils(simple_write_sequence)

    function new(string name="simple_write_sequence");
        super.new(name);
    endfunction

    
    virtual task body();
        req = ahb_transaction::type_id::create("req");
        repeat(1)begin
        start_item(req);
        if(!req.randomize() with {
            (req.hburst == SINGLE);
            (req.hwrite==WRITE); 
            (req.wait_cycles==0); } )
            `uvm_fatal(get_type_name(), "Single write randomize failed!")
        finish_item(req);
        `uvm_info(get_type_name(), "sequence finished", UVM_MEDIUM)
    end
    endtask


endclass
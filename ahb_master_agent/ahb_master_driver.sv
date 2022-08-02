class ahb_master_driver extends uvm_driver#(ahb_transaction);

    `uvm_component_utils(ahb_master_driver)

    

    function new(string name = "ahb_master_driver", uvm_component parent);
        super.new(name, parent);
    endfunction: new
endclass //ahb_master_driver extends superClass
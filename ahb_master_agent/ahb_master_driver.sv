class ahb_master_driver extends uvm_driver#(ahb_transaction);

    `uvm_component_utils(ahb_master_driver)

    virtual arbiter_if vif;
    

    function new(string name = "ahb_master_driver", uvm_component parent);
        super.new(name, parent);
    endfunction: new


    function void build_phase(uvm_phase);
        `uvm_info(get_type_name(), "Build_phase for driver", UVM_DEBUG)

        //add virtual interface

    endfunction

    task run_phase(uvm_phase phase);

        forever begin
            
            @(vif.m_cb)
            seq_item_port.get_next_item( req );
            
            seq_item_port.item_done( req );

        end    

    endtask


endclass //ahb_master_driver extends superClass
class ahb_master_driver extends uvm_driver#(ahb_transaction);

    `uvm_component_utils(ahb_master_driver)

    virtual arbiter_if vif;
    

    function new(string name = "ahb_master_driver", uvm_component parent);
        super.new(name, parent);
    endfunction: new


    function void build_phase(uvm_phase);
        `uvm_info(get_type_name(), "Build_phase for driver", UVM_DEBUG)

        if(!uvm_config_db #(virtual arbiter_if)::get(this, "*", $psprintf("*master[%0d]*", agent_config.agent_id), vif)) 
      
            `uvm_fatal(get_type_name(), "Didn't get handle to virtual interface!")

    endfunction

endclass //ahb_master_driver extends superClass
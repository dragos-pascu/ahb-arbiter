class ahb_master_driver extends uvm_driver#(ahb_transaction);

    `uvm_component_utils(ahb_master_driver)

    virtual master_if vif;
    
    ahb_agent_config agent_config;

    function new(string name = "ahb_master_driver", uvm_component parent);
        super.new(name, parent);
    endfunction: new


    function void build_phase(uvm_phase);
        super.build_phase(phase);


        if(!uvm_config_db #(virtual master_if)::get(this, "*", $sformatf("*master[%0d]*", agent_config.agent_id), vif)) 
      
          `uvm_fatal(get_type_name(), "VIF failed")

        `uvm_info(get_type_name(), "Finished build_phase for driver", UVM_MEDIUM)

    endfunction

    task run_phase(uvm_phase phase);

        forever begin
            
            @(vif.m_cb)
            seq_item_port.get_next_item( req );
            
            seq_item_port.item_done( req );

        end    

    endtask


endclass //ahb_master_driver extends superClass
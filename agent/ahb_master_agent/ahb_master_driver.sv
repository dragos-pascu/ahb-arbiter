class ahb_master_driver extends uvm_driver#(ahb_transaction);

    `uvm_component_utils(ahb_master_driver)

    virtual master_if vif;

    ahb_magent_config agent_config;
    

    function new(string name = "ahb_master_driver", uvm_component parent);
        super.new(name, parent);
    endfunction: new


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(ahb_magent_config)::get(null,get_parent().get_name(), "ahb_magent_config", agent_config)) 

          `uvm_fatal(get_type_name(), "Failed to get config inside Master Driver")

        if(!uvm_config_db #(virtual master_if)::get(this, "", $sformatf("master[%0d]", agent_config.agent_id), vif)) 

          `uvm_fatal(get_type_name(), "Failed to get VIF inside Master Driver")

        //`uvm_info(get_type_name(), "Finished build_phase for driver", UVM_MEDIUM)

    endfunction

    task run_phase(uvm_phase phase);

        forever begin
            
            @(vif.m_cb)
            seq_item_port.get_next_item( req );
            drive(req);
            seq_item_port.item_done( req );

        end    

    endtask

    task drive(ahb_transaction req);
        
        req.print();
        vif.m_cb.hbusreq  <= req.hbusreq;
        vif.m_cb.hlock   <= req.hlock;
        vif.m_cb.haddr   <= req.haddr;
        vif.m_cb.hwdata  <= req.hwdata;
        vif.m_cb.hburst  <= req.hburst;
        vif.m_cb.htrans  <= req.htrans;
        vif.m_cb.hsize   <= req.hsize;
        vif.m_cb.hwrite  <= req.hwrite;

    endtask

endclass //ahb_master_driver extends superClass
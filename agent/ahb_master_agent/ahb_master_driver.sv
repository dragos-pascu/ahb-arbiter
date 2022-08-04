class ahb_master_driver extends uvm_driver#(ahb_transaction);

    `uvm_component_utils(ahb_master_driver)

    virtual master_if vif;

    ahb_magent_config agent_config;
    

    function new(string name = "ahb_master_driver", uvm_component parent);
        super.new(name, parent);
    endfunction: new


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        $display(get_parent().get_name());
        if(!uvm_config_db #(ahb_magent_config)::get(null,get_parent().get_name(), "ahb_magent_config", agent_config)) 

          `uvm_fatal(get_type_name(), "Master Agent config failed")

        if(!uvm_config_db #(virtual master_if)::get(this, "", $sformatf("master[%0d]", agent_config.agent_id), vif)) 

          `uvm_fatal(get_type_name(), "VIF failed")

        `uvm_info(get_type_name(), "Finished build_phase for driver", UVM_MEDIUM)

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
        vif.m_cb.busreq  <= req.hbusreq;
        vif.m_cb.hlock   <= req.hlock;
        vif.m_cb.haddr   <= req.address;
        vif.m_cb.hwdata  <= req.wdata;
        vif.m_cb.hburst  <= req.burst_mode;
        vif.m_cb.htrans  <= req.trans_type;
        vif.m_cb.hsize   <= req.trans_size;
        vif.m_cb.hwrite  <= req.read_write;
        //vif.m_cb.hgrant  <= 1;


    endtask

endclass //ahb_master_driver extends superClass
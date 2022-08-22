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
        initialize();
        forever begin
            
            
            seq_item_port.get_next_item( req );
            fork
            drive(req);
            join
            seq_item_port.item_done();

        end    

    endtask

    task drive(ahb_transaction req);
        

        req.print();
        $display("%t",$time);

        //drive control signals
        vif.m_cb.hsize   <= req.hsize;
        vif.m_cb.hwrite  <= req.hwrite;
        vif.m_cb.hburst  <= req.hburst;

        //drive aribter signals
        vif.m_cb.hbusreq <= req.hbusreq;
        vif.m_cb.hlock   <= req.hlock;

        //drive addr, transaction type and data
        foreach (req.haddr[i]) begin
            vif.m_cb.haddr <= req.haddr[i];
            vif.m_cb.htrans <= req.htrans[i];
            $display("Inside");
            while(vif.m_cb.hready) 
                @(vif.m_cb);
                if(req.hwrite == WRITE)
                begin
                        vif.m_cb.hwdata <= req.hwdata[i];
                end
        end

    endtask

    task initialize();

        vif.m_cb.hbusreq <= 0;
        vif.m_cb.hlock   <= 0;
        vif.m_cb.haddr   <= 0;
        vif.m_cb.hwdata  <= 0;
        vif.m_cb.hburst  <= 0;
        vif.m_cb.htrans  <= 0;
        vif.m_cb.hsize   <= 0;
        vif.m_cb.hwrite  <= 0;
        repeat (1) begin
            @(vif.m_cb);
        end
    endtask

endclass //ahb_master_driver extends superClass
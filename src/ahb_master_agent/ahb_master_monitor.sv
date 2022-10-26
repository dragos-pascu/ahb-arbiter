class ahb_master_monitor extends uvm_monitor;
    `uvm_component_utils(ahb_master_monitor)


    uvm_analysis_port #(ahb_transaction) item_collect_port;
    uvm_analysis_port #(ahb_transaction) request_collect_port;

    virtual master_if vif;

    virtual request_if request_vif;

    mailbox mbx = new();

    ahb_magent_config agent_config;


    

    function new(string name, uvm_component parent);
        super.new(name,parent);

    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        item_collect_port = new("item_collected_port",this);
        request_collect_port = new("request_collect_port",this);

        if(!uvm_config_db #(ahb_magent_config)::get(null,get_parent().get_name(), "ahb_magent_config", agent_config)) 

          `uvm_fatal(get_type_name(), "Failed to get config inside Master Monitor")

        if(!uvm_config_db #(virtual master_if)::get(this, "", $sformatf("master[%0d]", agent_config.agent_id), vif)) 

          `uvm_fatal(get_type_name(), "Failed to get VIF inside Master Monitor")

        if(!uvm_config_db #(virtual request_if)::get(this, "", $sformatf("bus_req[%0d]", agent_config.agent_id), request_vif)) 

          `uvm_fatal(get_type_name(), "Failed to get VIF inside Master Monitor")
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
            `uvm_info(get_type_name(), "Monitor run phase", UVM_MEDIUM)
            fork
                monitor_addr_phase();
                monitor_data_phase();
            join_none
            
    endtask

    task monitor_addr_phase();
        ahb_transaction item;

        forever begin
            
            #1ns;
            //@(vif.m_cb iff(vif.m_cb.hready && vif.m_cb.hgrant && vif.hreset));
            while(!(vif.m_cb.hready && vif.m_cb.hgrant && vif.hreset)) @vif.m_cb;
            if (vif.m_cb.htrans == NONSEQ || vif.m_cb.htrans == SEQ) begin
                item = ahb_transaction::type_id::create("item");
                item.htrans = new[1];
                item.haddr = new[1];
                item.hwdata = new[1];
                begin
                //bus signals
                item.hbusreq =  vif.m_cb.hbusreq;
                item.hlock =  vif.m_cb.hlock ;
                //address and control signals
                item.haddr[0] =  vif.m_cb.haddr ;
                item.hburst =  burst_t'(vif.m_cb.hburst);
                item.htrans[0] =  transfer_t'(vif.m_cb.htrans);
                item.hsize =   size_t'(vif.m_cb.hsize) ;
                item.hwrite =  rw_t'(vif.m_cb.hwrite);   
                item.id = agent_config.agent_id;

                // slave response
                item.hready = vif.m_cb.hready;
                item.hresp = resp_t'(vif.m_cb.hresp);
                
                end

                //#1ns;
                @(vif.m_cb iff(vif.m_cb.hready && vif.hreset));
                mbx.put(item);
            end
        end

    endtask

    task monitor_data_phase();
        ahb_transaction item;
        forever begin
            mbx.get(item);
            //$display("got the item");
            if(item.hwrite == WRITE) begin
                item.hwdata[0] = vif.m_cb.hwdata;
            end else if (item.hwrite == READ) begin
                item.hready = vif.m_cb.hready;
            end

            //`uvm_info(get_type_name(), "Item written to analysis port.", UVM_MEDIUM)
            item_collect_port.write(item);
        end
    endtask
    

endclass
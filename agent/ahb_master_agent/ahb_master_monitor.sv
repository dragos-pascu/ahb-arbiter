class ahb_master_monitor extends uvm_monitor;
    `uvm_component_utils(ahb_master_monitor)


    uvm_analysis_port #(ahb_transaction) item_collect_port;

    virtual master_if vif;

    mailbox mbx = new();

    ahb_magent_config agent_config;


    

    function new(string name, uvm_component parent);
        super.new(name,parent);

    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        item_collect_port = new("item_collected_port",this);

        if(!uvm_config_db #(ahb_magent_config)::get(null,get_parent().get_name(), "ahb_magent_config", agent_config)) 

          `uvm_fatal(get_type_name(), "Failed to get config inside Master Monitor")

        if(!uvm_config_db #(virtual master_if)::get(this, "", $sformatf("master[%0d]", agent_config.agent_id), vif)) 

          `uvm_fatal(get_type_name(), "Failed to get VIF inside Master Monitor")
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            `uvm_info(get_type_name(), "Monitor run phase", UVM_MEDIUM)
            @(vif.hclk)
            fork
                monitor_addr_phase();
                monitor_data_phase();
            join
            
        end
        
    endtask

    task monitor_addr_phase();
        ahb_transaction item;

        forever begin
            @(posedge vif.hclk iff(vif.hready));
            if (vif.htrans == NONSEQ || vif.htrans == SEQ) begin
                //`uvm_info(get_type_name(), "Inside monitor address phase.", UVM_MEDIUM)
                item = ahb_transaction::type_id::create("item");
                item.htrans = new[1];
                item.haddr = new[1];
                item.hwdata = new[1];
                begin
                item.hbusreq =  vif.hbusreq;
                item.hlock =  vif.hlock ;
                item.haddr[0] =  vif.haddr ;
                //item.hwdata =  vif.hwdata;
                item.hburst =  burst_t'(vif.hburst);
                item.htrans[0] =  transfer_t'(vif.htrans);
                item.hsize =   size_t'(vif.hsize) ;
                item.hwrite =  rw_t'(vif.hwrite);   
                end

                mbx.put(item);
            end
        end

    endtask

    task monitor_data_phase();
        ahb_transaction item;
        forever begin
            mbx.get(item);

            @(posedge vif.hclk iff(vif.hready));
            if(item.hwrite == WRITE) begin
                item.hwdata[0] = vif.hwdata;
            end

            item.print();
            item_collect_port.write(item);
            //`uvm_info(get_type_name(), "Item written to analysis port.", UVM_MEDIUM)
        end
    endtask
    

    // task collect_transaction();
    //     ahb_transaction data_packet;
    //     forever begin
    //         @(vif.m_cb)
    //         data_packet = ahb_transaction::type_id::create("data_packet");
    //         // data_packet.hbusreq =  vif.hbusreq;
    //         // data_packet.hlock =  vif.hlock ;
    //         // data_packet.haddr =  vif.haddr ;
    //         // data_packet.hwdata =  vif.hwdata;
    //         // data_packet.hburst =  burst_t'(vif.hburst);
    //         // data_packet.htrans =  transfer_t'(vif.htrans);
    //         // data_packet.hsize =   size_t'(vif.hsize) ;
    //         // data_packet.hwrite =  rw_t'(vif.hwrite);     
            
    //         //data_packet.print();
    //         item_collect_port.write(data_packet);

    //     end
    // endtask


endclass
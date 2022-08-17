class ahb_slave_monitor extends uvm_monitor;
    `uvm_component_utils(ahb_slave_monitor)


    uvm_analysis_port #(ahb_transaction) m_req_port; // partial transaction

    virtual salve_if vif;
    ahb_transaction data_packet;

    ahb_sagent_config agent_config;

    memory storage;

    
    function new(string name, uvm_component parent);
        super.new(name,parent);
        data_packet = ahb_transaction::type_id::create("data_packet",this);
        

    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        m_req_port = new("m_req_port",this);
        storage = memory::type_id::create("storage",this);
        uvm_config_db #(memory)::set(null,"", "storage", storage); 

        if(!uvm_config_db #(ahb_sagent_config)::get(null,get_parent().get_name(), "ahb_sagent_config", agent_config)) 

          `uvm_fatal(get_type_name(), "Failed to get config inside Slave Monitor")

        if(!uvm_config_db #(virtual salve_if)::get(this, "", $sformatf("slave[%0d]", agent_config.agent_id), vif)) 

          `uvm_fatal(get_type_name(), "Failed to get VIF inside Slave Monitor")
    endfunction


    virtual task run_phase(uvm_phase phase);
        
        //write task inside the run_phase to write to m_req_port.
        collect_transaction();
    endtask

    task collect_transaction();
      ahb_transaction data_packet;
      forever begin
        data_packet = ahb_transaction::type_id::create("data_packet");
          @(vif.s_cb)
            $display("Time to slave sample:%t",$time);
            $display(vif.haddr);
            data_packet.hbusreq =  vif.hbusreq;
            data_packet.hlock =  vif.hlock ;
            data_packet.haddr =  vif.haddr ;
            data_packet.hwdata =  vif.hwdata;
            data_packet.hburst =  burst_t'(vif.hburst);
            data_packet.htrans =  transfer_t'(vif.htrans);
            data_packet.hsize =   size_t'(vif.hsize) ;
            data_packet.hwrite =  rw_t'(vif.hwrite);     

            if (data_packet.hwrite == WRITE ) begin
                storage.write(data_packet.haddr, data_packet.hwdata);
                $display("Data written");
            end
            $display("Print packet");
            data_packet.print();
            m_req_port.write(data_packet);
      end
      
    endtask

endclass
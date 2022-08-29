class ahb_master_driver extends uvm_driver#(ahb_transaction);

    `uvm_component_utils(ahb_master_driver)

    virtual master_if vif;

    ahb_magent_config agent_config;

    mailbox mbx = new();
    

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
            //fork
            drive(req);
            //join_none
            seq_item_port.item_done();

        end    

    endtask

    task drive(ahb_transaction req);
        

        req.print();
        $display("time: %t",$time);
        //@(vif.m_cb);
        //drive control signals
        vif.m_cb.hsize   <= req.hsize;
        vif.m_cb.hwrite  <= req.hwrite;
        vif.m_cb.hburst  <= req.hburst;

        //drive aribter signals
        //vif.m_cb.hbusreq <= req.hbusreq;
        //vif.m_cb.hlock   <= req.hlock;
        vif.m_cb.hbusreq <= 1;
        
       
        //drive addr, transaction type and data
        
            foreach (req.haddr[i]) begin
                vif.m_cb.haddr <= req.haddr[i];
                vif.m_cb.htrans <= req.htrans[i];

                @vif.m_cb;

                while(!vif.m_cb.hready) @(vif.m_cb);
                if(req.hwrite == WRITE)
                begin
                        vif.m_cb.hwdata <= req.hwdata[i];
                end
        end
        
        
        
        
        #1ns;        
        vif.m_cb.hbusreq <= 0;
        

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

    // virtual task run_phase(uvm_phase phase);
    //     initialize();
    //     fork
    //         address_phase();
    //         data_phase();
    //     join_none
    // endtask

    // task address_phase();
    //     forever begin                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
    //         seq_item_port.get(req);
    //         req.print();
    //         mbx.put(req);
    //         //send control signals

    //         //vif.m_cb.hlock   <= req.hlock;
    //         vif.m_cb.hbusreq <= 1;
            
    //         //wait(vif.m_cb.hgrant);
            
    //         //drive address
    //         foreach (req.haddr[i]) begin
    //         @(vif.m_cb);
    //         vif.m_cb.haddr  <= req.haddr[i];
    //         vif.m_cb.htrans <= req.htrans[i];
        
    //         //drive control signals
    //         vif.m_cb.hsize   <= req.hsize;
    //         vif.m_cb.hwrite  <= req.hwrite;
    //         vif.m_cb.hburst  <= req.hburst;
    //         #1ns
    //         vif.m_cb.hbusreq <= 0;  
            
    //         end
            
            
             
    //     end
    // endtask

    // task data_phase();
        
    //     ahb_transaction item;
    //     @(vif.m_cb);
    //     forever begin
    //         mbx.get(item);
    //         foreach (item.haddr[i]) begin
    //             if(item.hwrite == WRITE)
    //             begin
    //                     @(vif.m_cb);
    //                     vif.m_cb.hwdata <= item.hwdata[i];
    //             end
    //         end
    //         seq_item_port.put(item);
    //     end
        
    // endtask

endclass //ahb_master_driver extends superClass
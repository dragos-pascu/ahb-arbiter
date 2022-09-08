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


    task initialize();

        vif.m_cb.hbusreq <= 0;
        vif.m_cb.hlock   <= 0;
        vif.m_cb.haddr   <= 0;
        vif.m_cb.hwdata  <= 0;
        vif.m_cb.hburst  <= 0;
        vif.m_cb.htrans  <= 0;
        vif.m_cb.hsize   <= 0;
        vif.m_cb.hwrite  <= 0;
        // repeat (1) begin
        //     @(vif.m_cb);
        // end
    endtask

    virtual task run_phase(uvm_phase phase);
        initialize();
        fork
            address_phase();
            data_phase();
        join_none
    endtask

    task address_phase();
        forever begin                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
            seq_item_port.get(req);
            req.print();
            
            vif.m_cb.hbusreq <= 1;
            vif.m_cb.hlock <= 1;
            
            //drive address
            @(vif.m_cb iff(vif.m_cb.hgrant));
            // while(!vif.m_cb.hgrant)
            //     @vif.m_cb;
            foreach (req.haddr[i]) begin
                
                while (!vif.m_cb.hgrant) @vif.m_cb;
                    
                vif.m_cb.haddr  <= req.haddr[i];
                vif.m_cb.htrans <= req.htrans[i];
                //drive control signals
                vif.m_cb.hwrite  <= req.hwrite;
                vif.m_cb.hsize   <= req.hsize;
                vif.m_cb.hburst  <= req.hburst;
                

                //wait(vif.m_cb.hgrant & vif.m_cb.hready); expresia se executa in timp 0 daca expresia este true
                if (i == req.haddr.size()-1) begin
                        vif.m_cb.hbusreq <= 0;  
                        vif.m_cb.hlock <= 0;                  
                end

                // @(vif.m_cb iff(vif.m_cb.hgrant & vif.m_cb.hready));  
                // if (i == req.haddr.size()-1) begin
                //       if (vif.m_cb.hready==1) begin
                //         vif.m_cb.hbusreq <= 0;  
                //         vif.m_cb.hlock <= 0;
                //     end                
                // end

                @vif.m_cb;
                //@(vif.m_cb iff(vif.m_cb.hready)); 
                while(!vif.m_cb.hready) @vif.m_cb; 
                mbx.put(req);
                
                // if (i == req.haddr.size()-1) begin
                //     @(vif.m_cb iff(vif.m_cb.hready == 1));
                    
                // end
                

            end

            vif.m_cb.htrans <= 0;


            //#1; este in for each de la ultima iteratie
            
            // @(vif.m_cb iff(vif.m_cb.hready == 1));
            // vif.m_cb.htrans <= 0;
            // vif.m_cb.hbusreq <= 0;  
            // vif.m_cb.hlock <= 0;
            //vif.m_cb.htrans <= 0;
        end
    endtask

    task data_phase();
        
        ahb_transaction item;
        int i = 0;
        forever begin
            
            //drive data items
            
                mbx.get(item);
                //@(vif.m_cb iff(vif.m_cb.hready == 1));
                if(item.hwrite == WRITE)
                begin
                vif.m_cb.hwdata <= item.hwdata[i];
                //@vif.m_cb;
                end
                i++;
                //while(!vif.m_cb.hready) @vif.m_cb; 
            if(item.haddr.size() == i)  begin
                seq_item_port.put(item);
                i=0;
            end  
            
        end
        
    endtask


endclass //ahb_master_driver extends superClass
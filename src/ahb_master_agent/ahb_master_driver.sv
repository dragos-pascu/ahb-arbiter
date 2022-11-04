class ahb_master_driver extends uvm_driver#(ahb_transaction);

    `uvm_component_utils(ahb_master_driver)

    virtual master_if vif;

    ahb_magent_config agent_config;

    mailbox mbx = new();
    int htrans_index;


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
        repeat (1) begin
            @(vif.m_cb);
        end
    endtask

    virtual task run_phase(uvm_phase phase);
        forever begin
            initialize();
            wait(vif.hreset==1);
            fork
                address_phase();
                data_phase();
                reset_monitor();
            join_any
            disable fork;
        end
        
    endtask

    task reset_monitor();
        
        wait(vif.hreset==0);        
        
    endtask

    task address_phase();
        forever begin
            //dont drive when reset is 0
            @(vif.m_cb iff (vif.hreset))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
            seq_item_port.get(req);
            `uvm_info(get_type_name(), $sformatf("master[%0d] driver", agent_config.agent_id), UVM_MEDIUM);

            
            //request bus
            vif.m_cb.hbusreq <= req.hbusreq;
            vif.m_cb.hlock <= req.hlock;
            
            htrans_index = 0;
            foreach (req.haddr[i]) begin
                //wait for bus to be granted
                while (!(vif.m_cb.hgrant && vif.m_cb.hready && vif.hreset)) begin
                    vif.m_cb.htrans <= IDLE;
                    @vif.m_cb; 
                end

                `uvm_info(get_type_name(), $sformatf( "hgrant este:  %d \n",vif.m_cb.hgrant), UVM_MEDIUM);
                `uvm_info(get_type_name(), $sformatf( "hready este:  %d \n",vif.m_cb.hready), UVM_MEDIUM);

                `uvm_info(get_type_name(), $sformatf( "hreset este:  %d \n",vif.hreset), UVM_MEDIUM);


                if (i!=req.busy_pos) begin
                    //drive address phase
                    vif.m_cb.haddr  <= req.haddr[i];
                    vif.m_cb.htrans <= req.htrans[htrans_index];
                    vif.m_cb.hwrite  <= req.hwrite;
                    vif.m_cb.hsize   <= req.hsize;
                    vif.m_cb.hburst  <= req.hburst;
                end else begin
                    for (int j=0; j<req.no_of_busy; ++j) begin
                        vif.m_cb.htrans <= req.htrans[i+j];
                        htrans_index++;
                        @vif.m_cb;
                    end
                    vif.m_cb.haddr  <= req.haddr[i];
                    vif.m_cb.htrans <= req.htrans[htrans_index];
                    vif.m_cb.hwrite  <= req.hwrite;
                    vif.m_cb.hsize   <= req.hsize;
                    vif.m_cb.hburst  <= req.hburst;
                end

                htrans_index++;

                //wait(vif.m_cb.hgrant & vif.m_cb.hready); expresia se executa in timp 0 daca expresia este true
                if (i == req.haddr.size()-1) begin
                        vif.m_cb.hbusreq <= 0;  
                        vif.m_cb.hlock <= 0;                  
                end

                @(vif.m_cb iff(vif.m_cb.hready && vif.hreset)); //executes at least while , eq is do while loop
                mbx.put(req);
                
                

            end

            vif.m_cb.htrans <= IDLE;


        end
    endtask

    task data_phase();
        
        ahb_transaction item;
        int i = 0;
        forever begin
            
            //drive data items
            
            mbx.get(item);
            if(item.hwrite == WRITE) begin
            vif.m_cb.hwdata <= item.hwdata[i];
            end
            i++;
            
            if(item.haddr.size() == i) begin
            seq_item_port.put(item);
            i=0;
            end  
            
        end
        
    endtask



endclass //ahb_master_driver extends superClass
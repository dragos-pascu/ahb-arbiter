class ahb_master_driver extends uvm_driver#(ahb_transaction);

    `uvm_component_utils(ahb_master_driver)

    virtual master_if vif;

    ahb_magent_config agent_config;

    mailbox mbx = new();
    int haddr_index=0;
    int was_busy = 0;
    int is_zero = 0;
    
    function new(string name = "ahb_master_driver", uvm_component parent);
        super.new(name, parent);
    endfunction: new


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(ahb_magent_config)::get(null,get_parent().get_name(), "ahb_magent_config", agent_config)) 
          `uvm_fatal(get_type_name(), "Failed to get config inside Master Driver")

        if(!uvm_config_db #(virtual master_if)::get(this, "", $sformatf("master[%0d]", agent_config.agent_id), vif)) 
          `uvm_fatal(get_type_name(), "Failed to get VIF inside Master Driver")

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
    initialize();
    repeat(2) @vif.m_cb;
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
        //req = ahb_transaction::type_id::create("dummy_req");
        if (req!=null) begin
            seq_item_port.put(req);
        end
              
        
    endtask

    task address_phase();
        forever begin
            

            seq_item_port.get(req);

            //dont drive when reset is 0
            while (!vif.hreset) @vif.m_cb;

            req.id = agent_config.agent_id;
                      
            `uvm_info(get_type_name(), $sformatf("Driver req : \n %s",req.convert2string()),UVM_MEDIUM);

            haddr_index = 0 ;

            vif.m_cb.hbusreq <= req.hbusreq;
            vif.m_cb.hlock <= req.hlock;


            // @vif.m_cb;
            for (int i=0; i<req.htrans.size(); ++i) begin
                //wait for bus to be granted
                while (!(vif.m_cb.hgrant && vif.m_cb.hready && vif.hreset)) begin
                    vif.m_cb.htrans <= IDLE;
                    @vif.m_cb; 
                end

                if(req.htrans[i] == NONSEQ || req.htrans[i] == SEQ) begin
                    vif.m_cb.haddr  <= req.haddr[haddr_index];
                    haddr_index++;
                    /* construct to make a variable hlock */
                    if (!is_zero) begin
                        req.lock_duration--;
                        if (req.lock_duration == 0) begin
                            is_zero = 1;
                        end
                    end
                    vif.m_cb.htrans <= req.htrans[i];
                    vif.m_cb.hwrite  <= req.hwrite;
                    vif.m_cb.hsize   <= req.hsize;
                    vif.m_cb.hburst  <= req.hburst;
                end else if(req.htrans[i] == BUSY ) begin
                    while (req.no_of_busy>0) begin
                            vif.m_cb.htrans <= req.htrans[i];
                            vif.m_cb.haddr <= req.haddr[haddr_index];
                            vif.m_cb.hwrite  <= req.hwrite;
                            vif.m_cb.hsize   <= req.hsize;
                            vif.m_cb.hburst  <= req.hburst;
                            req.no_of_busy--;
                            i++;
                            @vif.m_cb; 
                            
                    end
                    i--;
                    
                end
                
                if(!was_busy) begin
                    @(vif.m_cb iff(vif.m_cb.hready && vif.hreset));
                    mbx.put(req);
                end

                

                //waitwa se executa in timp 0 daca expresia este true
                if (haddr_index == req.haddr.size()-1 ) begin
                        vif.m_cb.hbusreq <= 0;  
                        vif.m_cb.hlock <= 0;                  
                end else if (haddr_index < req.haddr.size()-1) begin
                            //request bus
                        vif.m_cb.hbusreq <= req.hbusreq;
                        if (req.lock_duration == 0) begin
                            vif.m_cb.hlock <= 0;
                        end else begin
                            vif.m_cb.hlock <= req.hlock;
                        end
                        
                end

            end
            haddr_index = 0 ;
            vif.m_cb.htrans <= IDLE;


        end
    endtask

    task data_phase();
        
        ahb_transaction item;
        int i = 0;
        forever begin
            
            //drive data items
            mbx.get(item);            
            if(item.hwrite == WRITE ) begin
                vif.m_cb.hwdata <= item.hwdata[i];
            end  

            i++;
            
            if(item.haddr.size() == i) begin
                seq_item_port.put(item);
                i=0;
            end  

            `uvm_info(get_type_name(), $sformatf("Driver put item : \n "),UVM_MEDIUM);
           
        end
        
    endtask



endclass //ahb_master_driver extends superClass
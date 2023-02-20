class ahb_master_monitor extends uvm_monitor;
    `uvm_component_utils(ahb_master_monitor)


    uvm_analysis_port #(ahb_transaction) master_transaction_port;

    virtual master_if vif;


    mailbox mbx = new();

    ahb_magent_config agent_config;

    int transfer_size = 100;
    int i = 0;
    int j = 0;
    

    function new(string name, uvm_component parent);
        super.new(name,parent);

    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        master_transaction_port = new("master_transaction_port",this);

        if(!uvm_config_db #(ahb_magent_config)::get(null,get_parent().get_name(), "ahb_magent_config", agent_config)) 

          `uvm_fatal(get_type_name(), "Failed to get config inside Master Monitor")

        if(!uvm_config_db #(virtual master_if)::get(this, "", $sformatf("master[%0d]", agent_config.agent_id), vif)) 

          `uvm_fatal(get_type_name(), "Failed to get VIF inside master monitor")

    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin    
            `uvm_info(get_type_name(), "Master monitor run phase", UVM_MEDIUM)
            wait(vif.hreset==1)
            fork
                monitor_addr_phase();
                monitor_data_phase();
                reset_monitor();
            join_any
            disable fork;
        end
            
    endtask

    
    task reset_monitor();
        
        wait(vif.hreset==0);        
        
    endtask

    function ahb_transaction create_item(burst_t hburst);
        ahb_transaction item;
        case (hburst)
            SINGLE : transfer_size = 1;
            WRAP4, INCR4 : transfer_size = 4;
            WRAP8, INCR8 : transfer_size = 4;
            WRAP16, WRAP16 : transfer_size = 16;
        endcase
        item = ahb_transaction::type_id::create("item");
        item.htrans = new[transfer_size];
        item.haddr = new[transfer_size];
        item.hwdata = new[transfer_size];

        return item;

    endfunction

    task monitor_addr_phase();
        ahb_transaction item;

        forever begin
            if ( ( vif.m_cb.htrans == NONSEQ || vif.m_cb.htrans == SEQ ) /*&& vif.m_cb.hgrant*/ && vif.m_cb.hready && vif.hreset) begin
                
                if (vif.m_cb.htrans == NONSEQ) begin
                    item = create_item(burst_t'(vif.m_cb.hburst));
                end
                begin
                item.hbusreq =  vif.m_cb.hbusreq;
                item.hlock =  vif.m_cb.hlock ;
                //address and control signals
                item.haddr[i] =  vif.m_cb.haddr ;
                item.hburst =  burst_t'(vif.m_cb.hburst);
                item.htrans[i] =  transfer_t'(vif.m_cb.htrans);
                item.hsize =   size_t'(vif.m_cb.hsize) ;
                item.hwrite =  rw_t'(vif.m_cb.hwrite);   
                item.id = agent_config.agent_id;
                i++;
                end
                if (i==transfer_size) begin
                    i=0;
                end
                //`uvm_info(get_type_name(), $sformatf("haddr is (addr_phase)  : %h ", item.haddr[0]), UVM_MEDIUM)
                @(vif.m_cb iff(vif.m_cb.hready && vif.hreset));
                //`uvm_info(get_type_name(), $sformatf("haddr is data_phase : %h ", item.haddr[0]), UVM_MEDIUM)

                mbx.put(item);
                
            end else begin
                @vif.m_cb;
            end
            
        end

    endtask

    task monitor_data_phase();
        ahb_transaction item;
        forever begin
            mbx.get(item);

            if(item.hwrite == WRITE) begin
                item.hwdata[j] = vif.m_cb.hwdata;
            end else if (item.hwrite == READ) begin
                item.hrdata = vif.m_cb.hrdata;
            end
            // slave response
            item.hready = vif.m_cb.hready;
            item.hresp = resp_t'(vif.m_cb.hresp);
            j++;
            if (j==transfer_size) begin
                j=0;
                `uvm_info(get_type_name(), $sformatf("Item received by Master Monitor is : %s ", item.convert2string()), UVM_MEDIUM)
                master_transaction_port.write(item);

            end

        end
    endtask
    

endclass
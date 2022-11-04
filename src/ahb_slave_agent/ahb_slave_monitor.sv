// import integration_pkg::*;
class ahb_slave_monitor extends uvm_monitor;
    `uvm_component_utils(ahb_slave_monitor)


    uvm_analysis_port #(ahb_transaction) m_req_port; // partial transaction

    virtual salve_if vif;
    ahb_transaction data_packet;

    ahb_sagent_config agent_config;

    memory storage;

    mailbox mbx = new();
    
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
          super.run_phase(phase);
          `uvm_info(get_type_name(), "Slave monitor run phase", UVM_MEDIUM)
          forever begin
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

    task monitor_addr_phase();
        ahb_transaction item;
        forever begin
        
        #1;
        //while(!(vif.hready && vif.hsel && vif.hreset)) @vif.s_cb;

        if (vif.htrans == NONSEQ || vif.htrans == SEQ && vif.hsel == 1 && vif.hready == 1 && vif.hreset == 1) begin
        item = ahb_transaction::type_id::create("item");
        item.htrans = new[1];
        item.haddr = new[1];
        item.hwdata = new[1];
          begin
              //address and control signals
              item.haddr[0] =  vif.s_cb.haddr ;
              item.hburst =  burst_t'(vif.s_cb.hburst);
              item.htrans[0] =  transfer_t'(vif.s_cb.htrans);
              item.hsize =   size_t'(vif.s_cb.hsize) ;
              item.hwrite =  rw_t'(vif.s_cb.hwrite);   
              // slave response
              item.hready = vif.s_cb.hready;
              item.hresp = resp_t'(vif.s_cb.hresp);
              item.hrdata = vif.s_cb.hrdata;
              item.id = agent_config.agent_id;
          end
          @(vif.s_cb iff(vif.s_cb.hready && vif.hreset));
          mbx.put(item);
        end
        end
    endtask

    task monitor_data_phase();
        ahb_transaction item;
        forever begin
            mbx.get(item);

            if(item.hwrite == WRITE) begin
                item.hwdata[0] = vif.hwdata;
                storage.write(item.haddr[0],item.hwdata[0]);
            end
            else if (item.hwrite == READ) begin
                item.hrdata[0] = vif.hrdata;
            end

 
            `uvm_info(get_type_name(), $sformatf("Received from slave monitor : \n %s",item.convert2string()), UVM_DEBUG);
            m_req_port.write(item);
            
        end
    endtask
    
    
endclass
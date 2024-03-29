// import integration_pkg::*;
class ahb_slave_monitor extends uvm_monitor;
    `uvm_component_utils(ahb_slave_monitor)

    uvm_analysis_port #(ahb_transaction) slave_transaction_port; // full transaction
    uvm_analysis_port #(ahb_transaction) reactive_transaction_port; // partial transaction

    virtual salve_if vif;
    ahb_sagent_config agent_config;

    mailbox mbx = new();
    
    function new(string name, uvm_component parent);
        super.new(name,parent);        

    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        slave_transaction_port = new("slave_transaction_port",this);
        reactive_transaction_port = new("reactive_transaction_port",this);

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
        

            if ( (vif.s_cb.htrans == NONSEQ || vif.s_cb.htrans == SEQ )  && vif.s_cb.hsel == 1 && vif.s_cb.hready == 1 && vif.hreset == 1) begin

                item = ahb_transaction::type_id::create("item");
                item.htrans = new[1];
                item.haddr = new[1];
                item.hwdata = new[1];

                //address and control signals
                item.haddr[0] =  vif.s_cb.haddr ;
                item.hburst =  burst_t'(vif.s_cb.hburst);
                item.htrans[0] =  transfer_t'(vif.s_cb.htrans);
                item.hsize =   size_t'(vif.s_cb.hsize) ;
                item.hwrite =  rw_t'(vif.s_cb.hwrite);   
                // slave response
                item.hready = vif.s_cb.hready;
                item.hresp = resp_t'(vif.s_cb.hresp);
                item.id = agent_config.agent_id;
                item.hsel = vif.s_cb.hsel;

                
                reactive_transaction_port.write(item);

                // put item for data phase
                @(vif.s_cb iff(vif.s_cb.hready && vif.hreset));
                mbx.put(item);    
                
            end 
            else begin
                @vif.s_cb;
            end
        end
        
    endtask

    task monitor_data_phase();
        ahb_transaction item;
        forever begin
            mbx.get(item);
            if(item.hwrite == WRITE) begin
                item.hwdata[0] = vif.s_cb.hwdata;
            end
            else if (item.hwrite == READ) begin
                item.hrdata = vif.s_cb.hrdata;
            end

 
            `uvm_info(get_type_name(), $sformatf("Received from slave monitor : \n %s",item.convert2string()), UVM_MEDIUM);
            slave_transaction_port.write(item);
            
        end
    endtask

 
    
endclass
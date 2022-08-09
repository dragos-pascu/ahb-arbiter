class ahb_slave_monitor extends uvm_monitor;
    `uvm_component_utils(ahb_slave_monitor)


    uvm_analysis_port #(ahb_transaction) item_collect_port;

    virtual salve_if vif;
    ahb_transaction data_packet;

    ahb_sagent_config agent_config;


    

    function new(string name, uvm_component parent);
        super.new(name,parent);
        data_packet = ahb_transaction::type_id::create("data_packet",this);

    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        item_collect_port = new("item_collected_port",this);

        if(!uvm_config_db #(ahb_sagent_config)::get(null,get_parent().get_name(), "ahb_sagent_config", agent_config)) 

          `uvm_fatal(get_type_name(), "Failed to get config inside Slave Monitor")

        if(!uvm_config_db #(virtual salve_if)::get(this, "", $sformatf("slave[%0d]", agent_config.agent_id), vif)) 

          `uvm_fatal(get_type_name(), "Failed to get VIF inside Slave Monitor")
    endfunction


endclass
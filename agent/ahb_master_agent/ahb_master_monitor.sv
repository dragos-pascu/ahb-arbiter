class ahb_master_monitor extends uvm_monitor;
    `uvm_component_utils(ahb_master_monitor)

    
    uvm_analysis_port #(ahb_transaction) item_collect_port;

    virtual master_if vif;
    ahb_transaction data_packet;

    ahb_magent_config agent_config;


    

    function new(string name, uvm_component parent);
        super.new(name,parent);
        data_packet = ahb_transaction::type_id::create("data_packet",this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        item_collect_port = new("item_collected_port",this);

        if(!uvm_config_db #(ahb_magent_config)::get(null,get_parent().get_name(), "ahb_magent_config", agent_config)) 

          `uvm_fatal(get_type_name(), "Master Agent config failed")

        if(!uvm_config_db #(virtual master_if)::get(this, "", $sformatf("master[%0d]", agent_config.agent_id), vif)) 

          `uvm_fatal(get_type_name(), "VIF failed")
    endfunction

    virtual task run_phase(uvm_phase phase);

        forever begin
            @vif.m_cb;
            
            $display("Inside Monitor");
            item_collect_port.write(data_packet);

        end

    endtask



endclass
class ahb_request_monitor extends uvm_monitor;
    `uvm_component_utils(ahb_request_monitor)
    uvm_analysis_port #(ahb_request) request_collect_port;

    ahb_magent_config agent_config;
    virtual request_if vif;

    function new(string name, uvm_component parent);
        super.new(name,parent);

    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        request_collect_port = new("request_collect_port",this);


        if(!uvm_config_db #(ahb_magent_config)::get(null,get_parent().get_name(), "ahb_magent_config", agent_config)) 

          `uvm_fatal(get_type_name(), "Failed to get config inside request monitor.")

        if(!uvm_config_db #(virtual request_if)::get(this, "", $sformatf("bus_req[%0d]", agent_config.agent_id), vif)) 

          `uvm_fatal(get_type_name(), "Failed to get request_VIF inside request monitor.")


    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_type_name(), "Request monitor run phase.", UVM_MEDIUM)
        send_request();
            
    endtask

    task send_request();
    ahb_request request_item;
        forever begin

            request_item = ahb_request::type_id::create("request_item");

            @vif.req_cb;
            request_item.hbusreq = vif.req_cb.hbusreq;
            request_item.hlock = vif.req_cb.hlock;
            request_item.id = agent_config.agent_id;
            request_collect_port.write(request_item);


        end


        
        

    endtask

endclass
class ahb_request_monitor extends uvm_monitor;
    `uvm_component_utils(ahb_request_monitor)
    uvm_analysis_port #(ahb_request) request_collect_port;

    virtual request_if request_vif[master_number];

    function new(string name, uvm_component parent);
        super.new(name,parent);

    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        request_collect_port = new("request_collect_port",this);

        for (int i=0; i<master_number; ++i) begin
            
        end

    //     if(!uvm_config_db #(virtual request_if)::get(this, "", $sformatf("bus_req[%0d]", agent_config.agent_id), request_vif)) 

    //       `uvm_fatal(get_type_name(), "Failed to get request_vif inside Request monitor")
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
            `uvm_info(get_type_name(), "Request monitor run phase", UVM_MEDIUM)

            
    endtask

endclass
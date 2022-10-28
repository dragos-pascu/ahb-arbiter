class ahb_req_agent extends uvm_agent;
    `uvm_component_utils(ahb_req_agent)

    ahb_request_monitor req_monitor;

    
    function new(string name="ahb_req_agent",uvm_component parent = null);
        super.new(name,parent);
    endfunction //new()


    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        req_monitor = ahb_request_monitor::type_id::create("req_monitor",this);


    endfunction


endclass
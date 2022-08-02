class ahb_master_agent extends uvm_agent;
    
    ahb_master_driver ahb_mdriver;

    function new();
        super.new(string name="ahb_agent",uvm_component parent = null);
    endfunction //new()
endclass //ahb_master_agent extends uvm_agent
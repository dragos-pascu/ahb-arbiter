class config_req_agent extends uvm_object;
    
    `uvm_object_utils(config_req_agent) 

    virtual request_if req_vif[master_number];
    int master_id[master_number];
    bit enable_coverage;
    
    //constructor 
    function new(string name= "config_req_agent"); 

        super.new(name);
        
    endfunction //new()

endclass
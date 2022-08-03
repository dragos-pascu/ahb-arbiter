class ahb_magent_config extends uvm_object;
    
    `uvm_object_utils(ahb_magent_config) 

    virtual master_if vif;
    int agent_id;
    uvm_active_passive_enum is_active;

    //constructor 
    function new(string name= "ahb_magent_config"); 

        super.new(name);
        
    endfunction //new()

endclass
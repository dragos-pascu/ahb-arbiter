class ahb_sagent_config extends uvm_object;
    
    `uvm_object_utils(ahb_sagent_config)

    virtual salve_if vif;
    int agent_id;
    bit is_active;
    
    function new(string name= "ahb_sagent_config"); 

        super.new(name);
        
    endfunction //new()

endclass
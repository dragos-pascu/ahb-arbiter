class reset_config extends uvm_object;
    
    `uvm_object_utils(reset_config) 

    virtual master_if vif;
    
    //constructor 
    function new(string name= "reset_config"); 

        super.new(name);
        
    endfunction //new()

endclass
class ahb_slave_driver extends uvm_driver#(ahb_transaction);
    
    `uvm_component_utils(ahb_slave_driver)

    virtual salve_if vif;
    ahb_sagent_config agent_config;

    function new(string name = "ahb_slave_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //add virtual interface

        if (!uvm_config_db #(virtual salve_if)::get(this, "", $sformatf("*slave[%0d]*", agent_config.agent_id), vif))
      
          `uvm_fatal(get_type_name(), "VIF failed in slave driver!");

    endfunction


endclass //ahb_slave_driver extends uvm_driver
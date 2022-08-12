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
        if(!uvm_config_db #(ahb_sagent_config)::get(null,get_parent().get_name(), "ahb_sagent_config", agent_config)) 

          `uvm_fatal(get_type_name(), "Failed to get config inside Slave Driver")


        if (!uvm_config_db #(virtual salve_if)::get(null, "", $sformatf("slave[%0d]", agent_config.agent_id), vif))
      
          `uvm_fatal(get_type_name(), "Failed to get VIF inside Slave Driver");

    endfunction

    task run_phase(uvm_phase phase);
      //add init function
      forever begin
        seq_item_port.get_next_item(req);
        drive(req);
        seq_item_port.item_done();
      end

    endtask

    task drive(input ahb_transaction req);
      // drive response signals to DUT in accordance with protocol
      // based on response item fields, e.g. sync to clock edge,
      // wait for delay, drive signal <= item field
    endtask

endclass //ahb_slave_driver extends uvm_driver
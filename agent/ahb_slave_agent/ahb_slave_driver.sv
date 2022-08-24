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
      initialize();
      forever begin
        seq_item_port.get_next_item(req);
        fork
          // @vif.s_cb;
          drive(req);
        join
        seq_item_port.item_done();

      end

    endtask


    task initialize();
      vif.s_cb.hready <= 0;
      vif.s_cb.hresp <= 0;
      vif.s_cb.hrdata <= 0;
      // repeat (1) begin
      //       @(vif.s_cb);
      //   end
    endtask

    task drive(ahb_transaction req);
      vif.s_cb.hresp <= req.hresp;
      vif.s_cb.hready <= req.hready;
      vif.s_cb.hrdata <= 44;

      
    endtask

endclass //ahb_slave_driver extends uvm_driver
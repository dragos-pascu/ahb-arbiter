class ahb_slave_driver extends uvm_driver#(ahb_transaction);
    
    `uvm_component_utils(ahb_slave_driver)

    virtual salve_if vif;
    ahb_sagent_config agent_config;
    memory storage;
    
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
        storage = memory::type_id::create("storage",this);
        uvm_config_db #(memory)::set(null,"", "storage", storage);
    endfunction

    task run_phase(uvm_phase phase);
      initialize();
      forever begin
        
        @(vif.s_cb iff vif.s_cb.hsel );
        //wait(vif.s_cb.hsel);
        seq_item_port.get_next_item(req);
        drive(req);
        seq_item_port.item_done();

      end

    endtask


    task initialize();
      vif.s_cb.hready <= 1;
      vif.s_cb.hresp <= OKAY;
      vif.s_cb.hrdata <= 0;
      repeat(1)begin
        @(vif.s_cb);
      end
      
      

    endtask

    task drive(ahb_transaction req);
      
      //`uvm_info(get_type_name(), $sformatf("Slave driver item : \n %s",req.convert2string()), UVM_MEDIUM);
      
      fork
        foreach (req.no_of_waits[i]) begin
        
        vif.s_cb.hready <= req.no_of_waits[i];
        @vif.s_cb;
        
      end

      if (vif.s_cb.hwrite == READ) begin
        vif.s_cb.hrdata <= $urandom();
      end
      join_none

      

    endtask  

endclass //ahb_slave_driver extends uvm_driver
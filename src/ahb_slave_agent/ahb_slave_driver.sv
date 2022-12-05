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
      vif.s_cb.hready <= 1;
      vif.s_cb.hresp <= OKAY;
      vif.s_cb.hrdata <= 0;
      forever begin

        initialize();
        wait(vif.hreset==1);
        fork
          
          drive();
          reset_monitor();

        join_any
        disable fork;
        

      end

    endtask

    task reset_monitor();
        
      wait(vif.hreset==0);        
        
    endtask

    task initialize();
      
      vif.s_cb.hready <= 1;
      vif.s_cb.hresp <= OKAY;
      vif.s_cb.hrdata <= 0;
      // repeat(4)begin
      // @(vif.s_cb);
      // end
      // vif.s_cb.hready <= 0;
      // vif.s_cb.hresp <= OKAY;
      // vif.s_cb.hrdata <= 0;
      
      
      
      
    endtask

    task drive();
      
      forever begin
        seq_item_port.get_next_item(req);
        while (!(vif.s_cb.hsel && vif.hreset)) begin
          @vif.s_cb;
        end

        `uvm_info(get_type_name(), $sformatf("Slave driver item : \n %s", req.convert2string()), UVM_MEDIUM);
        `uvm_info(get_type_name(), $sformatf("Slave responds to address : \n %h", vif.s_cb.haddr ), UVM_MEDIUM);
        
        foreach (req.no_of_waits[i]) begin
          vif.s_cb.hready <= req.no_of_waits[i];
          vif.s_cb.hresp <= OKAY;
          @vif.s_cb;
          if (req.no_of_waits[i] == 1) begin
            if (vif.s_cb.htrans == NONSEQ || vif.s_cb.htrans == SEQ && vif.s_cb.hwrite == READ) begin
            vif.s_cb.hrdata <= req.hrdata;
            end
          end
           
        end


        seq_item_port.item_done();
      
      end

    endtask  



endclass //ahb_slave_driver extends uvm_driver
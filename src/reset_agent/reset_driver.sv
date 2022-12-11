class reset_driver extends uvm_driver#(reset_tx);

    `uvm_component_utils(reset_driver)

    virtual reset_if vif;
    rand int reset_time_ps;
    constraint rst_cnstr { reset_time_ps inside {[1:1000000]}; }
        
    function new(string name = "reset_driver", uvm_component parent);
        super.new(name, parent);
    endfunction

    

    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db#(virtual reset_if)::get(this, "", "reset_if", vif))begin

            `uvm_fatal(get_full_name(), "Cannot get reset VIF from database!")

        end
    endfunction

    // virtual task reset_phase(uvm_phase phase);
    //     phase.raise_objection(this);
    //     vif.r_cb.hreset <= 1'b1;
    //     #15;
    //     vif.r_cb.hreset <= 0;
    //     #( reset_time_ps );
    //     vif.r_cb.hreset <= 1;
    //     phase.drop_objection(this);
    // endtask : reset_phase


    task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("Reset driver run_phase : \n "),UVM_MEDIUM);
        // vif.r_cb.hreset <= 1'b0;
        // #15ns;
        // vif.r_cb.hreset <= 1'b1;

        forever begin
        
            seq_item_port.get_next_item(req);
            vif.r_cb.hreset <= 1'b1;
            repeat(req.ticks_before_reset) @vif.hclk;
            vif.r_cb.hreset <= 1'b0;
            repeat(req.ticks_during_reset) @vif.hclk;
            vif.r_cb.hreset <= 1'b1;
            seq_item_port.item_done(req);

        end
        
    endtask

endclass: reset_driver


        
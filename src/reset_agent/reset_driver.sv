class reset_driver extends uvm_driver#(reset_tx);

    `uvm_component_utils(reset_driver)

    virtual reset_if vif;
        
    function new(string name = "reset_driver", uvm_component parent);
        super.new(name, parent);
    endfunction

    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db#(virtual reset_if)::get(this, "", "reset_if", vif))begin

            `uvm_fatal(get_full_name(), "Cannot get reset VIF from database!")

        end
    endfunction



    task run_phase(uvm_phase phase);
                `uvm_info(get_type_name(), $sformatf("Reset driver run_phase : \n "),UVM_MEDIUM);
        
       
        vif.hreset <= 1'b0;
        repeat(3) @vif.hclk;
        vif.hreset <= 1'b1;
    

        forever begin
            seq_item_port.get_next_item(req);
            reset();
            seq_item_port.item_done(req);
        end
    endtask

    task reset();

            // forever begin
            // vif.r_cb.hreset <= 0;
            // #5;
            // vif.r_cb.hreset <=1;
            // end
    
        if(req.hreset)
        begin
                vif.hreset <= 1'b1;
                @(vif.hclk);
        end
        else
        begin
                vif.hreset <= 1'b0;
                @(vif.hclk);
        end
    endtask



endclass: reset_driver


        
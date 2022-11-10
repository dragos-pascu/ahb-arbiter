class reset_driver extends uvm_driver#(reset_tx);

    `uvm_component_utils(reset_driver)

    virtual master_if vif;
        
    function new(string name = "reset_driver", uvm_component parent);
        super.new(name, parent);
    endfunction

    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db#(virtual master_if)::get(this, "", "master[0]", vif))begin

            `uvm_fatal(get_full_name(), "Cannot get reset VIF from database!")

        end
    endfunction



    task run_phase(uvm_phase phase);
        forever
        begin
            seq_item_port.get_next_item(req);
            reset();
            seq_item_port.item_done(req);
        end
    endtask

    task reset();
        if(req.hreset)
        begin
                //vif.hreset <= 1'b1;
                @(vif.m_cb);
        end
        else
        begin
                //vif.hreset <= 1'b0;
                @(vif.m_cb);
        end
    endtask



endclass: reset_driver



        //Build
        
class ahb_scoreboard extends uvm_scoreboard;
    
    `uvm_component_utils(ahb_scoreboard)
    `uvm_analysis_imp_decl(_predictor)
    `uvm_analysis_imp_decl(_evaluator)
    `uvm_analysis_imp_decl(_request_port)

    uvm_analysis_imp_predictor #(ahb_transaction,ahb_scoreboard) item_collect_predictor;
    uvm_analysis_imp_evaluator #(ahb_transaction,ahb_scoreboard) item_collect_evaluator;
    ahb_transaction expected_transactions[master_number][$];
    ahb_transaction actual_transactions[master_number][$];

    virtual request_if req_if;

    ahb_transaction expected_tx;
    ahb_transaction temp_tx;
    ahb_transaction temp_tx1;
    int match, mismatch;
    int predictor_transactions;
    int evaluator_transactions;
    function new(string name = "ahb_scoreboard", uvm_component parent);
        super.new(name, parent);
        item_collect_predictor = new("item_collect_predictor",this);
        item_collect_evaluator =  new("item_collect_evaluator",this);
        match = 0;
        mismatch = 0;
        predictor_transactions = 0;
        evaluator_transactions = 0;
    endfunction 

    function void build_phase(uvm_phase phase);
    super.build_phase(phase);
        
        if (!uvm_config_db #(virtual request_if)::get(null, "", "req_if", req_if))
            `uvm_fatal(get_type_name(), $sformatf("Failed to retrive busrequest interface"))
       

    endfunction

    function void write_predictor(ahb_transaction master_item);
        `uvm_info(get_type_name(), $sformatf("Received from master[%0d] : \n %s", master_item.id,master_item.convert2string()), UVM_MEDIUM);
        expected_transactions[master_item.id].push_back(master_item);
        predictor_transactions++;
    endfunction

    function void write_evaluator(ahb_transaction slave_item);
        `uvm_info(get_type_name(), $sformatf("Received from slave : \n %s",slave_item.convert2string()), UVM_MEDIUM);
        
        if (expected_transactions[slave_item.id].size == 0) begin
            `uvm_error(get_type_name(),"Queue is empty")
        end else begin
            temp_tx1 =  expected_transactions[slave_item.id].pop_front();
            if (slave_item.compare(temp_tx1)) begin
            match++;
            end
            else begin
                
                mismatch++;
                `uvm_error(get_type_name(),"Mismatch : ")
                `uvm_error(get_type_name(), $sformatf("Expected : \n %s",temp_tx1.convert2string()));
                `uvm_error(get_type_name(), $sformatf(" Received : \n %s",slave_item.convert2string()));

            end
        end
        
        
        evaluator_transactions++;
    endfunction


    virtual function void check_phase(uvm_phase phase);
        
        if (predictor_transactions!=evaluator_transactions) begin
            `uvm_error(get_type_name(),$sformatf(" Number of master/slave transactions mismatch; nr of master_tx = [%0d] , nr of slave_tx = [%0d] ",predictor_transactions, evaluator_transactions));
        end else begin
            `uvm_info(get_type_name(),$sformatf("Scb recived %0d transactions .",predictor_transactions),UVM_MEDIUM);
        end

        `uvm_info(get_type_name(),$sformatf("Matches: %0d ",match),UVM_MEDIUM);
        `uvm_info(get_type_name(),$sformatf("Mismatches: %0d ",mismatch),UVM_MEDIUM);

    endfunction
endclass
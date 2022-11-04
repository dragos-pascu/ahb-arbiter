class ahb_scoreboard extends uvm_scoreboard;
    
    `uvm_component_utils(ahb_scoreboard)
    `uvm_analysis_imp_decl(_predictor)
    `uvm_analysis_imp_decl(_evaluator)
    `uvm_analysis_imp_decl(_request_port)
    `uvm_analysis_imp_decl(_cov_port)

    uvm_analysis_imp_predictor #(ahb_transaction,ahb_scoreboard) item_collect_predictor;
    uvm_analysis_imp_evaluator #(ahb_transaction,ahb_scoreboard) item_collect_evaluator;

    uvm_analysis_port #(ahb_transaction) coverage_port;

    
    ahb_transaction expected_transactions[$];
    ahb_transaction actual_transactions[$];


    ahb_transaction expected_tx;
    ahb_transaction temp_expected;
    int match, mismatch;
    int predictor_transactions;
    int evaluator_transactions;
    function new(string name = "ahb_scoreboard", uvm_component parent);
        super.new(name, parent);
        item_collect_predictor = new("item_collect_predictor",this);
        item_collect_evaluator =  new("item_collect_evaluator",this);
        coverage_port = new("coverage_port",this);
        match = 0;
        mismatch = 0;
        predictor_transactions = 0;
        evaluator_transactions = 0;
    endfunction 

    function void build_phase(uvm_phase phase);
    super.build_phase(phase);
        

    endfunction

    function void write_predictor(ahb_transaction master_item);
        `uvm_info(get_type_name(), $sformatf("Received from master[%0d] : \n %s", master_item.id,master_item.convert2string()), UVM_HIGH);
        expected_transactions.push_back(master_item);
        predictor_transactions++;
    endfunction

    function void write_evaluator(ahb_transaction slave_item);
        `uvm_info(get_type_name(), $sformatf("Received from slave : \n %s",slave_item.convert2string()), UVM_HIGH);
        
        temp_expected = ahb_transaction::type_id::create("temp_expected");
        temp_expected = expected_transactions.pop_front();
        if (slave_item.compare(temp_expected)) begin
            match++;
            coverage_port.write(temp_expected);
        end else begin
                
            mismatch++;
            `uvm_error(get_type_name(),"Mismatch : ")
            `uvm_error(get_type_name(), $sformatf("Expected : \n %s",temp_expected.convert2string()));
            `uvm_error(get_type_name(), $sformatf(" Received : \n %s",slave_item.convert2string()));
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
class ahb_scoreboard extends uvm_scoreboard;
    
    `uvm_component_utils(ahb_scoreboard)
    `uvm_analysis_imp_decl(_predictor)
    `uvm_analysis_imp_decl(_evaluator)

    uvm_analysis_imp_predictor #(ahb_transaction,ahb_scoreboard) item_collect_predictor;
    uvm_analysis_imp_evaluator #(ahb_transaction,ahb_scoreboard) item_collect_evaluator;
    ahb_transaction expected_transactions[master_number][$];
    ahb_transaction actual_transactions[master_number][$];


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
    endfunction

    // function void write_predictor(ahb_transaction master_item);
    //     `uvm_info(get_type_name(), $sformatf("Received from master[%0d] : \n %s", master_item.id,master_item.convert2string()), UVM_MEDIUM);
    //     expected_transactions[master_item.id].push_back(master_item);
    //         foreach (actual_transactions[master_item.id][i]) begin
    //             temp_tx = actual_transactions[master_item.id][i];
    //             $display("%s",temp_tx.convert2string());
    //             if (temp_tx.compare(master_item)) begin
    //                 match++;
    //                 actual_transactions[master_item.id].delete(i); 
    //                 // if match found between refrence model ( master_item) and DUT output, delete from actual
    //                 //else push the item in expected
    //             end
    //             else begin
    //                 mismatch++;
    //             end
                
    //         end

    //     predictor_transactions++;
    // endfunction

    // function void write_evaluator(ahb_transaction slave_item);
    //     `uvm_info(get_type_name(), $sformatf("Received from slave : \n %s",slave_item.convert2string()), UVM_MEDIUM);
    //     actual_transactions[slave_item.id].push_back(slave_item);
    //         foreach (expected_transactions[slave_item.id][i]) begin
    //             ahb_transaction temp_tx1 = ahb_transaction::type_id::create("temp_tx1");
    //             temp_tx1 = expected_transactions[slave_item.id][i];
    //             $display("%s",temp_tx1.convert2string());
    //             if (temp_tx1.compare(slave_item)) begin
    //                 match++;
    //                 expected_transactions[slave_item.id].delete(i); 
    //                 // if match found between DUT actual transaction (slave_item) and refrence model transaction,
    //                 //delete from expected transactions
    //                 //else push it in actual transactions
    //             end
    //             else begin                    
    //                 mismatch++;
    //             end
                
    //         end

    //     evaluator_transactions++;
    // endfunction

    // function void write_predictor(ahb_transaction master_item);
    //     `uvm_info(get_type_name(), $sformatf("Received from master[%0d] : \n %s", master_item.id,master_item.convert2string()), UVM_MEDIUM);
    //     temp_tx =  actual_transactions[master_item.id].pop_front();
    //     if (temp_tx.compare(master_item)) begin
    //         match++;
    //     end
    //     else begin
    //         expected_transactions[master_item.id].push_back(master_item);
    //         actual_transactions[master_item.id].push_back(temp_tx);
    //     end

    //     predictor_transactions++;
    // endfunction
    
    // function void write_evaluator(ahb_transaction slave_item);
    //     `uvm_info(get_type_name(), $sformatf("Received from slave : \n %s",slave_item.convert2string()), UVM_MEDIUM);
        
    //     temp_tx1 =  expected_transactions[slave_item.id].pop_front();
    //     if (temp_tx1.compare(slave_item)) begin
    //         match++;
    //     end
    //     else begin

    //         actual_transactions[slave_item.id].push_back(slave_item);
    //         expected_transactions[slave_item.id].push_back(temp_tx1);
            
    //     end
        
    //     evaluator_transactions++;
    // endfunction

    function void write_predictor(ahb_transaction master_item);
        // `uvm_info(get_type_name(), $sformatf("Received from master[%0d] : \n %s", master_item.id,master_item.convert2string()), UVM_MEDIUM);
        // expected_transactions[master_item.id].push_back(master_item);
        // predictor_transactions++;
    endfunction

    function void write_evaluator(ahb_transaction slave_item);
        // `uvm_info(get_type_name(), $sformatf("Received from slave : \n %s",slave_item.convert2string()), UVM_MEDIUM);
        
        // temp_tx1 =  expected_transactions[slave_item.id].pop_front();
        // assert (temp_tx1 != null);

        // if (slave_item.compare(temp_tx1)) begin
        //     match++;
        // end
        // else begin

        //     mismatch++;
            
        // end
        
        // evaluator_transactions++;
    endfunction


    // virtual function void run_phase(uvm_phase phase);
        

    // endfunction 

    virtual function void check_phase(uvm_phase phase);
        
        if (predictor_transactions!=evaluator_transactions) begin
            `uvm_error(get_type_name(),$sformatf(" Number of master/slave transactions mismatch; nr of master_tx = [%0d] , nr of slave_tx = [%0d] ",predictor_transactions, evaluator_transactions));
        end else begin
            `uvm_info(get_type_name(),$sformatf("Scb recived %0d transactions",predictor_transactions),UVM_MEDIUM);
        end

        `uvm_info(get_type_name(),$sformatf("Matches: %0d ",match),UVM_MEDIUM);
        `uvm_info(get_type_name(),$sformatf("Mismatches: %0d ",mismatch),UVM_MEDIUM);

    endfunction
endclass
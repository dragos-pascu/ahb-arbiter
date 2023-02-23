class ahb_scoreboard extends uvm_scoreboard;
    
    `uvm_component_utils(ahb_scoreboard)
    `uvm_analysis_imp_decl(_predictor)
    `uvm_analysis_imp_decl(_evaluator)

    uvm_analysis_imp_predictor #(ahb_transaction,ahb_scoreboard) item_collect_predictor;
    uvm_analysis_imp_evaluator #(ahb_transaction,ahb_scoreboard) item_collect_evaluator;

    uvm_analysis_port #(ahb_transaction) coverage_port;
    bit enable_coverage;
    
    ahb_transaction expected_transactions[slave_number][$];
    ahb_transaction coverage_queue[$];
    ahb_transaction temp_cov;


    ahb_transaction expected_tx;
    ahb_transaction temp_tx;
    ahb_transaction temp_tx1;
    int match, mismatch;
    int predictor_transactions;
    int evaluator_transactions;

    int current_tag;
    int previours_tag;
    int flag_mismatch= 0 ;


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
        if (enable_coverage) begin
            coverage_port = new("coverage_port",this);
        end
    endfunction

    function void write_predictor(ahb_transaction master_item);
        int i;
        
        if (master_item.htrans[0] == NONSEQ) begin
                    predictor_transactions++;
        end

        for (i=0; i<slave_number; ++i) begin
            if((master_item.haddr[0] >= slave_low_address[i]) && (master_item.haddr[0] <= slave_high_address[i] )) begin
                expected_transactions[i].push_back(master_item); // i represents the slave number.
                
                `uvm_info(get_type_name(), $sformatf("Received from master[%0d] : \n %s", master_item.id,master_item.convert2string()), UVM_MEDIUM);

                break;
            end     
        end
        if (i>=slave_number) begin
            `uvm_info(get_type_name(),$sformatf("Unmaped transaction not to be matched, haddr: %h",master_item.haddr[0]),UVM_MEDIUM);
        end
        
    endfunction

    function void write_evaluator(ahb_transaction slave_item);
        `uvm_info(get_type_name(), $sformatf("Received from slave : \n %s",slave_item.convert2string()), UVM_DEBUG);
        fork 
            begin
                #1;
                if (expected_transactions[slave_item.id].size == 0) begin
                    `uvm_error(get_type_name(),"Queue is empty")
                end else begin
                    temp_tx1 =  expected_transactions[slave_item.id].pop_front();
                    previours_tag = current_tag;
                    current_tag = temp_tx1.tag;
                    if (slave_item.compare(temp_tx1)) begin
                        coverage_queue.push_back(temp_tx1);
                    end
                    else begin
                        flag_mismatch = 1;
                        `uvm_error(get_type_name(),"MISMATCH : ")
                        `uvm_error(get_type_name(), $sformatf("Expected : \n %s",temp_tx1.convert2string()));
                        `uvm_error(get_type_name(), $sformatf(" Received : \n %s",slave_item.convert2string()));
                    end
                    //this means that a new transaction came and I can send to coverage.
                    if (current_tag!=previours_tag) begin
                        
                        evaluator_transactions++;

                        if (flag_mismatch) begin
                            //flush quueue and increment mismatch;
                            coverage_queue.delete();
                            mismatch++;
                            `uvm_info(get_type_name(), $sformatf("MISMATCH for tag : \n %d",previours_tag),UVM_MEDIUM);

                        end else begin
                            //send the coverage queue to coverage and increment match.
                            match++;
                            `uvm_info(get_type_name(), $sformatf("MATCH for tag : \n %d",previours_tag),UVM_MEDIUM);
                            if (enable_coverage) begin
                                while (coverage_queue.size > 0) begin
                                    temp_cov = coverage_queue.pop_front();
                                    coverage_port.write(temp_cov);

                                end

                            end
                        end
                        flag_mismatch = 0;
                    end
                end
            end
        join_none

    endfunction

    

    virtual function void check_phase(uvm_phase phase);
        foreach (expected_transactions[id]) begin
            while (expected_transactions[id].size > 0) begin
            temp_tx = expected_transactions[id].pop_front();
                `uvm_info(get_type_name(), $sformatf("Scoreboard received an unmatched : %s",temp_tx.convert2string()), UVM_MEDIUM);

            end
        end
        

        if (predictor_transactions!=evaluator_transactions) begin
            `uvm_error(get_type_name(),$sformatf(" Number of master/slave transactions mismatch; nr of master_tx = [%0d] , nr of slave_tx = [%0d] ",predictor_transactions, evaluator_transactions));
        end else begin
            `uvm_info(get_type_name(),$sformatf("Scb recived %0d transactions .",predictor_transactions),UVM_MEDIUM);
        end

        `uvm_info(get_type_name(),$sformatf("Matches: %0d ",match),UVM_MEDIUM);
        `uvm_info(get_type_name(),$sformatf("Mismatches: %0d ",mismatch),UVM_MEDIUM);

    endfunction
endclass
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

    int transfer_size;
    int transfer_index = 0;
    ahb_transaction mapped_transaction;
    int unmapped[];


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

    function ahb_transaction create_item(ahb_transaction tx);
        ahb_transaction item;
        item = ahb_transaction::type_id::create("item");
        case (tx.hburst)
        SINGLE : transfer_size = 1;
        INCR4 : transfer_size = 4;
        WRAP4 : transfer_size = 4;
        INCR8 : transfer_size = 8;
        WRAP8 : transfer_size = 8;
        INCR16 : transfer_size = 16;
        WRAP16 : transfer_size = 16;
        endcase
    
        item.htrans = new[transfer_size];
        item.haddr = new[transfer_size];
        item.hwdata = new[transfer_size];
        unmapped = new[transfer_size];
        //addresses_maped = new[transfer_size];

        return item;
    endfunction


    function void write_predictor(ahb_transaction master_item);
        
        int i;
        int k=0;
        mapped_transaction = create_item(master_item); // created a transaction with size of transfer_size
        
        //check for each address inside the master_item if it is inside any of the slave_low of slave_high;
        for (int j=0; j<transfer_size; ++j) begin
            for (i=0; i<slave_number; ++i) begin
                if((master_item.haddr[j] >= slave_low_address[i]) && (master_item.haddr[j] <= slave_high_address[i] )) begin
                    
                    mapped_transaction.copy(master_item);
                    mapped_transaction.haddr[k] = master_item.haddr[j];
                    mapped_transaction.hwdata[k] = master_item.hwdata[j];
                    mapped_transaction.htrans[k] = master_item.htrans[j];
                    k++;
                    unmapped[j] = 1;
                    //copy in the new transaction item the mapped address,data and htrans and in a hashmap put 1 so you know it was mapped.
            end
            end
            
        end
        expected_transactions[i].push_back(mapped_transaction); // i represents the slave number.
        predictor_transactions++;
        `uvm_info(get_type_name(), $sformatf("Received from master[%0d] : \n %s", mapped_transaction.id,mapped_transaction.convert2string()), UVM_MEDIUM);
        for (i=0; i<transfer_size; ++i) begin
            if (!unmapped[i]) begin
                `uvm_info(get_type_name(),$sformatf("Unmapped transaction not to be matched, haddr: %h",master_item.haddr[i]),UVM_MEDIUM);
            end
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

        evaluator_transactions++;
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
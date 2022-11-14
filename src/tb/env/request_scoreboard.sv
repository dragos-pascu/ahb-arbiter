class request_scoreboard extends uvm_scoreboard;
    
    `uvm_component_utils(request_scoreboard)
    `uvm_analysis_imp_decl(_request_port)

    uvm_tlm_analysis_fifo #(ahb_request) analysis_fifo[master_number];
    uvm_tlm_analysis_fifo #(ahb_request) response;

    int match_nr  = 0;
    int mismatches =0;
    //ap for coverage
    uvm_analysis_port #(ahb_request) coverage_port;
    
    ahb_request predicted_transactions[$];
    ahb_request predicted_response;

    ahb_request requests_array[master_number];

    bit busreq_map[master_number];
    bit hlock_map[master_number];
    bit req_and_lock[master_number];

    int previous_grant = master_number - 1;
    int response_ready;

    function new(string name = "request_scoreboard", uvm_component parent);
        super.new(name, parent);
        
        coverage_port = new("coverage_port",this);

        for (int i=0; i<master_number; ++i) begin
            analysis_fifo[i] = new($sformatf("analysis_fifo[%0d]",i),this);
        end
        
    endfunction 

    function void build_phase(uvm_phase phase);
    super.build_phase(phase);
        

    endfunction


    task run_phase(uvm_phase phase);
    forever begin
        

        // block the execution and get requests for all masters
        
        
        predictor();
        evaluator();

    end

    endtask
    
    task predictor();
        fork
        for ( int  i=0; i<master_number; ++i) begin
            automatic int j = i;
            //https://verificationacademy.com/verification-methodology-reference/uvm/docs_1.1d/html/files/tlm1/uvm_tlm_ifs-svh.html#uvm_tlm_if_base#(T1,T2)
            analysis_fifo[j].get(requests_array[j]);
        end
        join

        
        for (int i=0; i<master_number; ++i) begin
            `uvm_info(get_type_name(), $sformatf("Request from  master[%0d] : \n %s", requests_array[i].id,requests_array[i].convert2string()), UVM_DEBUG);
        end 
        store_in_map();
        predict_grant();
        clear_maps();

         `uvm_info(get_type_name(),"///////////////////", UVM_DEBUG);
    endtask

    
    function void store_in_map();
        for (int i=0; i<master_number; ++i) begin
            if (requests_array[i].hbusreq == 1) begin
                busreq_map[requests_array[i].id] = 1;
            end
            if (requests_array[i].hlock == 1) begin
                hlock_map[requests_array[i].id] = 1;
            end
            req_and_lock[requests_array[i].id] = busreq_map[requests_array[i].id] & hlock_map[requests_array[i].id];
        end 
        `uvm_info(get_type_name(), $sformatf("busreq_map : %p \n ", busreq_map), UVM_DEBUG);
        `uvm_info(get_type_name(), $sformatf("hlock_map : %p \n ", hlock_map), UVM_DEBUG);
        //`uvm_info(get_type_name(), $sformatf("req_and_lock : %p \n ", req_and_lock), UVM_HIGH);


    endfunction


    function void clear_maps();
        for (int i=0; i<master_number; ++i) begin
                busreq_map[requests_array[i].id] = 0;
                hlock_map[requests_array[i].id] = 0;
                req_and_lock[requests_array[i].id] = 0;
            
        end 
        `uvm_info(get_type_name(), $sformatf("clear_maps FINISHED \n "), UVM_DEBUG);
        `uvm_info(get_type_name(), $sformatf("busreq_map : %p \n ", busreq_map), UVM_DEBUG);
        `uvm_info(get_type_name(), $sformatf("hlock_map : %p \n ", hlock_map), UVM_DEBUG);
        `uvm_info(get_type_name(), $sformatf("req_and_lock : %p \n ", req_and_lock), UVM_DEBUG);


    endfunction

    function void predict_grant();

        int highest_priority_master = master_number - 1;
        for (int i=0; i<master_number; ++i) begin
            if (busreq_map[i] == 1 ) begin
                if( highest_priority_master > i )
                    highest_priority_master = i;
            end
        end
        predicted_response = ahb_request::type_id::create("predicted_response");
        predicted_response.grant_number = highest_priority_master;
        //`uvm_info(get_type_name(), $sformatf("Predicted response is : %s \n ", predicted_response.convert2string()), UVM_HIGH);
        `uvm_info(get_type_name(), $sformatf("Predicted grant is : %d \n ", highest_priority_master), UVM_HIGH);
        
        predicted_transactions.push_front(predicted_response);


    endfunction

    task evaluator();
        ahb_request temp_predicted;
        ahb_request temp_actual; //= ahb_request::type_id::create("temp_actual");
        #1
        response.get(temp_actual);


        temp_predicted = predicted_transactions.pop_front();
 
        
        if (temp_actual.grant_number == temp_predicted.grant_number) begin
            match_nr++;
        end else begin
            mismatches++;
            `uvm_info(get_type_name(), $sformatf("Bus request was unmatched : %s",temp_predicted.convert2string()), UVM_MEDIUM);
        end
    endtask

    // function void predict_grant();
    //     int highest_priority_master = master_number - 1;
    //     for (int i=0; i<master_number; ++i) begin
    //         if (busreq_map[i] == 1 ) begin
    //             if( highest_priority_master > i )
    //                 highest_priority_master = i;
    //         end
    //     end
    //     if (highest_priority_master < previous_grant) begin
    //         if (busreq_map[previous_grant]) begin
    //             if (hlock_map[previous_grant]) begin
    //                 previous_grant = previous_grant;
    //                 //send packet with grant being the same 
    //                 `uvm_info(get_type_name(), $sformatf("Urmatorul grant o sa fie : %d \n ", previous_grant), UVM_HIGH);

    //             end else begin
    //                 //send packet with grant being highest_priority_master
    //                 previous_grant = highest_priority_master;
    //                 `uvm_info(get_type_name(), $sformatf("Urmatorul grant o sa fie : %d \n ", previous_grant), UVM_HIGH);

    //             end
                
    //         end else begin
    //             if (hlock_map[previous_grant]) begin
    //                 previous_grant = previous_grant;
    //                 `uvm_info(get_type_name(), $sformatf("Urmatorul grant o sa fie : %d \n ", previous_grant), UVM_HIGH);
    //             end
    //             else begin
    //                 previous_grant = highest_priority_master;
    //                 `uvm_info(get_type_name(), $sformatf("Urmatorul grant o sa fie : %d \n ", previous_grant), UVM_HIGH);
    //             end
                    


    //         end 

    //     end
    // endfunction
    virtual function void check_phase(uvm_phase phase);
        

        // if (predictor_transactions!=evaluator_transactions) begin
        //     `uvm_error(get_type_name(),$sformatf(" Number of master/slave transactions mismatch; nr of master_tx = [%0d] , nr of slave_tx = [%0d] ",predictor_transactions, evaluator_transactions));
        // end else begin
        //     `uvm_info(get_type_name(),$sformatf("Scb recived %0d transactions .",predictor_transactions),UVM_MEDIUM);
        // end

        `uvm_info(get_type_name(),$sformatf("Matches: %0d ",match_nr),UVM_MEDIUM);
        `uvm_info(get_type_name(),$sformatf("Mismatches: %0d ",mismatches),UVM_MEDIUM);

    endfunction

endclass

        
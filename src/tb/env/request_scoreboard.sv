class request_scoreboard extends uvm_scoreboard;
    
    `uvm_component_utils(request_scoreboard)
    `uvm_analysis_imp_decl(_request_port)

    uvm_tlm_analysis_fifo #(ahb_request) request_fifo[master_number];
    //uvm_tlm_analysis_fifo #(ahb_request) response_fifo;
    uvm_tlm_analysis_fifo #(ahb_request) response_fifo[master_number];


    int match_nr  = 0;
    int mismatches = 0;
    //ap for coverage
    uvm_analysis_port #(ahb_request) coverage_port;
    
    ahb_request predicted_transactions[$];
    ahb_request predicted_response;

    ahb_request requests_array[master_number];
    ahb_request response_array[master_number];

    bit busreq_map[master_number];
    bit hlock_map[master_number];
    bit req_and_lock[master_number];

    int previous_granted_master = master_number - 1;

    function new(string name = "request_scoreboard", uvm_component parent);
        super.new(name, parent);
        
        coverage_port = new("coverage_port",this);

        for (int i=0; i<master_number; ++i) begin
            request_fifo[i] = new($sformatf("request_fifo[%0d]",i),this);
        end
        for (int i=0; i<master_number; ++i) begin
            response_fifo[i] = new($sformatf("response_fifo[%0d]",i),this);
        end
        
    endfunction 

    function void build_phase(uvm_phase phase);
    super.build_phase(phase);
        

    endfunction


    task run_phase(uvm_phase phase);

        fork
        predictor();
        evaluator();
        join
        

    endtask
    
    task predictor();
        forever begin
            
            fork
            for ( int  i=0; i<master_number; ++i) begin
                automatic int j = i;
                //https://verificationacademy.com/verification-methodology-reference/uvm/docs_1.1d/html/files/tlm1/uvm_tlm_ifs-svh.html#uvm_tlm_if_base#(T1,T2)
                request_fifo[j].get(requests_array[j]);
            end
            join


            for (int i=0; i<master_number; ++i) begin
                `uvm_info(get_type_name(), $sformatf("Request from  master[%0d] : \n %s", requests_array[i].id,requests_array[i].convert2string()), UVM_DEBUG);
            end 
            store_in_map();
            predict_grant();
            clear_maps();

             `uvm_info(get_type_name(),"///////////////////", UVM_DEBUG);
        end

        
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



    task evaluator();
        ahb_request temp_predicted;
        ahb_request temp_actual; //= ahb_request::type_id::create("temp_actual");
        forever begin 

            fork : fork_evaluator
            for ( int  i=0; i<master_number; ++i) begin
                automatic int j = i;
                response_fifo[j].get(response_array[j]);
            end
            join

            temp_predicted = predicted_transactions.pop_front();


            if (response_array[temp_predicted.grant_number].hgrant == 1) begin
                match_nr++;
                //collect coverage
                //coverage_port.write(response_array[temp_predicted.grant_number]);
                coverage_port.write(temp_predicted);

            end else begin
                mismatches++;
                `uvm_info(get_type_name(), $sformatf("Bus request was unmatched "), UVM_MEDIUM);
                `uvm_info(get_type_name(), $sformatf("Predicted response was  : %d",temp_predicted.grant_number), UVM_MEDIUM);
                `uvm_info(get_type_name(), $sformatf("Actual response : %s", response_array[temp_predicted.grant_number].convert2string()), UVM_MEDIUM);
            end


        end
        
        
        
    endtask

    function void predict_grant();
        int highest_priority_master = master_number - 1;
        for (int i=0; i<master_number; ++i) begin
            if (busreq_map[i] == 1 ) begin
                if( highest_priority_master > i )
                    highest_priority_master = i;
            end
        end
        //check which master number is lower to asses priority
        if (highest_priority_master > previous_granted_master) begin
            if (busreq_map[previous_granted_master]) begin
                if (hlock_map[previous_granted_master]) begin
                    previous_granted_master = previous_granted_master;
                    //if busreq and hlock is 1 the granted master will remain the same 
                    predicted_response = ahb_request::type_id::create("predicted_response");
                    predicted_response.grant_number = previous_granted_master;
                    predicted_response.hbusreq = 1;
                    predicted_response.hlock = 1;
                    `uvm_info(get_type_name(), $sformatf("Predicted grant is : %d \n ", predicted_response.grant_number), UVM_DEBUG);

                    predicted_transactions.push_front(predicted_response);

                end
                else begin
                    previous_granted_master = highest_priority_master;
                    //if busreq is 1 and hlock is 0 the granted master will become "highest_priority_master" 
                    predicted_response = ahb_request::type_id::create("predicted_response");
                    predicted_response.grant_number = previous_granted_master;
                    `uvm_info(get_type_name(), $sformatf("Predicted grant is : %d \n ", predicted_response.grant_number), UVM_DEBUG);

                    predicted_transactions.push_front(predicted_response);                
                end
            end else begin
                //if busreq is 0 the bus goes to "highest_priority_master"
                previous_granted_master = highest_priority_master;

                predicted_response = ahb_request::type_id::create("predicted_response");
                predicted_response.grant_number = previous_granted_master;
                `uvm_info(get_type_name(), $sformatf("Predicted grant is : %d \n ", predicted_response.grant_number), UVM_DEBUG);

                predicted_transactions.push_front(predicted_response);     

            end

        end else begin
            //if the busreq with highest priority is from "highest_priority_master"
            previous_granted_master = highest_priority_master;

            predicted_response = ahb_request::type_id::create("predicted_response");
            predicted_response.grant_number = previous_granted_master;
            `uvm_info(get_type_name(), $sformatf("Predicted grant is : %d \n ", predicted_response.grant_number), UVM_DEBUG);

            predicted_transactions.push_front(predicted_response);     

        end 

        
    endfunction



    virtual function void check_phase(uvm_phase phase);
        

        `uvm_info(get_type_name(),$sformatf("BUSREQ SCB: "),UVM_MEDIUM);
        `uvm_info(get_type_name(),$sformatf("Matches: %0d ",match_nr),UVM_MEDIUM);
        `uvm_info(get_type_name(),$sformatf("Mismatches: %0d ",mismatches),UVM_MEDIUM);

    endfunction

endclass

        
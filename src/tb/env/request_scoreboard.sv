class request_scoreboard extends uvm_scoreboard;
    
    `uvm_component_utils(request_scoreboard)
    `uvm_analysis_imp_decl(_predictor)
    `uvm_analysis_imp_decl(_evaluator)
    `uvm_analysis_imp_decl(_request_port)

    uvm_tlm_analysis_fifo #(ahb_request) analysis_fifo[master_number];

    //ap for coverage
    uvm_analysis_port #(ahb_request) coverage_port;


    ahb_request requests_array[master_number];

    bit busreq_map[master_number];
    bit hlock_map[master_number];
    bit req_and_lock[master_number];


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
        

        receive_requests();
        // block the execution and get requests for all masters
        predictor();

    end

    endtask
    
    task receive_requests();
        fork
        for ( int  i=0; i<master_number; ++i) begin
            automatic int j = i;
            //https://verificationacademy.com/verification-methodology-reference/uvm/docs_1.1d/html/files/tlm1/uvm_tlm_ifs-svh.html#uvm_tlm_if_base#(T1,T2)
            analysis_fifo[j].get(requests_array[j]);
        end
        join
    endtask

    function void predictor();
    for (int i=0; i<master_number; ++i) begin
        `uvm_info(get_type_name(), $sformatf("Request from  master[%0d] : \n %s", requests_array[i].id,requests_array[i].convert2string()), UVM_HIGH);

        end 
        store_in_map();
        get_expected_grant();
        clear_maps();

         `uvm_info(get_type_name(),"///////////////////", UVM_HIGH);
    endfunction
    
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
        `uvm_info(get_type_name(), $sformatf("busreq_map : %p \n ", busreq_map), UVM_HIGH);
        `uvm_info(get_type_name(), $sformatf("hlock_map : %p \n ", hlock_map), UVM_HIGH);
        `uvm_info(get_type_name(), $sformatf("req_and_lock : %p \n ", req_and_lock), UVM_HIGH);


    endfunction

    function void clear_maps();
        for (int i=0; i<master_number; ++i) begin
                busreq_map[requests_array[i].id] = 0;
                hlock_map[requests_array[i].id] = 0;
                req_and_lock[requests_array[i].id] = 0;
            
        end 
        `uvm_info(get_type_name(), $sformatf("clear_maps FINISHED \n "), UVM_HIGH);
        `uvm_info(get_type_name(), $sformatf("busreq_map : %p \n ", busreq_map), UVM_HIGH);
        `uvm_info(get_type_name(), $sformatf("hlock_map : %p \n ", hlock_map), UVM_HIGH);
        `uvm_info(get_type_name(), $sformatf("req_and_lock : %p \n ", req_and_lock), UVM_HIGH);


    endfunction

    function void get_expected_grant();
        int highest_priority_master;
        // for (int i=0; i<master_number; ++i) begin
        //     // if (busreq_map) begin
        //     //     pass
        //     // end
        // end
    endfunction

endclass

        
class request_scoreboard extends uvm_scoreboard;
    
    `uvm_component_utils(request_scoreboard)
    `uvm_analysis_imp_decl(_predictor)
    `uvm_analysis_imp_decl(_evaluator)
    `uvm_analysis_imp_decl(_request_port)

    uvm_analysis_imp_predictor #(ahb_request,request_scoreboard) req_collect_predictor;
    uvm_tlm_analysis_fifo #(ahb_request) analysis_fifo;
    uvm_analysis_imp_evaluator #(ahb_request,request_scoreboard) req_collect_evaluator;

    ahb_transaction expected_response[master_number][$];
    ahb_transaction actual_response[master_number][$];
    int map[master_number];

    function new(string name = "request_scoreboard", uvm_component parent);
        super.new(name, parent);
        req_collect_predictor = new("req_collect_predictor",this);
        req_collect_evaluator =  new("req_collect_evaluator",this);

        analysis_fifo = new("analysis_fifo",this);
    endfunction 

    function void build_phase(uvm_phase phase);
    super.build_phase(phase);
        

    endfunction

    /*Take from predictor the request and predit a grant.*/
    /* Daca queue.size este diferit de 0 la final inseamna ca au ramas masteri fara sa primeasca grant*/

    function void write_predictor(ahb_request request_item);
        `uvm_info(get_type_name(), $sformatf("Request from  master[%0d] : \n %s", request_item.id,request_item.convert2string()), UVM_MEDIUM);
        //expected_transactions[request_item.id].push_back(request_item);
        for (int i=0; i<master_number; ++i) begin
        end
    endfunction

    /*Compare the actual grant bit with the predicted value. Actual grant vine */

    function void write_evaluator(ahb_request slave_item);
       
    endfunction


    virtual function void check_phase(uvm_phase phase);
        

    endfunction
endclass
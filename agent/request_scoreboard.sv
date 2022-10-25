class request_scoreboard extends uvm_scoreboard;
    
    `uvm_component_utils(request_scoreboard)
    `uvm_analysis_imp_decl(_predictor)
    `uvm_analysis_imp_decl(_evaluator)
    `uvm_analysis_imp_decl(_request_port)

    uvm_analysis_imp_predictor #(ahb_transaction,request_scoreboard) item_collect_predictor;
    uvm_analysis_imp_evaluator #(ahb_transaction,request_scoreboard) item_collect_evaluator;

    virtual request_if req_if;

    function new(string name = "request_scoreboard", uvm_component parent);
        super.new(name, parent);
        item_collect_predictor = new("item_collect_predictor",this);
        item_collect_evaluator =  new("item_collect_evaluator",this);
    endfunction 

    function void build_phase(uvm_phase phase);
    super.build_phase(phase);
        
        if (!uvm_config_db #(virtual request_if)::get(null, "", "req_if", req_if))
            `uvm_fatal(get_type_name(), $sformatf("Failed to retrive busrequest interface"))
       

    endfunction

    function void write_predictor(ahb_transaction master_item);
        
    endfunction

    function void write_evaluator(ahb_transaction slave_item);
       
    endfunction


    virtual function void check_phase(uvm_phase phase);
        

    endfunction
endclass
class ahb_scoreboard extends uvm_scoreboard;
    
    `uvm_component_utils(ahb_scoreboard)
    `uvm_analysis_imp_decl(_master)
    `uvm_analysis_imp_decl(_slave)

    uvm_analysis_imp_master #(ahb_transaction,ahb_scoreboard) item_collect_master;
    uvm_analysis_imp_slave #(ahb_transaction,ahb_scoreboard) item_collect_slave;
    ahb_transaction item_q[master_number][$];
    
    function new(string name = "ahb_scoreboard", uvm_component parent);
        super.new(name, parent);
        item_collect_master = new("item_collect_master",this);
        item_collect_slave =  new("item_collect_slave",this);
    endfunction 

    function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    endfunction

    function void write_master(ahb_transaction req);
        `uvm_info(get_type_name(), $sformatf("Received transaction from master[%0d] =", req.id), UVM_MEDIUM);
        req.print();
        item_q[req.id].push_back(req);
    endfunction

    function void write_slave(ahb_transaction req);
    endfunction
    
    // task run_phase(uvm_phase phase);
        
    //     ahb_transaction item;

    //     forever begin
    //         wait(item_q.size() > 0);
            
    //         if(item_q.size > 0) begin
    //         item = item_q.pop_front();
    //         end
            

    //     end

    // endtask

endclass
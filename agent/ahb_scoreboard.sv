class ahb_scoreboard extends uvm_scoreboard;
    
    `uvm_component_utils(ahb_scoreboard)

    uvm_analysis_imp #(ahb_transaction,ahb_scoreboard) item_collect_receive;

    function new(string name = "ahb_scoreboard", uvm_component parent);
        super.new(name, parent);
        item_collect_receive = new("item_collect_receive",this);
    endfunction 

    function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    endfunction

    function void write(ahb_transaction req);
        //add write logic
    endfunction

endclass
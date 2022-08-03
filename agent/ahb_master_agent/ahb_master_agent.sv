class ahb_master_agent extends uvm_agent;
    
    `uvm_component_utils(ahb_master_agent)

    ahb_master_driver ahb_mdriver;
    ahb_sequencer sequencer;

    

    function new(string name="ahb_master_agent",uvm_component parent = null);
        super.new(name,parent);
    endfunction //new()

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (is_active == UVM_ACTIVE) begin
            sequencer = ahb_sequencer::type_id::create("sequencer",this);
            ahb_mdriver = ahb_master_driver::type_id::create("ahb_mdriver",this);
        end

    endfunction


    virtual function void connect_phase(uvm_phase phase);
        if (is_active == UVM_ACTIVE) begin
            ahb_mdriver.seq_item_port.connect(sequencer.seq_item_export);
        end
    endfunction



endclass //ahb_master_agent extends uvm_agent
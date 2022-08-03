class ahb_master_agent extends uvm_agent;
    
    `uvm_component_utils(ahb_master_agent)

    ahb_master_driver ahb_mdriver;
    ahb_sequencer sequencer;

    

    function new();
        super.new(string name="ahb_master_agent",uvm_component parent = null);
        this.is_active = 1;
    endfunction //new()

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (is_active == UVM_ACTIVE) begin
            sequencer = instr_register_sequencer::type_id::create("sequencer",this);
            ahb_mdriver = instr_register_driver::type_id::create("ahb_mdriver",this);
        end

    endfunction


    virtual function void connect_phase(uvm_phase phase);
        if (is_active == UVM_ACTIVE) begin
            ahb_mdriver.seq_item_port.connect(sequencer.seq_item_export);
        end
    endfunction



endclass //ahb_master_agent extends uvm_agent
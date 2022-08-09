class ahb_slave_agent extends uvm_agent;

    `uvm_component_utils(ahb_slave_agent)

    ahb_slave_driver ahb_sdriver;
    ahb_sequencer sequencer;
    ahb_slave_monitor ahb_smonitor;

    function new(string name="ahb_slave_agent",uvm_component parent=null);
   
        super.new(name,parent);
        
    endfunction 

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ahb_smonitor = ahb_slave_monitor::type_id::create("ahb_smonitor",this);
        // config flags
        if (is_active == UVM_ACTIVE) begin
            sequencer = ahb_sequencer::type_id::create("sequencer",this);
            ahb_sdriver = ahb_slave_driver::type_id::create("ahb_sdriver",this);
        end

    endfunction

    virtual function void connect_phase(uvm_phase phase);
        if (is_active == UVM_ACTIVE) begin
            ahb_sdriver.seq_item_port.connect(sequencer.seq_item_export);
        end
    endfunction


endclass //ahb_slave_agent extends uvm_agent
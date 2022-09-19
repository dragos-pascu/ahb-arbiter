class ahb_master_agent extends uvm_agent;
    
    `uvm_component_utils(ahb_master_agent)

    ahb_master_driver ahb_mdriver;
    ahb_master_monitor ahb_mmonitor;
    ahb_master_coverage  ahb_coverage_h;
    ahb_sequencer sequencer;
    ahb_magent_config config_h;


    

    function new(string name="ahb_master_agent",uvm_component parent = null);
        super.new(name,parent);
    endfunction //new()

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db#(ahb_magent_config)::get(null, this.get_name(), "ahb_magent_config", config_h))
                    `uvm_fatal(get_full_name(), "Can`t get env_config from db")

        ahb_mmonitor = ahb_master_monitor::type_id::create("ahb_mmonitor",this);

        if (config_h.enable_coverage) begin
            ahb_coverage_h = ahb_master_coverage::type_id::create("ahb_coverage_h",this);
        end
        

        if (config_h.is_active) begin
            sequencer = ahb_sequencer::type_id::create("sequencer",this);
            ahb_mdriver = ahb_master_driver::type_id::create("ahb_mdriver",this);
        end

    endfunction


    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        if (config_h.enable_coverage) begin
            ahb_mmonitor.item_collect_port.connect(ahb_coverage_h.analysis_export);
        end
        
        if (config_h.is_active) begin
            ahb_mdriver.seq_item_port.connect(sequencer.seq_item_export);
        end
    endfunction



endclass //ahb_master_agent extends uvm_agent
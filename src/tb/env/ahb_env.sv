
class ahb_env extends uvm_env;
    `uvm_component_utils(ahb_env)

    env_config env_cfg;
    
    //agents
    ahb_master_agent m_agent[master_number];
    ahb_slave_agent s_agent[slave_number];
    reset_agent reset_agent_h;

    //scoreboards
    ahb_scoreboard transaction_scoreboard_h;
    arbitration_scoreboard arbitration_scoreboard_h;

    //coverage
    ahb_coverage transaction_coverage_h;
    arbitration_coverage arbitration_coverage_h;

    ahb_magent_config      magt_cfg[master_number];
    ahb_sagent_config      sagt_cfg[slave_number];

    ahb_vsequencer vsequencer;


    function new(string name="ahb_env", uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db#(env_config)::get(this, "", "env_config", env_cfg))
            `uvm_fatal(get_full_name(), "Can`t get env_config from db")

        transaction_scoreboard_h = ahb_scoreboard::type_id::create("transaction_scoreboard_h",this);
        arbitration_scoreboard_h = arbitration_scoreboard::type_id::create("arbitration_scoreboard_h",this);

        //enable coverage
        if (env_cfg.enable_coverage) begin
            transaction_coverage_h = ahb_coverage::type_id::create("coverage_h",this);
            arbitration_coverage_h = arbitration_coverage::type_id::create("arbitration_coverage_h",this);
        end

        transaction_scoreboard_h.enable_coverage = env_cfg.enable_coverage;
        arbitration_scoreboard_h.enable_coverage = env_cfg.enable_coverage;
        
         
        reset_agent_h = reset_agent::type_id::create("reset_agent_h",this);
        //create masters and config items
        foreach (m_agent[i]) begin

            m_agent[i] = ahb_master_agent::type_id::create($sformatf("master[%0d]",i),this);
            magt_cfg[i] = ahb_magent_config::type_id::create($sformatf("magt_cfg[%0d]",i));
            magt_cfg[i].agent_id = i;
            magt_cfg[i].is_active = env_cfg.is_active;
            env_cfg.magt_cfg[i] = magt_cfg[i];
            
            uvm_config_db#(ahb_magent_config)::set(null, $sformatf("master[%0d]", i), "ahb_magent_config", env_cfg.magt_cfg[i]);
            
        end

        //create slaves and config items

        foreach (s_agent[i]) begin

            s_agent[i] = ahb_slave_agent::type_id::create($sformatf("slave[%0d]",i),this);
            sagt_cfg[i] = ahb_sagent_config::type_id::create($sformatf("sagt_cfg[%0d]",i));
            sagt_cfg[i].agent_id = i;
            sagt_cfg[i].is_active = env_cfg.is_active;
            env_cfg.sagt_cfg[i] = sagt_cfg[i];
            uvm_config_db#(ahb_sagent_config)::set(null, $sformatf("slave[%0d]", i), "ahb_sagent_config", env_cfg.sagt_cfg[i]);
     
        end


        vsequencer = ahb_vsequencer::type_id::create("vsequencer",this);
        
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        //connect vsequencer handles to master sequencers and monitors to scoreboard
        for (int i=0; i<master_number; ++i) begin
            vsequencer.master_seqr[i] = m_agent[i].sequencer;
            m_agent[i].ahb_mmonitor.master_transaction_port.connect(transaction_scoreboard_h.item_expected);
            // m_agent[i].req_monitor.request_collect_port.connect(arbitration_scoreboard_h.req_collect_predictor);

            //analysis fifo connect            
            m_agent[i].req_monitor.request_collect_port.connect(arbitration_scoreboard_h.request_fifo[i].analysis_export);
            m_agent[i].req_monitor.response_collect_port.connect(arbitration_scoreboard_h.response_fifo[i].analysis_export);


        end

        //connect vsequencer handles to slave sequencers and monitors to scoreboard
        for (int i=0; i<slave_number; ++i) begin
            vsequencer.slave_seqr[i] = s_agent[i].sequencer;
            s_agent[i].ahb_smonitor.slave_transaction_port.connect(transaction_scoreboard_h.item_collected);
        end

        //connect scoreboard analysis port to export of coverage.
        if (env_cfg.enable_coverage) begin
            transaction_scoreboard_h.coverage_port.connect(transaction_coverage_h.analysis_export);
            arbitration_scoreboard_h.coverage_port.connect(arbitration_coverage_h.analysis_export);
        end

    

    endfunction



endclass
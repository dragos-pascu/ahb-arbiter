
class ahb_env extends uvm_env;
    
    `uvm_component_utils(ahb_env)


    env_config env_cfg;

    ahb_master_agent m_agent[master_number];
    ahb_slave_agent s_agent[slave_number];
    ahb_scoreboard scoreboard_h;
    request_scoreboard req_scoreboard_h;


    ahb_magent_config      magt_cfg[master_number];
    ahb_sagent_config      sagt_cfg[slave_number];

    ahb_vsequencer vsequencer;


    function new(string name="ahb_env", uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        scoreboard_h = ahb_scoreboard::type_id::create("scoreboard_h",this);
        req_scoreboard_h = request_scoreboard::type_id::create("req_scoreboard_h",this);

        if(!uvm_config_db#(env_config)::get(this, "", "env_config", env_cfg))
                    `uvm_fatal(get_full_name(), "Can`t get env_config from db")

        
        //create masters and config items
        foreach (m_agent[i]) begin

            m_agent[i] = ahb_master_agent::type_id::create($sformatf("master[%0d]",i),this);
            magt_cfg[i] = ahb_magent_config::type_id::create($sformatf("magt_cfg[%0d]",i));
            magt_cfg[i].agent_id = i;
            //coverage and is_active flag for master
            magt_cfg[i].enable_coverage = env_cfg.enable_coverage;
            magt_cfg[i].is_active = env_cfg.is_active;
            env_cfg.magt_cfg[i] = magt_cfg[i];
            
            uvm_config_db#(ahb_magent_config)::set(null, $sformatf("master[%0d]", i), "ahb_magent_config", env_cfg.magt_cfg[i]);
     
        end

        //create slaves and config items

        foreach (s_agent[i]) begin

            s_agent[i] = ahb_slave_agent::type_id::create($sformatf("slave[%0d]",i),this);
            sagt_cfg[i] = ahb_sagent_config::type_id::create($sformatf("sagt_cfg[%0d]",i));
            sagt_cfg[i].agent_id = i;

            //coverage and is_active flag for skave
            sagt_cfg[i].enable_coverage = env_cfg.enable_coverage;
            sagt_cfg[i].is_active = env_cfg.is_active;
            env_cfg.sagt_cfg[i] = sagt_cfg[i];
            uvm_config_db#(ahb_sagent_config)::set(null, $sformatf("slave[%0d]", i), "ahb_sagent_config", env_cfg.sagt_cfg[i]);
     
        end

        // should set agents to active / passive + monitor , scoreboard etc.

        vsequencer = ahb_vsequencer::type_id::create("vsequencer",this);
        
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        //connect vsequencer handles to master sequencers and monitors to scoreboard
        for (int i=0; i<master_number; ++i) begin
            vsequencer.master_seqr[i] = m_agent[i].sequencer;
            m_agent[i].ahb_mmonitor.item_collect_port.connect(scoreboard_h.item_collect_predictor);
            m_agent[i].ahb_mmonitor.request_collect_port.connect(req_scoreboard_h.req_collect_predictor);

        end

        //connect vsequencer handles to slave sequencers and monitors to scoreboard
        for (int i=0; i<slave_number; ++i) begin
            vsequencer.slave_seqr[i] = s_agent[i].sequencer;
            s_agent[i].ahb_smonitor.m_req_port.connect(scoreboard_h.item_collect_evaluator);
        end

 

    endfunction



endclass
class ahb_env extends uvm_env;
    
    `uvm_component_utils(ahb_env)

    ahb_master_agent m_agent[master_number];
    ahb_slave_agent s_agent[slave_number];
    ahb_vsequencer vsequencer;


    function new(string name="ahb_env", uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        s_agent = ahb_slave_agent::type_id::create("s_agent",this);
        m_agent = ahb_master_agent::type_id::create("m_agent",this);
        vsequencer = ahb_vsequencer::type_id::create("vsequencer",this);
        
        // create a sequence in run_phase( seq.start(env.agent.sequencer) );
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        //connect master sequencers
        for (int i=0; i<master_number; ++i) begin
            vsequencer.master_seqr[i] = m_agent[i].sequencer;
        end

        //connect for slaves
        for (int i=0; i<slave_number; ++i) begin
            vsequencer.slave_seqr[i] = s_agent[i].sequencer;
        end

    endfunction



endclass
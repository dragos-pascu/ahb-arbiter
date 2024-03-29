class base_test extends uvm_test;
    `uvm_component_utils(base_test)

    ahb_env env; // my env
    env_config env_cfg;

    //base virtual sequence
    virtual_base_sequence vseq_h;

    //slave sequences
    ahb_slave_base_seq slave_seq;

    //virtual sequence base


    //reset sequence
    reset_seq reset_seq_h;

    function new(string name="base_test", uvm_component parent = null);
        super.new(name,parent);

    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        env_cfg = env_config::type_id::create("env_cfg", this);

        env_cfg.enable_coverage = 1;
        env_cfg.is_active = 1;

        uvm_config_db#(env_config)::set(null, "", "env_config", env_cfg);

        env = ahb_env::type_id::create("env",this);
        `uvm_info(get_type_name(),"Build phase of test is executing",UVM_HIGH)

        
                                                                                                                  
    endfunction

    
    virtual task run_phase(uvm_phase phase);
        vseq_h = virtual_base_sequence::type_id::create("vseq_h");

        
        
        phase.raise_objection(this); 
        fork
            begin
                for (int i=0; i<slave_number; i++) begin
                    automatic int j=i;
                    fork begin
                        ahb_slave_base_seq slave_seq;
                        slave_seq = slave_response_seq::type_id::create("slave_seq");

                        slave_seq.start(env.s_agent[j].sequencer);
                    end    
                    join_none
                end
                // wait fork; don`t wait for the slave seq to finish

            end
            begin
                vseq_h.start(env.vsequencer);
            end
            begin
                reset_seq_h = reset_seq::type_id::create("reset_seq");
                reset_seq_h.start(env.reset_agent_h.reset_seqr_h);
            end
            
        join    
              
        phase.phase_done.set_drain_time(this, 50000ns);          
        phase.drop_objection(this);
        


    endtask


endclass
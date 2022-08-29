class base_test extends uvm_test;
    `uvm_component_utils(base_test)

    ahb_env env; // my env
    env_config env_cfg;

    //base virtual sequence
    virtual_base_sequence vseq_h;

    //slave sequences
    ahb_slave_base_seq slave_seq;

    //virtual sequence base


    function new(string name="base_test", uvm_component parent = null);
        super.new(name,parent);

    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        env_cfg = env_config::type_id::create("env_cfg", this);
        uvm_config_db#(env_config)::set(null, "", "env_config", env_cfg);
        env = ahb_env::type_id::create("env",this);
        `uvm_info(get_type_name(),"Build phase of test is executing",UVM_HIGH)

        //make changes to env here? 
                                                                                                                  
    endfunction

    
    virtual task run_phase(uvm_phase phase);
        vseq_h = virtual_base_sequence::type_id::create("vseq_h");

        for (int i=0; i<slave_number; i++) begin
            int j=i;
            //fork
            slave_seq = ahb_slave_base_seq::type_id::create("slave_seq");
            slave_seq.start(env.s_agent[j].sequencer);
            //join_none
        end
        
        phase.raise_objection(this);
        vseq_h.start(env.vsequencer);
        phase.phase_done.set_drain_time(this, 100ns);          
        phase.drop_objection(this);
        


    endtask

    // virtual function void end_of_elaboration_phase(uvm_phase phase);
    //     uvm_top.print_topology();
    // endfunction


endclass
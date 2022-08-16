class ahb_base_test extends uvm_test;
    

    `uvm_component_utils(ahb_base_test)

    ahb_env env; // my env
    env_config env_cfg;

    //virtual sequencer
    ahb_vseq vseq_h;

    //slave sequences
    ahb_slave_base_seq slave_seq;

    function new(string name="ahb_base_test", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        vseq_h = ahb_vseq::type_id::create("vseq_h");
        
        env_cfg = env_config::type_id::create("env_cfg", this);
        uvm_config_db#(env_config)::set(null, "", "env_config", env_cfg);
        env = ahb_env::type_id::create("env",this);
        `uvm_info(get_type_name(),"Build phase of test is executing",UVM_HIGH)

        //make changes to env here? 

    endfunction

    
    virtual task run_phase(uvm_phase phase);
        
        begin
            phase.raise_objection(this);
            vseq_h.start(env.vsequencer);           
            phase.drop_objection(this);
        end

        for (int i=0; i<slave_number; i++) begin
            int j=i;
            fork
            slave_seq = ahb_slave_base_seq::type_id::create("slave_seq");
            slave_seq.start(env.s_agent[j].sequencer);
            join_none
        end
        

    endtask

    // virtual function void end_of_elaboration_phase(uvm_phase phase);
    //     uvm_top.print_topology();
    // endfunction


endclass
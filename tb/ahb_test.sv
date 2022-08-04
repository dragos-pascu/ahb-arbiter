class ahb_test extends uvm_test;
    

    `uvm_component_utils(ahb_test)

    ahb_env env; // my env
    env_config env_cfg;

    //sequences
    ahb_vseq vseq_h;

    function new(string name="ahb_test", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env_cfg = env_config::type_id::create("env_cfg", this);
        uvm_config_db#(env_config)::set(null, "", "env_config", env_cfg);
        env = ahb_env::type_id::create("env",this);
        `uvm_info("TEST","Build phase of test is executing",UVM_HIGH)

        //set env_cfg different values when needed

    endfunction

    
    virtual task run_phase(uvm_phase phase);
        vseq_h = ahb_vseq::type_id::create("vseq_h");
        phase.raise_objection(this);
        #1us;
        vseq_h.start(env.vsequencer); // sent to virtual sequencer in env a virtual sequence
        phase.drop_objection(this);
    endtask

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction


endclass
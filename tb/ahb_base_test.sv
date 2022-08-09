class ahb_base_test extends uvm_test;
    

    `uvm_component_utils(ahb_base_test)

    ahb_env env; // my env
    env_config env_cfg;

    //virtual sequencer
    ahb_vseq vseq_h;

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
        phase.raise_objection(this);
        vseq_h.start(env.vsequencer); // sent to virtual sequencer in env a virtual sequence
        phase.drop_objection(this);
    endtask

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction


endclass
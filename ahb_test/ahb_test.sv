class ahb_test extends uvm_test;
    
    `uvm_component_utils(ahb_test)

    ahb_env env; // my env

    function new(string name="ahb_test", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);

        super.build_phase(phase);
        env = ahb_env::type_id::create("tb",this);
        `uvm_info("TEST","Build phase of test is executing",UVM_HIGH)

    endfunction

    
    virtual task run_phase(uvm_phase phase);
        ahb_vsequencer vseq = ahb_vsequencer::type_id::create("vseq");
        phase.raise_objection(this);
        #1us;
        vseq.start(env.vsequencer);
        phase.drop_objection(this);
    endtask

    virtual function void end_of_elaboration(uvm_phase);
        uvm_top.print_topology();
    endfunction


endclass
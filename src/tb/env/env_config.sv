
class env_config extends uvm_object;

    `uvm_object_utils(env_config)

    ahb_magent_config magt_cfg[master_number];
    ahb_sagent_config sagt_cfg[slave_number];
    reset_config res_cfg;

    bit enable_coverage;
    bit is_active;

    function new(string name = "env_config");
                super.new(name);
    endfunction

    
endclass
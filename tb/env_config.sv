import uvm_pkg::*;
import ahb_agent_pkg::*;
import integration_pkg::*;
class env_config extends uvm_object;
    
    `uvm_object_utils(env_config)

    ahb_magent_config magt_cfg[master_number];
    ahb_sagent_config sagt_cfg[slave_number];

    function new(string name = "env_config");
                super.new(name);
    endfunction

    
endclass
import uvm_pkg::*;
`include "uvm_macros.svh"
import integration_pkg::*;
import master_pkg::*;
import slave_pkg::*;
import ahb_env_pkg::*;

class env_config extends uvm_object;

    `uvm_object_utils(env_config)

    ahb_magent_config magt_cfg[master_number];
    ahb_sagent_config sagt_cfg[slave_number];
    bit enable_coverage;
    bit is_active;

    function new(string name = "env_config");
                super.new(name);
    endfunction

    
endclass
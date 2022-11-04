`timescale 1ns/1ns
package ahb_env_pkg;
    
    

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import integration_pkg::*;
    import master_pkg::*;
    import slave_pkg::*;
    
    `include "env_config.sv"
    `include "ahb_scoreboard.sv"
    //`include "ahb_scoreboard1.sv"

    `include "request_scoreboard.sv"


    `include "ahb_vsequencer.sv"
    `include "virtual_sequences_lib.sv"
    
    `include "aribtration_coverage.sv"
    `include "ahb_coverage.sv"
    `include "ahb_env.sv"

endpackage
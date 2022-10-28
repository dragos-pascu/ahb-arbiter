`timescale 1ns/1ns
package ahb_env_pkg;
    
    

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import integration_pkg::*;
    import ahb_seq_pkg::*;
    import request_pkg::*;
    import master_pkg::*;
    import slave_pkg::*;

    `include "ahb_scoreboard.sv"
    `include "request_scoreboard.sv"

    `include "env_config.sv"
    `include "ahb_env.sv"

endpackage
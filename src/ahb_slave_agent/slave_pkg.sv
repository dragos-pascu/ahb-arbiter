`timescale 1ns/1ns
package slave_pkg;
    


    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import integration_pkg::*;
    import ahb_seq_pkg::*;

    `include "ahb_sagent_config.sv"
    `include "ahb_slave_monitor.sv"
    `include "ahb_slave_driver.sv"
    `include "ahb_slave_agent.sv"
    
    

endpackage
`timescale 1ns/1ns
package slave_pkg;
    


    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import integration_pkg::*;
    //import ahb_seq_pkg::*;
    import master_pkg::ahb_transaction;
    import master_pkg::ahb_request;

    `include "memory.sv"
    `include "ahb_sagent_config.sv"
    `include "slave_sequencer.sv"
    `include "slave_sequences.sv"
    `include "ahb_slave_monitor.sv"
    `include "ahb_slave_driver.sv"
    `include "ahb_slave_agent.sv"
    
    

endpackage
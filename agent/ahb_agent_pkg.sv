package ahb_agent_pkg;
    
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import integration_pkg::*;

    `include "ahb_slave_agent/memory.sv"

    `include "ahb_seq/ahb_transaction.sv"
    `include "ahb_seq/ahb_sequencer.sv"
    `include "ahb_seq/slave_sequencer.sv"
    `include "ahb_seq/ahb_vsequencer.sv"
    `include "ahb_seq/virtual_base_sequence.sv"
    `include "ahb_seq/sequence_lib.sv"
    `include "ahb_seq/virtual_sequences_lib.sv"
    `include "ahb_seq/ahb_slave_base_seq.sv"

    

    `include "ahb_master_agent/ahb_magent_config.sv"
    `include "ahb_coverage.sv"
    `include "ahb_master_agent/ahb_master_monitor.sv"
    `include "ahb_master_agent/ahb_master_driver.sv"
    `include "ahb_master_agent/ahb_master_agent.sv"
    
    
    `include "ahb_slave_agent/ahb_sagent_config.sv"
    `include "ahb_slave_agent/ahb_slave_monitor.sv"
    `include "ahb_slave_agent/ahb_slave_driver.sv"
    `include "ahb_slave_agent/ahb_slave_agent.sv"
    
    `include "ahb_scoreboard.sv"

endpackage
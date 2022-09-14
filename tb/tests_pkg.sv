package tests_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import integration_pkg::*;
    import ahb_agent_pkg::*;
    `include "env_config.sv"
    `include "ahb_env.sv"

    `include "tests/base_test.sv"
    
    `include "tests/simple_write_test.sv"
    `include "tests/incr_write_test.sv"
    `include "tests/incr_write_4_test.sv"
    `include "tests/incr_write_8_test.sv"
    `include "tests/incr_write_16_test.sv"
    

    `include "tests/wrap_write_4_test.sv"
    `include "tests/wrap_write_8_test.sv"
    `include "tests/wrap_write_16_test.sv"
    

    `include "tests/incr_read_4_test.sv"

endpackage
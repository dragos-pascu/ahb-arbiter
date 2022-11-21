`timescale 1ns/1ns
package tests_pkg;
    
    

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import integration_pkg::*;
    import master_pkg::*;
    import reset_pkg::*;
    import slave_pkg::*;
    import ahb_env_pkg::*;
    

    `include "base_test.sv"
    `include "random_test.sv"
    
////////// WRITE ///////////////

    `include "single_write_test.sv"
    `include "incr_write_test.sv"
    `include "incr_write_4_test.sv"
    `include "incr_write_8_test.sv"
    `include "incr_write_16_test.sv"
    

    `include "wrap_write_4_test.sv"
    `include "wrap_write_8_test.sv"
    `include "wrap_write_16_test.sv"


///////////// READ ///////////////    

    `include "single_read_test.sv"
    `include "incr_read_test.sv"


    `include "incr_read_4_test.sv"
    `include "incr_read_8_test.sv"
    `include "incr_read_16_test.sv"

    `include "wrap_read_4_test.sv"
    `include "wrap_read_8_test.sv"
    `include "wrap_read_16_test.sv"

endpackage
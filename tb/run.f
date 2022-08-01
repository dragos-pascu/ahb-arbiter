-uvm

-timescale 1ns/1ns
-access +rw

// *** include test ***
//+UVM_TESTNAME=

// *** include compile files ***


-incdir ../rtl  
-incdir ../ahb_env
-incdir ../ahb_test

../rtl/integration_pkg.sv
../tb/arbiter_if.sv
../rtl/generic_arbiter_full.sv
../tb/test_harness.sv

tb_top.sv

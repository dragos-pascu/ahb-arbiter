-uvm

-timescale 1ns/1ns
-access +rw

// *** include test ***
//+UVM_TESTNAME=

// *** include compile files ***

-incdir ../rtl

../rtl/integration_pkg.sv
../rtl/arbiter_if.sv
../rtl/generic_arbiter_full.sv
../rtl/test_harness.sv

tb_top.sv

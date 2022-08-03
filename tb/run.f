-uvm

-timescale 1ns/1ns
-access +rw

// *** include test ***
//+UVM_TESTNAME=../ahb_test/ahb_test.sv

// *** include compile files ***


-incdir ../agent

../rtl/integration_pkg.sv
../agent/arbiter_if.sv
../rtl/generic_arbiter_full.sv


test_harness.sv
tb_top.sv

-uvm
-access +rwc

-timescale 1ns/1ns
-access +rw

-linedebug
-uvmlinedebug

// *** include test ***
+UVM_TESTNAME=simple_write_test

// *** include compile files ***


-incdir ../agent

../rtl/integration_pkg.sv
../agent/ahb_agent_pkg.sv
tests_pkg.sv
../agent/arbiter_if.sv
../rtl/generic_arbiter_full_v5.sv

env_config.sv
ahb_env.sv
test_harness.sv
tb_top.sv

-uvm
-access +rwc

-timescale 1ns/1ns
-access +rw

// *** include test ***
+UVM_TESTNAME=ahb_base_test

// *** include compile files ***


-incdir ../agent

../rtl/integration_pkg.sv
../agent/ahb_agent_pkg.sv
../agent/arbiter_if.sv
../rtl/generic_arbiter_full_v5.sv

env_config.sv
ahb_env.sv
test_harness.sv
tb_top.sv

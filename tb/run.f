-uvm
-access +rwc

-timescale 1ns/1ns
-access +rw

-linedebug
-debug
-uvmlinedebug
-cov_cgsample

//+UVM_PHASE_TRACE
//+UVM_OBJECTION_TRACE

// *** include test ***
//+UVM_TESTNAME=simple_write_test
+UVM_TESTNAME=incr_write_4_test
//+UVM_TESTNAME=wrap_write_4_test


// *** include compile files ***


-incdir ../agent

../rtl/integration_pkg.sv
../agent/ahb_agent_pkg.sv
tests_pkg.sv
../agent/arbiter_if.sv
../rtl/generic_arbiter_full_v6.sv

env_config.sv
ahb_env.sv
test_harness.sv
tb_top.sv

-uvm
-access +rwc

-timescale 1ns/1ns
-access +rw

-linedebug
-debug
-uvmlinedebug
-cov_cgsample
-coverage all
-covoverwrite
//-cov_debuglog

//+UVM_PHASE_TRACE
//+UVM_OBJECTION_TRACE

// *** include test ***
//+UVM_TESTNAME=simple_write_test

//+UVM_TESTNAME=incr_write_test

+UVM_TESTNAME=incr_write_4_test
//+UVM_TESTNAME=incr_write_8_test
//+UVM_TESTNAME=incr_write_16_test

//+UVM_TESTNAME=wrap_write_4_test
//+UVM_TESTNAME=wrap_write_8_test
//+UVM_TESTNAME=wrap_write_16_test


//+UVM_TESTNAME=random_test
//+UVM_TESTNAME=incr_read_4_test

// *** include compile files ***


-incdir /home/dragos.pascu/Projects/ahb-arbiter-project/src
-incdir /home/dragos.pascu/Projects/ahb-arbiter-project/src/agent
-incdir /home/dragos.pascu/Projects/ahb-arbiter-project/src/tb
-incdir /home/dragos.pascu/Projects/ahb-arbiter-project/src/tb/tests

/home/dragos.pascu/Projects/ahb-arbiter-project/src/rtl/integration_pkg.sv
#/home/dragos.pascu/Projects/ahb-arbiter-project/src/rtl/integration_pkg_lucian.sv
/home/dragos.pascu/Projects/ahb-arbiter-project/src/ahb_agent_pkg.sv
/home/dragos.pascu/Projects/ahb-arbiter-project/src/tb/tests_pkg.sv
/home/dragos.pascu/Projects/ahb-arbiter-project/src/request_if.sv
/home/dragos.pascu/Projects/ahb-arbiter-project/src/arbiter_if.sv
/home/dragos.pascu/Projects/ahb-arbiter-project/src/rtl/generic_arbiter_full_v6.sv
#/home/dragos.pascu/Projects/ahb-arbiter-project/src/rtl/generic_arbiter_comb.sv

/home/dragos.pascu/Projects/ahb-arbiter-project/src/tb/env_config.sv
/home/dragos.pascu/Projects/ahb-arbiter-project/src/tb/ahb_env.sv
/home/dragos.pascu/Projects/ahb-arbiter-project/src/tb/test_harness.sv
/home/dragos.pascu/Projects/ahb-arbiter-project/src/tb/tb_top.sv

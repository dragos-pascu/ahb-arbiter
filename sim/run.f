-uvm
-access +rwc
-clean 

-timescale 1ns/1ns
-access +rw

//-linedebug
//-debug
//-uvmlinedebug
-cov_cgsample
-coverage all
-covoverwrite
//-cov_debuglog
-svseed random


+UVM_VERBOSITY=UVM_MEDIUM
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
-incdir /home/dragos.pascu/Projects/ahb-arbiter-project/src/ahb_master_agent
-incdir /home/dragos.pascu/Projects/ahb-arbiter-project/src/ahb_slave_agent
-incdir /home/dragos.pascu/Projects/ahb-arbiter-project/src/tb/env
-incdir /home/dragos.pascu/Projects/ahb-arbiter-project/src/tb/
-incdir /home/dragos.pascu/Projects/ahb-arbiter-project/src/tb/tests

#/home/dragos.pascu/Projects/ahb-arbiter-project/src/rtl/integration_pkg.sv
/home/dragos.pascu/Projects/ahb-arbiter-project/src/rtl/integration_pkg_lucian.sv
/home/dragos.pascu/Projects/ahb-arbiter-project/src/ahb_master_agent/master_pkg.sv
/home/dragos.pascu/Projects/ahb-arbiter-project/src/ahb_slave_agent/slave_pkg.sv
/home/dragos.pascu/Projects/ahb-arbiter-project/src/tb/env/ahb_env_pkg.sv
/home/dragos.pascu/Projects/ahb-arbiter-project/src/tb/tests/tests_pkg.sv




/home/dragos.pascu/Projects/ahb-arbiter-project/src/rtl/request_if.sv
/home/dragos.pascu/Projects/ahb-arbiter-project/src/rtl/arbiter_if.sv
#/home/dragos.pascu/Projects/ahb-arbiter-project/src/rtl/generic_arbiter_full_v6.sv
/home/dragos.pascu/Projects/ahb-arbiter-project/src/rtl/generic_arbiter_comb.sv


/home/dragos.pascu/Projects/ahb-arbiter-project/src/tb/test_harness.sv
/home/dragos.pascu/Projects/ahb-arbiter-project/src/tb/tb_top.sv

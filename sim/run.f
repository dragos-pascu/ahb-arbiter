-uvm
-access +rwc
-clean 
-timescale 1ns/1ns


//-linedebug
//-debug
//-uvmlinedebug
-cov_cgsample
-coverage all
-covoverwrite
//-cov_debuglog
-svseed 2056337846


+UVM_VERBOSITY=UVM_HIGH
//+UVM_PHASE_TRACE
//+UVM_OBJECTION_TRACE

///////////////////////////////////////////////////
// *** include test ***

//+UVM_TESTNAME=error_test

//+UVM_TESTNAME=single_write_test
//+UVM_TESTNAME=simple_read_test

+UVM_TESTNAME=incr_write_test
//+UVM_TESTNAME=incr_read_test

//+UVM_TESTNAME=incr_write_4_test
//+UVM_TESTNAME=incr_write_8_test
//+UVM_TESTNAME=incr_write_16_test

//+UVM_TESTNAME=incr_read_4_test
//+UVM_TESTNAME=incr_read_8_test
//+UVM_TESTNAME=incr_read_16_test

//+UVM_TESTNAME=wrap_write_4_test
//+UVM_TESTNAME=wrap_write_8_test
//+UVM_TESTNAME=wrap_write_16_test

//+UVM_TESTNAME=wrap_read_4_test
//+UVM_TESTNAME=wrap_read_8_test
//+UVM_TESTNAME=wrap_read_16_test

//+UVM_TESTNAME=random_test

///////////////////////////////////////////////////
// *** include compile files ***


-incdir /home/dragos.pascu/Projects/ahb-arbiter-project/src
-incdir /home/dragos.pascu/Projects/ahb-arbiter-project/src/ahb_master_agent
-incdir /home/dragos.pascu/Projects/ahb-arbiter-project/src/ahb_slave_agent
-incdir /home/dragos.pascu/Projects/ahb-arbiter-project/src/reset_agent
-incdir /home/dragos.pascu/Projects/ahb-arbiter-project/src/tb/env
-incdir /home/dragos.pascu/Projects/ahb-arbiter-project/src/tb/
-incdir /home/dragos.pascu/Projects/ahb-arbiter-project/src/tb/tests

#/home/dragos.pascu/Projects/ahb-arbiter-project/src/rtl/integration_pkg.sv
/home/dragos.pascu/Projects/ahb-arbiter-project/src/rtl/integration_pkg_lucian.sv
/home/dragos.pascu/Projects/ahb-arbiter-project/src/ahb_master_agent/master_pkg.sv
/home/dragos.pascu/Projects/ahb-arbiter-project/src/ahb_slave_agent/slave_pkg.sv
/home/dragos.pascu/Projects/ahb-arbiter-project/src/reset_agent/reset_pkg.sv
/home/dragos.pascu/Projects/ahb-arbiter-project/src/tb/env/ahb_env_pkg.sv
/home/dragos.pascu/Projects/ahb-arbiter-project/src/tb/tests/tests_pkg.sv



/home/dragos.pascu/Projects/ahb-arbiter-project/src/reset_agent/reset_if.sv
/home/dragos.pascu/Projects/ahb-arbiter-project/src/ahb_master_agent/request_if.sv
/home/dragos.pascu/Projects/ahb-arbiter-project/src/ahb_master_agent/data_transfer_if.sv
#/home/dragos.pascu/Projects/ahb-arbiter-project/src/rtl/generic_arbiter_full_v6.sv
/home/dragos.pascu/Projects/ahb-arbiter-project/src/rtl/generic_arbiter_comb.sv


/home/dragos.pascu/Projects/ahb-arbiter-project/src/tb/test_harness.sv
/home/dragos.pascu/Projects/ahb-arbiter-project/src/tb/tb_top.sv


# XM-Sim Command File
# TOOL:	xmsim	20.09-s009
#

set tcl_prompt1 {puts -nonewline "xcelium> "}
set tcl_prompt2 {puts -nonewline "> "}
set vlog_format %h
set vhdl_format %v
set real_precision 6
set display_unit auto
set time_unit module
set heap_garbage_size -200
set heap_garbage_time 0
set assert_report_level note
set assert_stop_level error
set autoscope yes
set assert_1164_warnings yes
set pack_assert_off {}
set severity_pack_assert_off {note warning}
set assert_output_stop_level failed
set tcl_debug_level 0
set relax_path_name 1
set vhdl_vcdmap XX01ZX01X
set intovf_severity_level ERROR
set probe_screen_format 0
set rangecnst_severity_level ERROR
set textio_severity_level ERROR
set vital_timing_checks_on 1
set vlog_code_show_force 0
set assert_count_attempts 1
set tcl_all64 false
set tcl_runerror_exit false
set assert_report_incompletes 0
set show_force 1
set force_reset_by_reinvoke 0
set tcl_relaxed_literal 0
set probe_exclude_patterns {}
set probe_packed_limit 4k
set probe_unpacked_limit 16k
set assert_internal_msg no
set svseed -1086733273
set assert_reporting_mode 0
set vcd_compact_mode 0
alias . run
alias quit exit
stop -create -name Randomize -randomize
database -open -shm -into waves.shm waves -default
probe -create -database waves top.DUT.m_hready top.DUT.hclk top.DUT.hgrant top.DUT.hreset top.DUT.m_busreq top.DUT.m_haddr top.DUT.m_hburst top.DUT.m_hlock top.DUT.m_hrdata top.DUT.m_hresp top.DUT.m_hsize top.DUT.m_htrans top.DUT.m_hwdata top.DUT.m_hwrite top.DUT.s_addr_out top.DUT.s_data_out top.DUT.s_hburst_out top.DUT.s_hmaster top.DUT.s_hmaster_lock top.DUT.s_hrdata top.DUT.s_hready top.DUT.s_hresp top.DUT.s_hsel top.DUT.s_hsize top.DUT.s_htrans_out top.DUT.s_hwrite

simvision -input /home/dragos.pascu/Projects/ahb-arbiter-project/sim/gui_run/.simvision/19622_dragos.pascu__autosave.tcl.svcf

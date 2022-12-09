class ahb_coverage extends uvm_subscriber#(ahb_transaction);
    `uvm_component_utils(ahb_coverage)

    /************** COVERAGE FOR DATA TRANSFER ACCORDING TO AHB *****************/

    ahb_transaction tx;
    env_config cfg;

    covergroup ahb_master_cg ;

        option.per_instance = 1;
        type_option.merge_instances = 1;
        read_write: coverpoint tx.hwrite {
            bins write_bin = {WRITE};
            bins read_bin = {READ};
            }
        htrans: coverpoint tx.htrans[0]{
            bins idle = {IDLE}; // ilegal bins
            bins nonseq = {NONSEQ};
            bins seq = {SEQ};
            bins busy = {BUSY}; // ilegal bins
            
        }
        haddr : coverpoint tx.haddr[0]{
            bins range_0  = {['d0:'d69]};
            bins range_1  = {['d70:'d140]};
            bins range_2  = {['d141:'d210]};
            bins range_3  = {['d211:'d281]};
            bins range_4  = {['d282:'d350]};
        }
        hburst : coverpoint tx.hburst {
            option.at_least = 1;
            /*A minimum number of hits for each bin. A bin with a hit count that is less than the number is not considered covered. the default value is ‘1’.*/
            bins increment 	= {INCR, INCR4, INCR8, INCR16};
			bins wrap 	= {WRAP4, WRAP8, WRAP16};
			bins single 	= {SINGLE};
        }
        hsize: coverpoint tx.hsize{
            bins bytes_bin = {BYTE};
            bins halfword_bin = {HALFWORD};
            bins word_bin = {WORD};
            }
        hwdata: coverpoint tx.hwdata[0]{option.auto_bin_max = 6;}
        read_writeXhburstXhsizeXhtrans: cross read_write, hburst, hsize , htrans;

    endgroup

    covergroup ahb_slave_cg ;

        hrdata: coverpoint tx.hrdata iff(tx.hwrite == READ)
        {option.auto_bin_max = 6;}
        hready: coverpoint tx.hready;
        hresp: coverpoint tx.hresp;

        hreadyXhresp : cross hready, hresp;

    endgroup


    virtual function void write(ahb_transaction t);

        tx = t;
        ahb_master_cg.sample();
        ahb_slave_cg.sample();

    endfunction

    function new(string name = "ahb_coverage", uvm_component parent);
        super.new(name, parent);
        ahb_master_cg = new();
        ahb_slave_cg = new();
        cfg = new();
    endfunction

    //Report
    function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("Master data coverage is: %f", ahb_master_cg.get_coverage()), UVM_MEDIUM)
        `uvm_info(get_type_name(), $sformatf("Slave data coverage is: %f", ahb_slave_cg.get_coverage()), UVM_MEDIUM)

    endfunction

endclass
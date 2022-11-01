class ahb_coverage extends uvm_subscriber#(ahb_transaction);
    `uvm_component_utils(ahb_coverage)

    /************** COVERAGE FOR DATA TRANSFER ACCORDING TO AHB *****************/

    ahb_transaction tx;

    env_config cfg;

    covergroup ahb_transaction_cg ;
        
        option.per_instance = 1;

        hbusreq: coverpoint tx.hbusreq;
        hlock: coverpoint tx.hlock;

        read_write: coverpoint tx.hwrite {bins write_bin = {WRITE};}
        htrans: coverpoint tx.htrans[0]{
            bins idle = {IDLE};
            bins nonseq = {NONSEQ};
            bins seq = {SEQ};
            bins busy = {BUSY};
            
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
            bins increment 	= {INCR, INCR4, INCR8, INCR16};
			bins wrap 	= {WRAP4, WRAP8, WRAP16};
			bins single 	= {SINGLE};
        }
        hsize: coverpoint tx.hsize {bins word_bin = {WORD};}

        hwdata: coverpoint tx.hwdata[0]{option.auto_bin_max = 6;}

        //cross cov
        read_writeXhburstXhsize: cross read_write, hburst, hsize;



    endgroup



    virtual function void write(ahb_transaction t);

        tx = t;
        ahb_transaction_cg.sample();

    endfunction

    function new(string name = "ahb_coverage", uvm_component parent);
        super.new(name, parent);
        ahb_transaction_cg = new();
        cfg = new();
    endfunction

    //Report
    function void report_phase(uvm_phase phase);
            `uvm_info(get_type_name(), $sformatf("AHB Transaction coverage is: %f", ahb_transaction_cg.get_coverage()), UVM_MEDIUM)
    endfunction

endclass
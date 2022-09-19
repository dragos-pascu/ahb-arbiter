class ahb_master_coverage extends uvm_subscriber#(ahb_transaction);
    `uvm_component_utils(ahb_master_coverage)

    ahb_transaction item;

    covergroup ahb_cg;

        option.per_instance = 1;

        //add reset


        hbusreq: coverpoint item.hbusreq;
        hlock: coverpoint item.hlock;

        read_write: coverpoint item.hwrite {bins read_write_bin = {WRITE};}
        htrans: coverpoint item.htrans[0];
        haddr : coverpoint item.haddr[0] {
            bins range_0  = {['d0:'d69]};
            bins range_1  = {['d70:'d140]};
            bins range_2  = {['d141:'d210]};
            bins range_3  = {['d211:'d281]};
            bins range_4  = {['d282:'d350]};
        }
        hburst : coverpoint item.hburst;
        hsize: coverpoint item.hsize {bins word_bin = {WORD};}

        hwdata: coverpoint item.hwdata[0] {option.auto_bin_max = 6;}
        hrdata: coverpoint item.hrdata {option.auto_bin_max = 6;}

        hready: coverpoint item.hready;
        hresp: coverpoint item.hresp {bins rsp = {OKAY, ERROR};}

        //cross cov
        read_writeXhsize: cross read_write, hsize;
        hburstXhsize: cross hburst, hsize;
        read_writeXhburst: cross read_write, hburst;
        read_writeXhburstXhsize: cross read_write, hburst, hsize;



    endgroup

    function new(string name = "ahb_coverage", uvm_component parent);
        super.new(name, parent);

        ahb_cg = new();

        
    endfunction //new()

    function void write(ahb_transaction t);
        item = t;
        ahb_cg.sample();

    endfunction

    function void report_phase(uvm_phase phase);
                `uvm_info(get_type_name(), $sformatf("Coverage for master interface is: %f", ahb_cg.get_coverage()), UVM_MEDIUM)
                
                // `uvm_info(get_type_name(), $sformatf("wdata coverage is: %f", ahb_cg.hwdata.get_coverage()), UVM_MEDIUM)
                // `uvm_info(get_type_name(), $sformatf("hresp coverage is: %f", ahb_cg.hresp.get_coverage()), UVM_MEDIUM)
                // `uvm_info(get_type_name(), $sformatf("busreq coverage is: %f", ahb_cg.hbusreq.get_coverage()), UVM_MEDIUM)

    endfunction


endclass

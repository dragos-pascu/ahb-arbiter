class ahb_coverage extends uvm_subscriber#(ahb_transaction);
    `uvm_component_utils(ahb_coverage)

    ahb_transaction item;

    covergroup ahb_cg;

        option.per_instance = 1;

        //add reset


        hbusreq: coverpoint item.hbusreq;
        hlock: coverpoint item.hlock;

        read_write: coverpoint item.hwrite;
        htrans: coverpoint item.htrans[0];
        haddr : coverpoint item.haddr[0] {option.auto_bin_max = 32;}
        hburst : coverpoint item.hburst;
        hsize: coverpoint item.hsize {bins word_bin = {WORD};}

        hwdata: coverpoint item.hwdata[0] {option.auto_bin_max = 32;}
        hrdata: coverpoint item.hrdata {option.auto_bin_max = 32;}

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
                `uvm_info(get_type_name(), $sformatf("Coverage is: %f", ahb_cg.get_coverage()), UVM_MEDIUM)
                
                // `uvm_info(get_type_name(), $sformatf("wdata coverage is: %f", ahb_cg.hwdata.get_coverage()), UVM_MEDIUM)
                // `uvm_info(get_type_name(), $sformatf("hresp coverage is: %f", ahb_cg.hresp.get_coverage()), UVM_MEDIUM)
                // `uvm_info(get_type_name(), $sformatf("busreq coverage is: %f", ahb_cg.hbusreq.get_coverage()), UVM_MEDIUM)

    endfunction


endclass
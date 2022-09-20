module top(
);
    // import the UVM library
    import uvm_pkg::*;

    // include the UVM macros
    `include "uvm_macros.svh"
    //import ahb_agent_pkg::*;
    import integration_pkg::*;
    import tests_pkg::*;

    
    logic clk;
    logic reset;
    time moment_reset;

    test_harness vif (.hclk(clk), .hreset(reset));
    
    generic_arbiter_full DUT( .m_busreq(vif.m_hbusreq),
                            .m_hlock(vif.m_hlock),
                            .hclk(vif.hclk),
                            .hreset(vif.hreset),
                            .s_hmaster_lock(vif.s_hmastlock),
                            .hgrant(vif.hgrant),
                            .s_hready(vif.s_hready),
                            .m_hwdata(vif.m_hwdata),
                            .s_data_out(vif.s_hwdata),
                            .m_haddr(vif.m_haddr),
                            .s_addr_out(vif.s_haddr),
                            .m_hburst(vif.m_hburst),
                            .m_htrans(vif.m_htrans),
                            .s_htrans_out(vif.s_htrans),
                            .s_hburst_out(vif.s_hburst),
                            .s_hmaster(vif.s_hmaster),
                            .s_hwrite(vif.s_hwrite),
                            .s_hresp(vif.s_hresp),
                            .m_hresp(vif.hresp),
                            .m_hready(vif.hready),
                            .m_hsize(vif.m_hsize),
                            .s_hsize(vif.s_hsize),
                            .m_hwrite(vif.m_hwrite),
                            .m_hrdata(vif.m_hrdata),
                            .s_hsel(vif.s_hsel),
                            .s_hrdata(vif.s_hrdata)
  );
    

    initial begin
    clk <= 0;
    forever #5ns  clk = ~clk;
    end

    // initial begin
    //     reset <= 0;
    //     #5ns
    //     reset <= 1;
    // end
    
    initial begin
    reset <= 0;
    #5ns
    reset <= 1;
    forever begin
        automatic int ticks_before_reset = $urandom_range(100, 500);
        automatic int reset_ticks = $urandom_range(1, 10);
        repeat (ticks_before_reset) @(posedge clk) begin end
        reset <= 0;
        repeat (reset_ticks) @(posedge clk) begin end
        reset <= 1;
    end
    end



    task reset_f();
        reset <= 0;
        #5ns
        reset <= 1;
    endtask

    initial begin
        run_test();
    end


endmodule
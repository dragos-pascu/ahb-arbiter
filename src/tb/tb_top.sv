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

    reset_if r_if (.hclk(clk));

    assign reset = r_if.hreset;

    test_harness th (.hclk(clk), .hreset(reset));

    

    initial begin
        uvm_config_db #(virtual reset_if)::set(null,"", "reset_if", r_if); 
    end
    

    
    generic_arbiter_full DUT( .m_busreq(th.m_hbusreq),
                            .m_hlock(th.m_hlock),
                            .hclk(th.hclk),
                            .hreset(th.hreset),
                            .s_hmaster_lock(th.s_hmastlock),
                            .hgrant(th.hgrant),
                            .s_hready(th.s_hready),
                            .m_hwdata(th.m_hwdata),
                            .s_data_out(th.s_hwdata),
                            .m_haddr(th.m_haddr),
                            .s_addr_out(th.s_haddr),
                            .m_hburst(th.m_hburst),
                            .m_htrans(th.m_htrans),
                            .s_htrans_out(th.s_htrans),
                            .s_hburst_out(th.s_hburst),
                            .s_hmaster(th.s_hmaster),
                            .s_hwrite(th.s_hwrite),
                            .s_hresp(th.s_hresp),
                            .m_hresp(th.hresp),
                            .m_hready(th.hready),
                            .m_hsize(th.m_hsize),
                            .s_hsize(th.s_hsize),
                            .m_hwrite(th.m_hwrite),
                            .m_hrdata(th.m_hrdata),
                            .s_hsel(th.s_hsel),
                            .s_hrdata(th.s_hrdata)
  );


    initial begin
    clk <= 0;
    forever #5ns  clk = ~clk;
    end
    
    // initial begin
    // reset <=1;
    // #10ns;
    // reset <= 0;
    // #15ns
    // reset <= 1;

    // forever begin
    //     automatic int ticks_before_reset = $urandom_range(10, 100);
    //     automatic int reset_ticks = $urandom_range(1, 10);
    //     repeat (ticks_before_reset) @(posedge clk);
    //     reset <= 0;
    //     repeat (reset_ticks) @(posedge clk) ;
    //     reset <= 1;
    // end
    // end


    initial begin
        run_test();
    end


endmodule
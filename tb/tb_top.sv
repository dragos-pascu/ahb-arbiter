module top(
);
    // import the UVM library
    import uvm_pkg::*;

    // include the UVM macros
    `include "uvm_macros.svh"
    import ahb_agent_pkg::*;
    import integration_pkg::*;
    `include "ahb_test.sv"

    
    logic clk;
    logic reset;

    test_harness vif (.hclk(clk),.hreset(reset));
    
    generic_arbiter_full DUT( .m_busreq(vif.m_busreq),
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
    reset <= 0;
    #15ns;
    reset<=1;
    forever #5ns  clk = ~clk;
    end

    initial begin
        run_test();
    end


endmodule
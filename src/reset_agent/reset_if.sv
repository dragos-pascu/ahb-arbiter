interface reset_if(input hclk );
    
    logic hreset;

    clocking r_cb @(posedge hclk);

        output hreset;

    endclocking

    


endinterface : reset_if
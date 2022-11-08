interface request_if(input hclk, input hreset);
    import integration_pkg::*;
    
    //outputs from master 
    logic hbusreq;
    logic hlock;

    //outputs from arbiter
    logic[3:0] hmaster;
    logic hgrant; 
    logic hmastlock;  

    clocking req_cb @(posedge hclk);

        //output hgrant,hmaster ,hmastlock; 
        input hbusreq , hlock, hgrant,hmaster ,hmastlock;
    endclocking

    /*Only one hgrant can be asserted on the bus at a time*/
    /*onehot0 because the hgrant starts with all to 0 to avoid assertion*/
    property only_one_hgrant_p;

        @(posedge hclk) disable iff(!hreset)
        $onehot0(hgrant);

    endproperty

    /*When no master requests the bus, the master lowest priority receive the bus . (increments from master_number to 0)*/
    property default_master_p;
        @(posedge hclk) disable iff(!hreset)
        hbusreq == 0 |-> ##3 hgrant == 1 << (master_number - 1);
    endproperty


    // ONLY_ONE_HGRANT: assert property(only_one_hgrant_p);
    // ONLY_ONE_HSEL: assert property(only_one_hsel_p);
    // DEFAULT_BUS_MASTER: assert property(default_master_p);

    


endinterface
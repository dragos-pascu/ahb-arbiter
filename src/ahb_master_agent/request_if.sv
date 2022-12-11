interface request_if(input hclk, input hreset);
    import integration_pkg::*;
    
    int interface_number;

    //outputs from master 
    logic hbusreq;
    logic hlock;

    //outputs from arbiter
    logic[3:0] hmaster;
    logic hgrant; 
    logic hmastlock;  
    logic hready;

    clocking req_cb @(posedge hclk);

        //output hgrant,hmaster ,hmastlock; 
        input hbusreq , hlock, hgrant,hmaster ,hmastlock;
    endclocking

    /*Only one hgrant can be asserted on the bus at a time*/
    // property only_one_hgrant_p;

    //     @(posedge hclk) disable iff(!hreset)
    //     $onehot(hgrant);

    // endproperty

    /*When hgrant and hready are 1 , next cyle the hmaster changes*/ // Add 
    property next_bus_master_p;

        @(posedge hclk) disable iff(!hreset)
            $rose(hgrant) |-> hgrant == 1 & hready [->1] /*& htrans != IDLE*/ ##1 hmaster == interface_number;

    endproperty

    /*If the master is granted, it's hlock is propagated through combinatorial logic to hmastlock*/
    property hmastlock_same_as_hlock_p;

        @(posedge hclk) disable iff(!hreset)
            (hgrant == 1) |-> hmastlock == hlock;

    endproperty


    /*When no master requests the bus, the master lowest priority receive the bus . (increments from master_number to 0)*/
    // property default_master_p;
    //     @(posedge hclk) disable iff(!hreset)
    //     hbusreq == 0 |-> ##3 hgrant == 1 << (master_number - 1);
    // endproperty


    // ONLY_ONE_HGRANT: assert property(only_one_hgrant_p);
    NEXT_BUS_MASTER: assert property(next_bus_master_p);
    HMASTLOCK_TIMING: assert property(hmastlock_same_as_hlock_p);
    // DEFAULT_BUS_MASTER: assert property(default_master_p);

    


endinterface
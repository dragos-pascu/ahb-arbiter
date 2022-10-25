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

        output hgrant,hmaster ,hmastlock; 
        input hbusreq , hlock;
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

    covergroup ahb_cg_arbitration @(posedge hclk);

        option.per_instance = 1;

        //add reset

        hbusreq: coverpoint hbusreq{
            bins hbusreq0 = {'b000000001};
            bins hbusreq1 = {'b000000010};
            bins hbusreq2 = {'b000000100};
            bins hbusreq3 = {'b000001000};
            bins hbusreq4 = {'b000010000};
            bins hbusreq5 = {'b000100000};
            bins hbusreq6 = {'b001000000};
            bins hbusreq7 = {'b010000000};
            bins hbusreq8 = {'b100000000};
        }

        hlock: coverpoint hlock{
            bins hlock0 = {'b000000001};
            bins hlock1 = {'b000000010};
            bins hlock2 = {'b000000100};
            bins hlock3 = {'b000001000};
            bins hlock4 = {'b000010000};
            bins hlock5 = {'b000100000};
            bins hlock6 = {'b001000000};
            bins hlock7 = {'b010000000};
            bins hlock8 = {'b100000000};
        }
        
        hbusreqxhlock: cross hbusreq, hlock;

    endgroup

    ahb_cg_arbitration arbiter_cg = new();

endinterface
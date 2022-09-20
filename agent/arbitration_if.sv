interface arbitration_if(input hclk, input hreset);
    import integration_pkg::*;
    
    //outputs from master to arbiter, inputs to this interface
    logic[master_number-1:0] hbusreq;
    logic[master_number-1:0] hlock;

    //outputs from arbiter, inputs into this interface
    logic[3:0] hmaster;
    logic[slave_number-1:0] hgrant;
    logic hmastlock;
    logic[slave_number-1:0] hsel; 
  

    clocking req_cb @(posedge hclk);

        input hgrant,hmaster ,hmastlock, hsel ; 
        input hbusreq , hlock;
    endclocking


    covergroup ahb_cg @(posedge hclk);

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
        
        hgrant: coverpoint hgrant {
            bins hgrant0 = {'b000000001};
            bins hgrant1 = {'b000000010};
            bins hgrant2 = {'b000000100};
            bins hgrant3 = {'b000001000};
            bins hgrant4 = {'b000010000};
            bins hgrant5 = {'b000100000};
            bins hgrant6 = {'b001000000};
            bins hgrant7 = {'b010000000};
            bins hgrant8 = {'b100000000};
        }

        hsel: coverpoint hsel{
            bins hsel0  = {'b00000000001};
            bins hsel1  = {'b00000000010};
            bins hsel2  = {'b00000000100};
            bins hsel3  = {'b00000001000};
            bins hsel4  = {'b00000010000};
            bins hsel5  = {'b00000100000};
            bins hsel6  = {'b00001000000};
            bins hsel7  = {'b00010000000};
            bins hsel8  = {'b00100000000};
            bins hsel9  = {'b01000000000};
            bins hsel10 = {'b10000000000};
        }

        hmastlock: coverpoint hmastlock;

        hgrantXhsel: cross hgrant, hsel;

    endgroup

    ahb_cg arbiter_cg = new();

endinterface
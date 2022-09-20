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

        input hgrant,hmaster ,hmastloc, hsel ; 
        input hbusreq , hlock;
    endclocking


    covergroup ahb_cg @(posedge hclk);

        option.per_instance = 1;

        //add reset

        hbusreq: coverpoint hbusreq;
        


    endgroup

    ahb_cg arbiter_cg = new();

endinterface
interface arbitration_if(input hclk, input hreset);
    import integration_pkg::*;
    logic[master_number-1:0] hbusreq;
    logic[3:0] hmaster;
    logic[slave_number-1:0] hgrant;
  

    clocking req_cb @(posedge hclk);

        input hgrant,hbusreq,hmaster ; 
        
    endclocking


endinterface
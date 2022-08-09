interface master_if(input hclk, input hreset);
    
    import integration_pkg::*;
    

    logic[31:0] haddr;         
    logic[1:0] htrans;         
    logic      hwrite;         
    logic[2:0] hsize;          
    logic[2:0] hburst;         
    logic[31:0] hwdata;        
    logic[31:0] hrdata;        
    logic      hready;         
    logic[1:0] hresp;          
    logic[3:0] hmaster;        
    logic      hsel;           
    logic      hmastlock;      
    logic      hbusreq;         
    logic      hlock;          
    logic      hgrant;              





    clocking m_cb @(posedge hclk);

    input hgrant,hready,hresp,hrdata;
    output htrans,haddr,hsize,hburst,hwdata,hbusreq,hlock,hwrite;


    endclocking



endinterface : master_if


interface salve_if(input hclk, input hreset);
    
    import integration_pkg::*;
    


    logic[31:0] haddr;         
    logic[1:0] htrans;         
    logic      hwrite;         
    logic[2:0] hsize;          
    logic[2:0] hburst;        
    logic[31:0] hwdata;        
    logic[31:0] hrdata;        
    logic      hready;   
    logic[1:0] hresp;          
    logic[3:0] hmaster;        
    logic      hsel;           
    logic      hmastlock;      
    logic      hbusreq;         
    logic      hlock;          
    logic      hgrant;               


    clocking s_cb @(posedge hclk);

    input haddr,hwrite,htrans,hsize,hburst,hwdata,hmaster,hmastlock,hsel;
    output hready,hresp,hrdata;

    endclocking


endinterface : salve_if
interface arbiter_if(input hclk, input hreset);
    
    import integration_pkg::*;
    
    /* 
    Voi grupa semnalele in asa fel incat cele corespunzatoare de master se vor conecta la un Agent de tip master, 
    iar semnalele corespunzatoare de slave la Agentul de Slave
    De exemplu, daca voi avea 3 slave si 11 masters, voi avea 14 interfete. 
    unele semnale se repeta in dut ( acelasi semnal, dar pentru instanta de master/ slave) deci
    pot reduce numarul de semnale din interfata.
    */


    wire[31:0] haddr;         
    wire[1:0] htrans;         
    wire      hwrite;         
    wire[2:0] hsize;          
    wire[2:0] hburst;         
    wire[31:0] hwdata;        
    wire[31:0] hrdata;        
    wire      hready;         
    wire[1:0] hresp;          
    wire[3:0] hmaster;        
    wire      hsel;           
    wire      hmastlock;      
    wire      busreq;         
    wire      hlock;          
    wire      hgrant;         
    wire      hsplit;         




    // modport master (
    // input hgrant,hready,hresp,hrdata,
    // output htrans,haddr,hsize,hburst,hwdata,busreq,hlock,hwrite
    // );

    // modport slave (
    // input haddr,hwrite,htrans,hsize,hburst,hwdata,hmaster,hmastlock,hsel,
    // output hready,hresp,hrdata
    // );

    clocking m_cb @(posedge hclk);

    input hgrant,hready,hresp,hrdata;
    output htrans,haddr,hsize,hburst,hwdata,busreq,hlock,hwrite;

    endclocking


    clocking s_cb @(posedge hclk);

    input haddr,hwrite,htrans,hsize,hburst,hwdata,hmaster,hmastlock,hsel;
    output hready,hresp,hrdata;

    endclocking


endinterface : arbiter_if
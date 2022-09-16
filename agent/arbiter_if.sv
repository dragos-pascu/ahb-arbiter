`ifndef CYCLE
    `define CYCLE 10
`endif
`ifndef Tdrive
    `define Tdrive #(0.2*`CYCLE)
`endif

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
    //default input #1step output `Tdrive;
    input hgrant,hready,hresp,hrdata;
    output htrans,haddr,hsize,hburst,hwdata,hbusreq,hlock,hwrite;


    endclocking


    property no_nonseq_after_busy;
        @(posedge hclk) disable iff(!hreset)
                (hburst == 0) |=> (htrans != 1);
    endproperty

    /*------TRANSFER PROPERTIES*/

    
    //1KB Boundry Check Incrementing burst
    property kb_boundry_p;
        @(posedge hclk) disable iff(!hreset)
            (htrans == 3) |-> (haddr[10:0] != 11'b1_00000_00000);
    endproperty

    //Address Check for INCR/INCRx transfer
    property incr_addr_p;
        @(posedge hclk) disable iff(!hreset)
            (htrans == 3) && ((hburst == 1)||(hburst == 3)||(hburst == 5)||(hburst == 7)) &&
            ($past(htrans, 1) != 1) && ($past(hready, 1)) |-> (haddr == ($past(haddr, 1) + 2**hsize));
    endproperty

    //Address Check for WRAP4 hsize = WORD  
    property wrap4_word_addr_p;
        @(posedge hclk) disable iff(!hreset)
            (htrans == 3) && (hburst == 2) && (hsize == 2) && ($past(htrans, 1) != 1) && ($past(hready, 1)) |->
            ((haddr[3:2] == ($past(haddr[3:2], 1) + 1)) && (haddr[31:4] == $past(haddr[31:4], 1)));
    endproperty

    //Address Check for WRAP8 hsize = WORD  
    property wrap8_word_addr_p;
        @(posedge hclk) disable iff(!hreset)
            (htrans == 3) && (hburst == 4) && (hsize == 2) && ($past(htrans, 1) != 1) && ($past(hready, 1)) |->
            ((haddr[4:2] == ($past(haddr[4:2], 1) + 1)) && (haddr[31:5] == $past(haddr[31:5], 1)));
    endproperty

    //Address Check for WRAP16 Word 
    property wrap16_word_addr_p;
        @(posedge hclk) disable iff(!hreset)
            (htrans == 3) && (hburst == 6) && (hsize == 2) && ($past(htrans, 1) != 1) && ($past(hready, 1)) |->
            ((haddr[5:2] == ($past(haddr[5:2], 1) + 1)) && (haddr[31:6] == $past(haddr[31:6], 1)));
    endproperty

    //Address Aligned for Word
    property addr_alignment_word_p;
        @(posedge hclk) disable iff(!hreset)
            hsize == 2 |-> haddr[1:0] == 0;
    endproperty

    //NONSEQ Single transfer should not follow BUSY or SEQ      
    property no_busy_single_burst_p;
        @(posedge hclk) disable iff(!hreset)
            (hburst == SINGLE) |=> ((htrans != BUSY) || (htrans != SEQ));
    endproperty


    //Control Signals are identical for first transfer (BURST) . if in SEQ and not SINGLE, check previous ctrl signals
    property ctrl_sig_same_p;
        @(posedge hclk) disable iff(!hreset)
            hburst == SEQ && htrans != SINGLE -> (( (hwrite == $past(hwrite, 1) ) 
                                        && ( hsize == $past(hsize, 1) ) 
                                        && ( hburst == $past(hburst,1)) ));
    endproperty


    //After BUSY address and control signals must reflect the next transfer in the burst
    // property busy_write_p;
    //     @(posedge hclk) disable iff(!hreset)
    //         ((htrans == BUSY) && ##1 (htrans != IDLE) |=> (($past(HWDATA, 1) == $past(HWDATA, 2)) &&
    //         ($past(HADDR, 1) == $past(HADDR, 2)));
    // endproperty


    /*Check that the burst transfer doesn’t finish with a BUSY transfer (if incrementing or wrap-
ping) but with a SEQ.*/

    ONE_KB: assert property(kb_boundry_p);
    INCR_ADDR: assert property(incr_addr_p);
    WRAP4_ADDR : assert property (wrap4_word_addr_p);   
    WRAP8_ADDR : assert property (wrap8_word_addr_p);
    WRAP16_ADDR : assert property (wrap16_word_addr_p);       
    ADDR_ALIGNMENT : assert property(addr_alignment_word_p);
    SINGLE_NO_BUSY: assert property(no_busy_single_burst_p);
    SAME_CTRL_SIG : assert property(ctrl_sig_same_p);
    

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
    //default input #1step output `Tdrive;
    input haddr,hwrite,htrans,hsize,hburst,hwdata,hmaster,hmastlock,hsel;
    output hready,hresp,hrdata;

    endclocking



    //OKAY Slave response to IDLE and BUSY
    property slave_reponse_p;
        @(posedge hclk) disable iff(!hreset)
            htrans == IDLE || htrans == BUSY |-> hresp == OKAY;
    endproperty;

    /* HREADY == 0 , the master must not change the transfer
type (except for IDLE and BUSY)*/
    property same_transfer_tye_p;
        @(posedge hclk) disable iff(!hreset)
            hready == 0 && ((htrans!= BUSY) || (htrans != IDLE) )
                  |=> (htrans == $past(htrans, 1));
    endproperty
    
    SLAVE_RESPONSE: assert property(slave_reponse_p);
    SAME_HTRANS_EXCEPT_IDLE_OR_BUSY: assert property(same_transfer_tye_p);
    

endinterface : salve_if


        



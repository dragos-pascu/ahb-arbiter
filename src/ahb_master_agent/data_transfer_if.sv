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
    logic      hbusreq;         
    logic      hlock;          
    logic      hgrant;              





    clocking m_cb @(posedge hclk);
    //default input #1step output `Tdrive;
    input hgrant,hready,hresp,hrdata;
    inout htrans,haddr,hsize,hburst,hwdata,hbusreq,hlock,hwrite;

    endclocking


    

    /*------TRANSFER PROPERTIES*/

    
    //1KB Boundry Check Incrementing burst
    property kb_boundry_p;
        @(posedge hclk) disable iff(!hreset)
            (htrans == SEQ) |-> (haddr[10:0] != 11'b1_00000_00000);
    endproperty

    //Address Check for INCR/INCRx transfer
    property incr_addr_p;
        @(posedge hclk) disable iff(!hreset)
            (htrans == SEQ) && ((hburst == INCR)||(hburst == INCR4)||(hburst == INCR8)||(hburst == INCR16)) &&
            ($past(htrans, 1) != BUSY) && ($past(hready, 1)) |-> (haddr == ($past(haddr, 1) + 2**hsize));
    endproperty

    //Address Check for WRAP4 hsize = WORD  
    property wrap4_word_addr_p;
        @(posedge hclk) disable iff(!hreset)
            (htrans == SEQ) && (hburst == WRAP4) && (hsize == WORD) && ($past(htrans, 1) != BUSY) && ($past(hready, 1)) |->
            ((haddr[3:2] == ($past(haddr[3:2], 1) + 1)) && (haddr[31:4] == $past(haddr[31:4], 1)));
    endproperty

    //Address Check for WRAP8 hsize = WORD  
    property wrap8_word_addr_p;
        @(posedge hclk) disable iff(!hreset)
            (htrans == SEQ) && (hburst == WRAP8) && (hsize == WORD) && ($past(htrans, 1) != BUSY) && ($past(hready, 1)) |->
            ((haddr[4:2] == ($past(haddr[4:2], 1) + 1)) && (haddr[31:5] == $past(haddr[31:5], 1)));
    endproperty

    //Address Check for WRAP16 Word 
    property wrap16_word_addr_p;
        @(posedge hclk) disable iff(!hreset)
            (htrans == SEQ) && (hburst == WRAP16) && (hsize == WORD) && ($past(htrans, 1) != BUSY) && ($past(hready, 1)) |->
            ((haddr[5:2] == ($past(haddr[5:2], 1) + 1)) && (haddr[31:6] == $past(haddr[31:6], 1)));
    endproperty

    //Address Aligned for Word
    property addr_alignment_word_p;
        @(posedge hclk) disable iff(!hreset)
            hsize == WORD |-> haddr[1:0] == 0;
    endproperty

    //Address Aligned for Halfword
    property addr_alignment_halfword_p;
        @(posedge hclk) disable iff(!hreset)
            hsize == HALFWORD |-> haddr[0] == 1'b0;
    endproperty

    //NONSEQ Single transfer should not be followed BUSY or SEQ      
    property no_busy_single_burst_p;
        @(posedge hclk) disable iff(!hreset)
            (hburst == SINGLE) |=> ((htrans != BUSY) || (htrans != SEQ));
    endproperty


    //Control Signals are identical to the first transfer (WRAP/INCR) . if in SEQ and not SINGLE, check previous ctrl signals
    property ctrl_sig_same_p;
        @(posedge hclk) disable iff(!hreset)
            htrans == SEQ && hburst != SINGLE |-> (( (hwrite == $past(hwrite, 1) ) 
                                        && ( hsize == $past(hsize, 1) ) 
                                        && ( hburst == $past(hburst,1)) ));
    endproperty


    //After BUSY address and control signals must reflect the next transfer in the burst
    // property busy_write_p;
    //     @(posedge hclk) disable iff(!hreset)
    //         ((htrans == BUSY) && ##1 (htrans != BUSY) |-> (($past(hwdata, 1) != hwdata) &&
    //         ($past(haddr, 1) != haddr);
    // endproperty


    /*Check that the burst transfer doesn’t finish with a BUSY transfer (if incrementing or wrap-
ping) but with a SEQ.*/
    
    // After a SINGLE burst transfer there can`t be a BUSY.
    property no_busy_after_single_p;
        @(posedge hclk) disable iff(!hreset)
                (hburst == SINGLE) |=> (htrans != BUSY);
    endproperty

    /* HREADY == 0 , the master must not change the transfer
    type (except for IDLE and BUSY)*/
    property same_transfer_tye_p;
        @(posedge hclk) disable iff(!hreset)
            hready == 0 && ((htrans!= BUSY) || (htrans != IDLE) )
                  |=> (htrans == $past(htrans, 1));
    endproperty

    /* Address lasts for a single HCLK cycle unless its extended by the previous bus transfer*/
    // property adr_phase_duration_p;
    //     @(posedge hclk) disable iff(!hreset)
    //         hready != 0 |=> (haddr != $past(haddr, 1));
    // endproperty

    // property single_htrans_value_p;
    //     @(posedge hclk) disable iff(!hreset)
    // endproperty

    property burst_htrans_value_p;
        @(posedge hclk) disable iff(!hreset)
            hburst != SINGLE |=> htrans != NONSEQ ;
    endproperty

    ONE_KB: assert property(kb_boundry_p);
    INCR_ADDR: assert property(incr_addr_p);
    WRAP4_WORD_ADDR : assert property (wrap4_word_addr_p);   
    WRAP8_WORD_ADDR : assert property (wrap8_word_addr_p);
    WRAP16__WORD_ADDR : assert property (wrap16_word_addr_p);       
    ADDR_ALIGNMENT_WORD : assert property(addr_alignment_word_p);
    ADDR_ALIGNMENT_HALFWORD : assert property(addr_alignment_halfword_p);
    SINGLE_NO_BUSY: assert property(no_busy_single_burst_p);
    SAME_CTRL_SIG : assert property(ctrl_sig_same_p);
    WAITED_SAME_TRANSFER_TYPE: assert property(same_transfer_tye_p);
    NO_BUSY_AFTER_SINGLE : assert property(no_busy_after_single_p);
    
    
    //FIRST_HTRANS_VALUE : assert property(first_htrans_value_p);
    //ADDR_PHASE_DURATION : assert property(adr_phase_duration_p);


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
                         


    clocking s_cb @(posedge hclk);
    //default input #1step output `Tdrive;
    input haddr,hwrite,htrans,hsize,hburst,hwdata,hmaster,hmastlock,hsel;
    inout hready,hresp,hrdata;

    endclocking


    //Slave response to IDLE and BUSY is OKAY
    property idle_busy_response_p;
        @(posedge hclk) disable iff(!hreset)
            (htrans == IDLE || htrans == BUSY && hready == 1) |-> hresp == OKAY;
    endproperty

    //Sampling occures when hsel and hready is HIGH.
    property slave_sample_p;
        @(posedge hclk) disable iff(!hreset)
            hsel == 1 || hready == 1 |=> haddr != $past(haddr, 1);
    endproperty

    
    IDLE_BUSY_RESPONSE: assert property(idle_busy_response_p);
    // SLAVE_SAMPLE: assert property(slave_sample_p);
    


        /**************COVERAGE FOR SLAVE INTERFACE*****************/

    
    covergroup ahb_cg_slave @(hclk iff (hsel && hready));

        //option.per_instance = 1;

        //add reset



        hrdata: coverpoint hrdata {option.auto_bin_max = 6;}
        hready: coverpoint hready;
        hresp: coverpoint hresp {bins rsp = {OKAY, ERROR};}

        //cross cov
        hrespXhready : cross hready , hresp;



    endgroup


        
    

endinterface : salve_if


        



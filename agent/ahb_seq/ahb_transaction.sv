
import integration_pkg::*;
class ahb_transaction extends uvm_sequence_item;
        
        //id of the coresponding master
        int id; 
        //address, control and data
        rand logic [31:0] haddr[];
        rand size_t  hsize; 
        rand burst_t hburst;  
        rand rw_t hwrite; // read/write
        rand transfer_t htrans[];
        rand logic [31:0] hwdata[];  
        
        //busy transfer
        rand int no_of_busy = 0; // including busy
        rand int busy_pos;

        //bus req signals
        rand logic  hlock; 
        rand logic  hbusreq; 

        //slave response signals
        rand bit hready;
        rand resp_t hresp; 
        rand bit [31:0] hrdata;
        rand bit no_of_waits[];

        

        
        /*****Add other signals for sampling******/

        logic [31:0] address_list[$];

        `uvm_object_utils(ahb_transaction)

        function new(string name = "ahb_transaction");
            super.new(name);

        endfunction
        
        virtual function string convert2string();
                string s = super.convert2string();
                $sformat (s, "%s\n   ahb_transaction with id = %0d :", s,id);
                $sformat (s, "%s\n   hbusreq = %0d", s, hbusreq);
                $sformat (s, "%s\n   hlock   = %0d", s, hlock);
                $sformat (s, "%s\n   haddr   = %p", s, haddr);
                $sformat (s, "%S\n   hwdata  = %p", s, hwdata);
                $sformat (s, "%S\n   hburst  = %0d", s, hburst);
                $sformat (s, "%S\n   htrans  = %p", s, htrans);
                $sformat (s, "%S\n   hsize   = %0d", s, hsize);
                $sformat (s, "%S\n   hready  = %0d", s, hready);
                $sformat (s, "%S\n   hresp   = %0d", s, hresp);
                $sformat (s, "%S\n   hrdata  = %0d", s, hrdata);
                $sformat (s, "%S\n   no_of_waits  = %p", s, no_of_waits);
                $sformat (s, "%S\n   busy_pos  = %0d", s, busy_pos);
                $sformat (s, "%S\n   no_of_busy  = %0d", s, no_of_busy);
                return s;
        endfunction 

        virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
                bit res;
                ahb_transaction tx_rhs;
                if(!$cast(tx_rhs,rhs))
                        `uvm_fatal(get_type_name(),"Illegal rhs argument")

                
                res = super.do_compare(rhs,comparer) &&
                        //the master that initiates the transaction
                        (id ===       tx_rhs.id) &&
                        //data that was sent by master vs received by slave
                        (haddr    === tx_rhs.haddr ) &&
                        (hwdata   === tx_rhs.hwdata) &&
                        (hburst   === tx_rhs.hburst) &&
                        (htrans   === tx_rhs.htrans) &&
                        (hsize    === tx_rhs.hsize ) &&
                        (hwrite   === tx_rhs.hwrite) &&
                        //the slave response vs what master received
                        (hready   === tx_rhs.hready) &&
                        (hresp   === tx_rhs.hresp) ;
                        //(hrdata   === tx_rhs.hrdata);
                return res;
                
        endfunction

        // function void post_randomize(int haddr);
        //         address_list.push_back(haddr);       
        // endfunction

        // constraint read_address{
        //         if (hwrite==READ) {
        //               foreach (haddr[i]) {
        //                 haddr[i] inside {address_list};
        //               }   
        //         }
       
        // }

        constraint requests{
                hlock == 1;
                hbusreq == 1;
        }

        constraint noumber_of_busy{
                if(hburst != SINGLE)
                {
                        no_of_busy >= 0;
                        no_of_busy < 6;
                }
                
        }

        constraint busy_position{
                if(hburst != SINGLE)
                {
                        busy_pos > 0;
                        busy_pos < haddr.size - 1;
                }
                
        }

        constraint wait_size{
                no_of_waits.size >= 0;
                no_of_waits.size <= 17;
                
        }

        constraint number_of_waits_values{
                foreach (no_of_waits[i]) {
                        if (i == no_of_waits.size - 1) {
                                no_of_waits[i]==1;
                        }
                                
                        else {
                                no_of_waits[i]==0;
                        }
                                
                }
        }

        constraint address_size {
                //haddr Based on hburst and hsize
                if(hburst == SINGLE)
                        haddr.size == 1;
                if(hburst == INCR)
                        //haddr.size < (1024/(2^hsize));
                        haddr.size < 256; // problem using the above formula, number is for hsize == WORD
                if(hburst == WRAP4 || hburst == INCR4)
                        haddr.size == 4;
                if(hburst == WRAP8 || hburst == INCR8)
                        haddr.size == 8;
                if(hburst == WRAP16 || hburst == INCR16)
                        haddr.size == 16;
        }     

        constraint addr_wrap4_word{
                if((hburst == WRAP4) && (hsize == WORD)){
                        foreach(haddr[i]){
                                if(i != 0){
                                        haddr[i][3:2] == haddr[i-1][3:2] + 1;
                                        haddr[i][31:4] == haddr[i-1][31:4];
                                }
                        }
                }
        }   


        constraint addr_wrap8_word{
                if((hburst == WRAP8) && (hsize == WORD)){
                        foreach(haddr[i]){
                                if(i != 0){
                                        haddr[i][4:2] == haddr[i-1][4:2] + 1;
                                        haddr[i][31:5] == haddr[i-1][31:5];
                                }
                        }
                }
        }

        constraint adddr_wrap16_word{
                if((hburst == WRAP16) && (hsize == WORD)){
                        foreach(haddr[i]){
                                if(i != 0){
                                        haddr[i][5:2] == haddr[i-1][5:2] + 1;
                                        haddr[i][31:6] == haddr[i-1][31:6];
                                }
                        }
                }
        }

        constraint addr_size_max_limit {
                foreach(haddr[i])
                        haddr[i] < 350;
                
        }  
        constraint addr_size_limit {
                haddr.size > 0;
        }
        
        constraint onekb_boundry {
        if(hburst == INCR)
                haddr[0][10:0] <= (1024 - ((haddr.size)*(2**hsize)));
        if((hburst == WRAP4) || (hburst == INCR4))
                haddr[0][10:0] <= (1024 - 4*(2**hsize));
        if((hburst == WRAP8) || (hburst == INCR8))
                haddr[0][10:0] <= (1024 - 8*(2**hsize));
        if((hburst == WRAP16) || (hburst == INCR16))
                haddr[0][10:0] <= (1024 - 16*(2**hsize));
        }     

        constraint word_boundary{
                if(hsize == HALFWORD){
                        foreach(haddr[i])
                                haddr[i][0] == 1'b0;
                }
                if(hsize == WORD){
                        foreach(haddr[i])
                                haddr[i][1:0] == 2'b0;
                }
        }

        constraint hsize_value{
                hsize == WORD;  
        }

        constraint addr_val {
                if(hburst != SINGLE){
                        if(hburst == INCR || hburst == INCR4 || hburst == INCR8 || hburst == INCR16){
                                foreach(haddr[i]){
                                        if(i != 0){
                                        //ahb 2 pg 50
                                        haddr[i] == haddr[i-1] + 2**hsize;
                                        }
                                }
                        }
                }
        }          

        constraint wdata_solve {
                                solve hburst before haddr;
                                solve haddr before hwdata;
                                solve haddr before htrans;
                                solve haddr before busy_pos;
                                solve hsize before haddr;
                                }

                    
        constraint write_data {
                hwdata.size == haddr.size;
        }

        constraint nonseq_or_idle {
                if(hburst == SINGLE){
                        htrans.size == 1;
                        htrans[0] inside {IDLE, NONSEQ};
                }
        }        

        constraint burst_transfer {  
                if((haddr.size == 1) && (hburst == INCR)){
                        htrans.size == 1 + no_of_busy;
                        htrans[0] == NONSEQ; 
                }
                else if(hburst != SINGLE){
                        htrans.size == haddr.size + no_of_busy;
                        foreach(htrans[i]){
                                if(i == 0)
                                        htrans[i] == NONSEQ;
                                else
                                        htrans[i] == SEQ;
                        }
                } 
        }  


         
        function void post_randomize();
                int flag = 1;
                foreach (htrans[i]) begin
                        if (i>= busy_pos && i<busy_pos + no_of_busy) begin
                                if (flag) begin
                                        htrans[i] = BUSY;
                                        flag = 0;
                                end else begin
                                        htrans[i] = IDLE;
                                end
                        end
                end

         endfunction

endclass
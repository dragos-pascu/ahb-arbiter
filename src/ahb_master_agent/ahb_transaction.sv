

class ahb_transaction extends uvm_sequence_item;
        `uvm_object_utils(ahb_transaction)

        //id of the coresponding agent
        int id; 
        //haddr, control and data
        rand logic [31:0] haddr[];
        rand size_t  hsize; 
        rand burst_t hburst;  
        rand rw_t hwrite; // read/write
        rand transfer_t htrans[];
        rand logic [31:0] hwdata[];  
        
        //busy transfer
        rand int no_of_busy; 
        rand int busy_pos;

        //bus req signals
        rand logic  hlock; 
        rand logic  hbusreq; 
        rand int lock_duration; // how many cycles lock will be 1.

        //slave response signals
        rand bit hready;
        rand resp_t hresp; 
        rand bit [31:0] hrdata;

        rand bit no_of_waits[];

        //slave select
        logic hsel;
        
        /*****Add other signals for sampling******/

        logic [31:0] haddr_list[$];

        function new(string name = "ahb_transaction");
            super.new(name);

        endfunction
        
        virtual function string convert2string();
                string s = super.convert2string();
                $sformat (s, "%s\n   ahb_transaction with id = %0d :", s,id);
                $sformat (s, "%s\n   hbusreq = %0d", s, hbusreq);
                $sformat (s, "%s\n   hlock   = %0d", s, hlock);
                $sformat (s, "%s\n   lock_duration   = %0d", s, lock_duration);
                $sformat (s, "%s\n   haddr   = %p", s, haddr);
                $sformat (s, "%S\n   hwdata  = %p", s, hwdata);
                $sformat (s, "%S\n   hburst  = %0d", s, hburst);
                $sformat (s, "%S\n   htrans  = %p", s, htrans);
                $sformat (s, "%S\n   hsize   = %0d", s, hsize);
                $sformat (s, "%S\n   hready  = %0d", s, hready);
                $sformat (s, "%S\n   hsel  = %0d", s, hsel);
                $sformat (s, "%S\n   hresp   = %0d", s, hresp);
                $sformat (s, "%S\n   hrdata  = %h", s, hrdata);
                $sformat (s, "%S\n   no_of_waits  = %p", s, no_of_waits);
                $sformat (s, "%S\n   busy_pos  = %0d", s, busy_pos);
                $sformat (s, "%S\n   no_of_busy  = %0d", s, no_of_busy);
                return s;
        endfunction 

        virtual function void do_copy(uvm_object rhs);
                ahb_transaction tx_rhs;
                if(!$cast(tx_rhs,rhs))
                        `uvm_fatal(get_type_name(),"Illegal rhs argument")
                //haddr = rhs.haddr;
                //hwdata = rhs.hwdata;
                hburst = tx_rhs.hburst;
                //htrans = rhs.htrans;
                hsize = tx_rhs.hsize;
                hready = tx_rhs.hready;
                hresp = tx_rhs.hresp;
                hrdata = tx_rhs.hrdata;


                
        endfunction

        virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
                bit res;
                ahb_transaction tx_rhs;
                if(!$cast(tx_rhs,rhs))
                        `uvm_fatal(get_type_name(),"Illegal rhs argument")

                
                res = super.do_compare(rhs,comparer) &&
                        //the master that initiates the transaction
                        //data that was sent by master vs received by slave
                        (haddr    === tx_rhs.haddr ) &&
                        (hwdata   === tx_rhs.hwdata) &&
                        (hburst   === tx_rhs.hburst) &&
                        (htrans   === tx_rhs.htrans) &&
                        (hsize    === tx_rhs.hsize ) &&
                        (hwrite   === tx_rhs.hwrite) &&
                        //the slave response vs what master received
                        (hready   === tx_rhs.hready) &&
                        (hresp   === tx_rhs.hresp) &&
                        (hsel   === tx_rhs.hsel) &&
                        (hrdata   === tx_rhs.hrdata);
                return res;
                
        endfunction

        constraint hrdata_value {
                hrdata > 0;
        }

        constraint requests{
                // hlock == 0;
                hbusreq == 1;
                //hbusreq dist {0:/2,1:/1};
                if (hbusreq) {
                    hlock dist {0:/2,1:/1};    
                }
                   
                
        }
        constraint locked_cycles {
                if (hlock) {
                        lock_duration < haddr.size; 
                        lock_duration > 0;   
                }
                
        }


        //comment this constraint for no busy and post_randomize also.
        constraint busy_position_and_size{
                if(hburst != SINGLE)
                {
                        busy_pos > 0;
                        busy_pos < haddr.size - 1;
                        no_of_busy >= 0;
                        no_of_busy < 6;
                } else {
                        busy_pos == 0;
                        no_of_busy == 0;
                
                }
                        
                
        }

        constraint wait_size{
                no_of_waits.size >= 0;
                no_of_waits.size < 17;
                //between 0 and 16
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

        constraint haddr_size {
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

        constraint addr_wrap4_byte{
                if((hburst == WRAP4) && (hsize == BYTE)){
                        foreach(haddr[i]){
                                if(i != 0){
                                haddr[i][1:0] == haddr[i-1][1:0] + 1;
                                haddr[i][31:2] == haddr[i-1][31:2];
                                }
                        }
                }
        }

        constraint addr_wrap8_byte{
                if((hburst == WRAP8) && (hsize == BYTE)){
                        foreach(haddr[i]){
                                if(i != 0){
                                haddr[i][2:0] == haddr[i-1][2:0] + 1;
                                haddr[i][31:3] == haddr[i-1][31:3];
                                }
                        }
                }
        }
        
        constraint addr_wrap16_byte{
                if((hburst == WRAP16) && (hsize == BYTE)){
                        foreach(haddr[i]){
                                if(i != 0){
                                        haddr[i][3:0] == haddr[i-1][3:0] + 1;
                                        haddr[i][31:4] == haddr[i-1][31:4];
                                }
                        }
                }
        }

        constraint addr_wrap4_halfword{
                if((hburst == WRAP4) && (hsize == HALFWORD)){
                        foreach(haddr[i]){
                                if(i != 0){
                                        haddr[i][2:1] == haddr[i-1][2:1] + 1;
                                        haddr[i][31:3] == haddr[i-1][31:3];
                                }
                        }
                }
        }

        constraint addr_wrap8_halfword{
                if((hburst == WRAP8) && (hsize == HALFWORD)){
                        foreach(haddr[i]){
                                if(i != 0){
                                        haddr[i][3:1] == haddr[i-1][3:1] + 1;
                                        haddr[i][31:4] == haddr[i-1][31:4];
                                }
                        }
                }
        }

        constraint addr_wrap16_halfword{
                if((hburst == WRAP16) && (hsize == HALFWORD)){
                        foreach(haddr[i]){
                                if(i != 0){
                                        haddr[i][4:1] == haddr[i-1][4:1] + 1;
                                        haddr[i][31:5] == haddr[i-1][31:5];
                                }
                        }
                }
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
                if(hsize == WORDx2){
                        foreach(haddr[i])
                                haddr[i][2:0] == 3'b0;
                }
                if(hsize == WORDx4){
                        foreach(haddr[i])
                                haddr[i][3:0] == 4'b0;
                }
                if(hsize == WORDx8){
                        foreach(haddr[i])
                                haddr[i][4:0] == 5'b0;
                }
                if(hsize == WORDx16){
                        foreach(haddr[i])
                                haddr[i][5:0] == 6'b0;
                }
                if(hsize == WORDx32){
                        foreach(haddr[i])
                                haddr[i][6:0] == 7'b0;
                }

        }

        constraint hsize_value{
                hsize <= WORD;  
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

        constraint solve_hlock_duration {
                solve haddr before lock_duration;
                solve hlock before lock_duration;
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
                int temp = no_of_busy;
                for (int i=0; i<htrans.size; ++i) begin
                        if (i==busy_pos) begin
                                while (temp>0) begin
                                        htrans[i] = BUSY;
                                        temp--;
                                        i++;
                                end
                        end
                end
        endfunction

endclass
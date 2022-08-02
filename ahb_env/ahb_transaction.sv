class ahb_transaction extends uvm_sequence_item;
    
        rand bit reset;

        //transfer type
        rand transfer_t trans_type[];

        //address and control
        rand bit [31:0] address  []; 
        rand size_t  trans_size;
        rand burst_t burst_mode;
        rand rw_t read_write;
        bit[3:0] master;

        //data 
        rand bit [31:0] wdata [];
        rand bit [31:0] rdata [];

        //slave response
        rand bit ready;
        resp_t response;


    
        `uvm_object_utils_begin(ahb_transaction)
          `uvm_field_int(reset, UVM_ALL_ON)
          `uvm_field_array_enum(transfer_t, trans_type, UVM_ALL_ON)
          `uvm_field_array_int(address , UVM_ALL_ON)
          `uvm_field_enum(size_t, trans_size, UVM_ALL_ON)
          `uvm_field_enum(burst_t, burst, UVM_ALL_ON)
          `uvm_field_array_int(wdata, UVM_ALL_ON)
          `uvm_field_array_int(rdata, UVM_ALL_ON)
          `uvm_field_enum(rw_t,read_write,UVM_ALL_ON)
          `uvm_field_int(master,UVM_NOCOMPARE)
          `uvm_field_int(ready, UVM_ALL_ON)
          `uvm_field_enum(resp_t, response, UVM_ALL_ON)        
        `uvm_object_utils_end

        function new(string name = "ahb_transaction");
            super.new(name);

        endfunction

        /*
        TODO:
        boundry for wrap transfer constraint
        transfer_type constraint
        boundries
        wait & idle states
        */

        constraint rst { reset == 1;}
        
        constraint transfer_size_cons 
        {
                trans_size < WORD; 
        }

        constraint wdata
        {
                wdata.size == address.size;
        }

        constraint addr_val_incr 
        {
                if(burst_mode != 0){
                        if(burst_mode == INCR || burst_mode == INCR4 || burst_mode == INCR8 || burst_mode == INCR16){
                                        foreach(address[i]){
                                                if(i != 0){
                                                address [i] == address [i-1] + 2**trans_size;
                                                }
                                        }   
                                }
                        }
        }

        constraint addr {
                    //Address Based on BURST Mode and HSIZE
                    if(burst_mode == SINGLE)
                            address.size == 1;
                    if(burst_mode == INCR)
                            address.size < (1024/(2^trans_size));
                    if(burst_mode == WRAP4 || burst_mode == INCR4)
                            address.size == 4;
                    if(burst_mode == WRAP8 || burst_mode == INCR8)
                            address.size == 8;
                    if(burst_mode == WRAP16 || burst_mode == INCR16)
                            address.size == 16;
                    }

        constraint min_addr_size {
                                address.size > 0;
                        }
    


endclass
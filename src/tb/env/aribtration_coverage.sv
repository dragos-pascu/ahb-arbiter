class arbitration_coverage extends uvm_subscriber#(ahb_request);
    `uvm_component_utils(arbitration_coverage)

    /************** COVERAGE FOR DUT ARBITRATION *****************/

    ahb_request tx;
    env_config cfg;

    // covergroup arbitration_cg ;

    //     option.per_instance = 1;

    //     // hbusreq: coverpoint tx.hbusreq{
    //     //     bins hbusreq0 = {'b000000001};
    //     //     bins hbusreq1 = {'b000000010};
    //     //     bins hbusreq2 = {'b000000100};
    //     //     bins hbusreq3 = {'b000001000};
    //     //     bins hbusreq4 = {'b000010000};
    //     //     bins hbusreq5 = {'b000100000};
    //     //     bins hbusreq6 = {'b001000000};
    //     //     bins hbusreq7 = {'b010000000};
    //     //     bins hbusreq8 = {'b100000000};
    //     // }

    //     // hlock: coverpoint tx.hlock{
    //     //     bins hlock0 = {'b000000001};
    //     //     bins hlock1 = {'b000000010};
    //     //     bins hlock2 = {'b000000100};
    //     //     bins hlock3 = {'b000001000};
    //     //     bins hlock4 = {'b000010000};
    //     //     bins hlock5 = {'b000100000};
    //     //     bins hlock6 = {'b001000000};
    //     //     bins hlock7 = {'b010000000};
    //     //     bins hlock8 = {'b100000000};
    //     // }
        
    //     // hbusreqxhlock: cross hbusreq, hlock;

    //     // hgrant: coverpoint tx.grant_number {
    //     //     bins grant[] = {[0:master_number-1]};
    //     // }


    // endgroup

    //https://www.amiq.com/consulting/2015/09/18/functional-coverage-patterns-bitwise-coverage/

    covergroup arbitration_cg with function sample(bit busreq_map[master_number-1:0], bit hlock_map[master_number-1:0] ,int position);
        option.per_instance = 1;
        busreq: coverpoint position iff (busreq_map[position]==1) {
            bins busreq[] = {[0:master_number-1]};
        }
        hlock: coverpoint position iff (hlock_map[position]==1 ) {
            bins hlock[] = {[0:master_number-1]};
        }
        busreqXhlock : cross busreq, hlock;
    endgroup
    
    function void sample_arbitration(bit busreq_map[master_number-1:0] , bit hlock_map[master_number-1:0]);
       for(int i=0;i<master_number;i++)begin
          arbitration_cg.sample(busreq_map,hlock_map,i);
       end
    endfunction


    virtual function void write(ahb_request t);

        sample_arbitration(t.busreq_map, t.hlock_map);
        

    endfunction

    function new(string name = "arbitration_coverage", uvm_component parent);
        super.new(name, parent);
        //walking_1_cg = new();
        arbitration_cg = new();
        cfg = new();
    endfunction

    //Report
    function void report_phase(uvm_phase phase);
            `uvm_info(get_type_name(), $sformatf("Arbitration coverage is: %f", arbitration_cg.get_coverage()), UVM_MEDIUM)
            //`uvm_info(get_type_name(), $sformatf("Arbitration coverage is: %f", walking_1_cg.get_coverage()), UVM_MEDIUM)

    endfunction
endclass
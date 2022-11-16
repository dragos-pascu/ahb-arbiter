class arbitration_coverage extends uvm_subscriber#(ahb_request);
    `uvm_component_utils(arbitration_coverage)

    /************** COVERAGE FOR DUT ARBITRATION *****************/

    ahb_request tx;
    env_config cfg;

    //ca sa nu poluezi ahb_request puteai sa extinzi din scoreboard clasa de arbitration_coverage.
    //https://www.amiq.com/consulting/2015/09/18/functional-coverage-patterns-bitwise-coverage/

    covergroup arbitration_cg with function sample(bit busreq_map[master_number], bit hlock_map[master_number] ,int position);
        option.per_instance = 1;
        busreq: coverpoint position iff (busreq_map[position]==1) {
            bins busreq[] = {[0:master_number-1]};
        }
        busreqXhlock : coverpoint position iff ( busreq_map[position]==1 && hlock_map[position]==1 ) {
            bins busreqXhlock[] = {[0:master_number-1]};
        }
    endgroup
    
    function void sample_arbitration(bit busreq_map[master_number] , bit hlock_map[master_number]);
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
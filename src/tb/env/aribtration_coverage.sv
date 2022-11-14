class arbitration_coverage extends uvm_subscriber#(ahb_request);
    `uvm_component_utils(arbitration_coverage)

    /************** COVERAGE FOR DUT ARBITRATION *****************/

    ahb_request tx;
    env_config cfg;

    covergroup arbitration_cg ;

        option.per_instance = 1;

        // hbusreq: coverpoint tx.hbusreq{
        //     bins hbusreq0 = {'b000000001};
        //     bins hbusreq1 = {'b000000010};
        //     bins hbusreq2 = {'b000000100};
        //     bins hbusreq3 = {'b000001000};
        //     bins hbusreq4 = {'b000010000};
        //     bins hbusreq5 = {'b000100000};
        //     bins hbusreq6 = {'b001000000};
        //     bins hbusreq7 = {'b010000000};
        //     bins hbusreq8 = {'b100000000};
        // }

        // hlock: coverpoint tx.hlock{
        //     bins hlock0 = {'b000000001};
        //     bins hlock1 = {'b000000010};
        //     bins hlock2 = {'b000000100};
        //     bins hlock3 = {'b000001000};
        //     bins hlock4 = {'b000010000};
        //     bins hlock5 = {'b000100000};
        //     bins hlock6 = {'b001000000};
        //     bins hlock7 = {'b010000000};
        //     bins hlock8 = {'b100000000};
        // }
        
        // hbusreqxhlock: cross hbusreq, hlock;

        hgrant: coverpoint tx.grant_number {
            bins grant[] = {[0:master_number-1]};
        }


    endgroup


    virtual function void write(ahb_request t);

        tx = t;
        arbitration_cg.sample();

    endfunction

    function new(string name = "arbitration_coverage", uvm_component parent);
        super.new(name, parent);
        arbitration_cg = new();
        cfg = new();
    endfunction

    //Report
    function void report_phase(uvm_phase phase);
            `uvm_info(get_type_name(), $sformatf("Arbitration coverage is: %f", arbitration_cg.get_coverage()), UVM_MEDIUM)
    endfunction
endclass
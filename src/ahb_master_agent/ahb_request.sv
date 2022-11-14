class ahb_request extends uvm_sequence_item;
        `uvm_object_utils(ahb_request)
    //id of the coresponding master
    int id; 
    int grant_number;

    //bus req signals
    logic  hlock; 
    logic  hbusreq; 
    logic hgrant;

    function new(string name = "ahb_request");
            super.new(name);

    endfunction

    virtual function string convert2string();
                string s = super.convert2string();
                //$sformat (s, "%s\n   ahb_transaction with id = %0d :", s,id);
                $sformat (s, "%s\n   hbusreq = %0d", s, hbusreq);
                $sformat (s, "%s\n   hlock   = %0d", s, hlock);
                $sformat (s, "%s\n   hgrant   = %0d", s, hgrant);
                $sformat (s, "%s\n   granted_master:   = %0d", s, grant_number);
                return s;
        endfunction 
endclass
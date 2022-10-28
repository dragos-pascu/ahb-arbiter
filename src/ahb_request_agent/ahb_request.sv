class ahb_request extends uvm_sequence_item;
    //id of the coresponding master
    int id; 

    //bus req signals
    logic  hlock; 
    logic  hbusreq; 
    logic hgrant;

    function new(string name = "ahb_request");
            super.new(name);

    endfunction

    virtual function string convert2string();
                string s = super.convert2string();
                $sformat (s, "%s\n   ahb_transaction with id = %0d :", s,id);
                $sformat (s, "%s\n   hbusreq = %0d", s, hbusreq);
                $sformat (s, "%s\n   hlock   = %0d", s, hlock);
                $sformat (s, "%s\n   hgrant   = %0d", s, hgrant);
                return s;
        endfunction 
endclass
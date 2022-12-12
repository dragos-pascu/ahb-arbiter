interface test_harness(input hclk, input  hreset);
    
    import integration_pkg::*;
    
    import uvm_pkg::*;

    //master signals

    

    // initial begin
    //   uvm_config_db #(virtual request_if)::set(null,"","req_if", req_if); 
    // end

    wire[32*master_number-1:0] m_hwdata;
    wire[31:0] m_hrdata;
	  wire[32*master_number-1:0] m_haddr;
	  wire[3*master_number-1:0] m_hburst;
	  wire[2*master_number-1:0] m_htrans;
    wire[master_number-1:0] m_hbusreq;
    wire[master_number-1:0] m_hlock;
    wire[1:0] hresp;
    wire hready;
    wire[master_number-1:0] hgrant;
    //wire[2:0] m_hsize; //= 2;
    wire [3*master_number-1:0] m_hsize;
    wire [master_number-1:0]m_hwrite;

    generate
    for(genvar i=0;i<master_number;i++)
    begin: m_if
      master_if master(.*);
      //outputs
      assign m_if[i].master.hresp        =hresp;
      assign m_if[i].master.hready       =hready;
      assign m_if[i].master.hgrant       =hgrant[i];
      assign m_if[i].master.hrdata=m_hrdata;

      //inputs
      assign m_hwrite[(i+1)-1:i]     = m_if[i].master.hwrite;
      assign m_hwdata[32*(i+1)-1:32*i]=m_if[i].master.hwdata;
      assign m_haddr[32*(i+1)-1:32*i] =m_if[i].master.haddr;
      assign m_hburst[3*(i+1)-1:3*i]=m_if[i].master.hburst;
      assign m_htrans[2*(i+1)-1:2*i]=m_if[i].master.htrans;
      assign m_hbusreq[i]    =m_if[i].master.hbusreq;
      assign m_hlock[i]     =m_if[i].master.hlock;
      //assign m_hsize = m_if[i].master.hsize;
      assign m_hsize[3*(i+1)-1:3*i]=m_if[i].master.hsize;


      initial begin 
      uvm_config_db #(virtual master_if)::set(null,"", $sformatf("master[%0d]", i), master); 
      end

    end
    endgenerate

  //slave signals
    wire[31:0] s_hwdata;
    wire[32*slave_number-1:0] s_hrdata;//
    wire[31:0] s_haddr;
    wire[2:0] s_hburst;
    wire[1:0] s_htrans;
    wire s_hmastlock;
    wire [size_out-1:0] s_hmaster;
    //wire[3:0] s_hmaster;
    wire[2*slave_number-1:0] s_hresp;
    wire[slave_number-1:0] s_hready;
    wire[2:0] s_hsize;
    wire[slave_number-1:0] s_hsel;
    wire s_hwrite;


    generate
      for(genvar i=0;i<slave_number;i++)
      begin: s_if
          salve_if slave(.*);
          assign s_if[i].slave.hsel=s_hsel[i];
          assign s_if[i].slave.hsel_array=s_hsel;
          assign s_if[i].slave.hwdata=s_hwdata;
          assign s_if[i].slave.haddr=s_haddr;
          assign s_if[i].slave.hburst=s_hburst;
          assign s_if[i].slave.htrans=s_htrans;
          assign s_if[i].slave.hmastlock=s_hmastlock;
          //assign s_if[i].slave.hmaster=s_hmaster;
          assign s_if[i].slave.hsize=s_hsize;
          assign s_if[i].slave.hwrite=s_hwrite;
          assign s_hrdata[32*(i+1)-1:32*i]=s_if[i].slave.hrdata;
          assign s_hresp[2*(i+1)-1:2*i]=s_if[i].slave.hresp;
          assign s_hready[(i+1)-1:i]=s_if[i].slave.hready;

        initial begin 
        uvm_config_db #(virtual salve_if)::set(null,"", $psprintf("slave[%0d]", i), slave); 
        end 
        

      end
    endgenerate

    //vifs for bus request

    generate
    for(genvar i=0;i<master_number;i++)
    begin: req_if
      request_if bus_req(.*);

      assign req_if[i].bus_req.hbusreq = m_hbusreq[i];
      assign req_if[i].bus_req.hbusreq_array = m_hbusreq;
      assign req_if[i].bus_req.hlock = m_hlock[i];

      assign req_if[i].bus_req.hmaster = s_hmaster ;
      assign req_if[i].bus_req.hgrant  = hgrant[i];
      assign req_if[i].bus_req.hgrant_array = hgrant;
      assign req_if[i].bus_req.hmastlock  = s_hmastlock ; 
      assign req_if[i].bus_req.hready  = hready ; 


      // assign s_hmaster  = req_if[i].bus_req.hmaster;
      // assign hgrant[i]  = req_if[i].bus_req.hgrant;
      // assign s_hmastlock = req_if[i].bus_req.hmastlock;    
      

      initial begin 
      bus_req.interface_number = i;
      uvm_config_db #(virtual request_if)::set(null,"", $sformatf("bus_req[%0d]", i), bus_req); 
      end

    end
    endgenerate

    

    


endinterface
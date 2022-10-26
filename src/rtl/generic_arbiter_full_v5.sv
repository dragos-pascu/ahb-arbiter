//****************************************************************************************************** 
// Copyright (c) 2007 TooMuch Semiconductor Solutions Pvt Ltd. 
//File name : generic_ahb_arbiter.v 
//Designer :Ankur Rawat 
//Date : 20 Sep, 2007 
//Test Bench description :Generic AMB AHBA complain Arbiter. 
//Revision : 1.0 
//****************************************************************************************************** 
`timescale 1ns/1ns
        
module generic_arbiter_full(m_busreq,m_hlock,hclk,hreset,s_hmaster_lock
                            ,s_hready,m_hwdata,s_hrdata,s_data_out,
                            m_haddr,s_addr_out,m_hburst,m_htrans,s_htrans_out,
                            s_hburst_out,s_hmaster,m_hwrite,s_hwrite,hgrant,s_hresp,m_hresp,m_hready,m_hsize,s_hsize,s_hsel,m_hrdata);
  import integration_pkg::*;

    int i;
    input[32*master_number-1:0] m_hwdata;
    input[32*master_number-1:0] m_haddr;
    input[3*master_number-1:0] m_hburst;
    input[2*master_number-1:0] m_htrans;
    input hclk;
    input hreset; // RESET - active low
    input [slave_number-1:0] s_hready;
    input[master_number-1:0] m_busreq;
    input[master_number-1:0] m_hlock;
    input[2*slave_number-1:0] s_hresp; //* 
    input[2:0] m_hsize;//* 
    input[master_number-1:0]m_hwrite;
    input[32*slave_number-1:0] s_hrdata;// to do


    output logic[2:0] s_hburst_out;
    output logic[1:0] s_htrans_out;
    output logic s_hmaster_lock;
    output logic[31:0] s_data_out;
    output logic[31:0] s_addr_out;
    output logic[size_out-1:0] s_hmaster;
    output logic s_hwrite; // to do
    output logic[master_number-1:0] hgrant;//*
    output logic[1:0] m_hresp;// to do
    output logic m_hready;// to do
    output logic[2:0] s_hsize;// to do
    output logic[slave_number-1:0] s_hsel;// to do
    output logic[31:0] m_hrdata;// to do



    logic[32*master_number-1:0] data1;
    logic[32*master_number-1:0] addr1;
    logic[32*master_number-1:0] data2;
    logic[32*master_number-1:0] addr2;
    logic[3*master_number-1:0] hburst1;
    logic[2*master_number-1:0] htrans1;
    logic[3*master_number-1:0] hburst2;
    logic[2*master_number-1:0] htrans2;
    logic[master_number-1:0]hwrite1;
    logic[master_number-1:0]hwrite2;
    logic[size_out-1:0] w_hgrant; 
    logic w_hlock;
    logic hmasterlock;
    logic hlock3;    
    logic [size_out-1:0] j;
    logic [size_out-1:0] inter;
    logic inter1;
    logic [size_out-1:0]hmaster_pre;
    logic hlock_c;
    logic [4:0]count;
    logic [4:0]counter;
    logic hlock_out;
    logic hlock_bus;
    logic[size_out-1:0] m_hgrant;
  
    //*********** my additions
    logic [3:0] slave_id;
    logic  in_range = 0;
    logic [3:0]  id;
    logic [3:0] idx0;
    wire [31:0] m_haddr_granted;



// assign m_haddr_granted = m_haddr[31 + m_hgrant*32:m_hgrant*32];
assign m_haddr_granted = m_haddr >> m_hgrant * 32;


always@(*) begin
  idx0 = 0;
  // m_haddr_granted = m_haddr[31 + m_hgrant*32:m_hgrant*32];
 for(int i=0;i<slave_number;i++) begin
    if ((low_addr[i] <= m_haddr_granted) && (high_addr[i] >= m_haddr_granted) ) begin
        id      = i;
        in_range= 1;
        break;
    end
    idx0++;
  end
end


assign slave_id = in_range ? id : slave_number;

logic [3:0] idx1;

always@(*) begin
  idx1 = 0;
  for(int i=0;i<slave_number;i++) begin 
    if (idx1 == slave_id) begin
      s_hsel[idx1]    = 1;
      //break;
  end
  else begin
      s_hsel[idx1]    = 0;
  end  
  idx1 ++;
  end
end
  
  //always@(m_hgrant)  begin                                ////////////////////////////
  always@(m_hgrant or hreset) begin
    if(hreset) begin
      for(int i = 0; i < master_number; i++) begin
        if(m_hgrant == i)
          hgrant[i]<= 1;
        else
          hgrant[i]<= 0;
       end
    end
    else begin
      for(int i=0;i<master_number;i++)
        hgrant[i]<=0;
    end
    // for(int i = 0; i < master_number; i++)begin
    //   hgrant[i] = i == m_hgrant;
    // end
  end
  always@(posedge hclk)
  begin 
        m_hready <= s_hready >> slave_id;
        m_hresp  <= s_hresp >> 3*slave_id;
        s_hsize  <= m_hsize;
  end
  always@(posedge hclk)
  begin
    if(m_hwrite == 0)begin
      m_hrdata <= s_hrdata>>32*slave_id;
    end
    else begin
      m_hrdata <= 0;
    end
  end
  
  //******************
  always@(posedge hclk)
    
  begin
        
      hmaster_pre <= s_hmaster;
    
  end
  
always @(m_hlock or m_hgrant or s_hmaster_lock or hlock3)
    begin
        
      hlock_out = m_hlock >> m_hgrant;
        
      if(s_hmaster_lock)    
            
        begin
                
          hlock_bus = hlock_out;
            
        end
        
      else
            
        begin
                
          hlock_bus = hlock3;
            
        end
    end
always @(m_busreq or m_hlock)
        
  begin
            
    inter = master_number - 1;
    
    inter1 = 0;
                
    for (j = master_number; j >= 1; j = j - 1)
                
      begin
                    
        if (m_busreq[j-1] == 1)
                        
          begin
                                                    
            w_hgrant    = j-1;
                                                    
            inter       = j-1;
                                            
            w_hlock     = m_hlock[j-1];
                                            
            inter1      = m_hlock[j-1];
                                            
          end
                                    
        else
                                            
          begin
                                                    
            w_hgrant    = inter;
                                            
            w_hlock     = inter1;
                                            
          end
                            
      end
    
  end
  
  always@(posedge hclk or negedge hreset)
        
    begin
              
      if(!hreset) // RESET 
                    
        begin           
          m_hgrant <= master_number - 1;                  /////////////////////////////////////////
          //m_hgrant <= 4'b1000;             
          hlock3 <= 1'b0;    
        end
            
      else if(!hmasterlock)
                            
        begin
                                
          m_hgrant <= w_hgrant;
                                
          hlock3 <= w_hlock; 
                            
        end
        
    end
  always@(s_hmaster_lock )
        
  begin
              
    hmasterlock = s_hmaster_lock;   
        
  end
  always@(posedge hclk or negedge hreset)
    
    begin
        
      if(!hreset) // RESET 
                    
        begin
          s_hmaster = master_number - 1;        
          //s_hmaster = 4'b1000;
                            
          hlock_c = 1'b0;
                    
        end
            
      else  if(s_hready)
                        
        begin
                            
          s_hmaster = m_hgrant;
                            
          hlock_c = hlock_bus;
                        
        end
        
    end
  always@(s_hmaster, addr2, htrans2, hburst2, hwrite2)
    
    begin
      
      s_addr_out   <= addr2 >> 32*s_hmaster;
        
      s_htrans_out <= htrans2 >> 2*s_hmaster;
        
      s_hburst_out <= hburst2 >> 3*s_hmaster;
      s_hwrite <= hwrite2 >> s_hmaster;
        
    end
  always@(hmaster_pre or data2)
    
    begin
        
      s_data_out <= data2 >> 32*hmaster_pre;
    
    end
  always_ff@(posedge hclk or negedge hreset)
    begin
        if(hreset === 0) begin
          data2 <= 0;
          addr2 <= 0;
          htrans2 <= 0;
          hburst2 <= 0;
          hwrite2 <= 0;
        end
        else begin
          if(s_hready)begin           
            data2 <= data1;
            addr2 <= addr1;
            htrans2 <= htrans1;
            hburst2 <= hburst1;
            hwrite2 <= hwrite1;
          end
        end
    end
  always_ff@(posedge hclk or negedge hreset)
    begin
        if(hreset === 0) begin
          data1 <= 0;
          addr1 <= 0;        
          htrans1 <= 0;
          hburst1 <= 0;
          hwrite1 <= 0;
        end 
        else begin
          data1   <= m_hwdata;
          addr1   <= m_haddr;
          htrans1 <= m_htrans;
          hburst1 <= m_hburst;
          hwrite1 <= m_hwrite;
        end
    end
  always@(posedge hclk or negedge hreset)
    
    begin
                 
      if(!hreset) // RESET 
                          
        begin
                                 
          s_hmaster_lock = 1'b0;
                                 
          counter = 5'b00000;
                                 
          count = 5'b00000;
                          
        end
        
      else        
                     
        begin
                               
          case(s_hburst_out)
                                    
            3'b000,3'b001:begin
                                                   
              if(counter == 5'b00000)
                                            
                begin
                                                    
                  counter = 5'b00000; 
                                                                
                  s_hmaster_lock = hlock_c;
                                            
                end
                                               
            end
                                        
            3'b010,3'b011:begin 
                                                  
              if(counter == 5'b00000)
                                                
                begin 
                                                    
                  counter = 5'b00100;
                                                                    
                  s_hmaster_lock = 1'b1;
                                                                    
                  count = 5'b00000;
                                                
                end   
                                            
            end
                                        
            3'b100,3'b101:begin 
                                                
              if(counter == 5'b00000)
                                                
                begin 
                                                
                  counter = 5'b01000; 
                                                                    
                  s_hmaster_lock = 1'b1;
                                                                    
                  count = 5'b00000; 
                     
                end   
                                            
            end
                                        
            3'b110,3'b111:begin 
                                                
              if(counter == 5'b00000)
                                            
                begin 
                                                    
                  counter = 5'b10000; 
                                                                
                  s_hmaster_lock = 1'b1;
                                                                
                  count = 5'b00000;
                                            
                end   
                               
            end
                    
          endcase
    
          case(s_htrans_out) 
                
            2'b10, 2'b11 :begin
                                                
              if ((count+3) <= counter)
                                        
                begin  
                                                
                  count = count+1; 
                                    
                end 
                                
              else if ((count+3) > counter && ((count+1)<counter) )
                            
                begin
                                
                  s_hmaster_lock = hlock_c;
                                
                  count = count+1;
                        
                end
                        
              else
                                        
                begin
                                            
                  counter = 5'b00000;
                                            
                  s_hmaster_lock = hlock_c;
                                            
                  count = 5'b0000;
                                        
                end
                            
            end 
                        
            default: count = count;      
        
          endcase
    
        end
    
    end
endmodule
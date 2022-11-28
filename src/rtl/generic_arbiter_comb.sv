`timescale 1ns/1ns
        
`define LAST_MASTER (master_number-1)
`define LAST_SLAVE  (slave_number -1)

module generic_arbiter_full(m_busreq,m_hlock,hclk,hreset,s_hmaster_lock
                            ,s_hready,m_hwdata,s_hrdata,s_data_out,
                            m_haddr,s_addr_out,m_hburst,m_htrans,s_htrans_out,
                            s_hburst_out,s_hmaster,m_hwrite,s_hwrite,hgrant,s_hresp,m_hresp,m_hready,m_hsize,s_hsize,s_hsel,m_hrdata);
  import integration_pkg::*;

    input[32*master_number-1:0] m_hwdata;//
    input[32*master_number-1:0] m_haddr;//
    input[3*master_number-1:0] m_hburst;//
    input[2*master_number-1:0] m_htrans;//
    input hclk;
    input hreset; // RESET - active low
    input [slave_number-1:0] s_hready;//
    input[master_number-1:0] m_busreq;//
    input[master_number-1:0] m_hlock;//
    input[2*slave_number-1:0] s_hresp;//
    input[3*master_number-1:0] m_hsize;// 
    input[master_number-1:0]m_hwrite;//
    input[32*slave_number-1:0] s_hrdata;//

    output logic[2:0] s_hburst_out; //
    output logic[1:0] s_htrans_out; //
    output logic s_hmaster_lock;    //
    output logic[31:0] s_data_out;  //
    output logic[31:0] s_addr_out; //
    output logic[size_out-1:0] s_hmaster; //
    output logic s_hwrite; //
    output logic[master_number-1:0] hgrant; //
    output logic[1:0] m_hresp; //
    output logic m_hready; //
    output logic[2:0] s_hsize; //
    output logic[slave_number-1:0] s_hsel; //
    output logic[31:0] m_hrdata; //
    
    logic[size_out-1:0] master_phase[3];//0 - arbitration, 1 - address, 2 - data

    always_ff@(posedge hclk or negedge hreset)
    begin
        if (!hreset) begin
            master_phase[ARBITRATION] <= `LAST_MASTER;
            hgrant <= 1 << `LAST_MASTER; //comment for bug0
        end
        else begin
            int m;
            if (m_busreq[master_phase[ARBITRATION]] & m_hlock[master_phase[ARBITRATION]]) begin  // comment for bug 2 V V V V V V V
                m = master_phase[ARBITRATION];
            end   
            else begin  // comment for bug 2 A A A A A A
                for (m = 0; m <= `LAST_MASTER; m++ )
                begin
                    if (m_busreq[m] || m == `LAST_MASTER) begin
                        break;
                    end
                end
            end // comment for bug 2
            master_phase[ARBITRATION] <= m;
            hgrant <= 1 << m;
        end
    end

    always_ff@(posedge hclk or negedge hreset)
    begin
        if (!hreset) begin
            master_phase[ADDRESS] <= `LAST_MASTER;
            master_phase[DATA] <= `LAST_MASTER;
        end
        else begin
            if (m_hready) begin
                master_phase[ADDRESS] <= master_phase[ARBITRATION];
                master_phase[DATA] <= master_phase[ADDRESS];
            end
        end
    end

    wire [31:0] master_address = m_haddr[32*master_phase[ADDRESS] +: 32]; 
    reg  [31:0] master_address_d; 
    wire [1:0]  master_htrans  = m_htrans[2*master_phase[ADDRESS] +: 2];

    assign s_hburst_out = m_hburst[3*master_phase[ADDRESS] +: 3];
    assign s_hmaster_lock = m_hlock[master_phase[ADDRESS]];
    assign s_hmaster = master_phase[ADDRESS];
    assign s_hwrite  = m_hwrite[master_phase[ADDRESS]];
    assign s_hsize   = m_hsize[3*master_phase[ADDRESS] +: 3];

    //wire [size_out_s-1:0] address_selected_slave = decode_slave(master_address);//bug_1
    wire [31:0] slave_sel_address = m_hready ? master_address : master_address_d;
    wire [size_out_s-1:0] address_selected_slave = decode_slave(slave_sel_address);//bug_1
    reg  [size_out_s-1:0] data_selected_slave;
    assign s_hsel       = 1 << address_selected_slave;
    assign s_htrans_out = master_htrans;
    assign s_addr_out   = master_address;
    assign s_data_out   = m_hwdata[32*master_phase[DATA] +: 32];

    always_ff@(posedge hclk or negedge hreset) begin
        if (!hreset) begin
            data_selected_slave <= {size_out_s{1'b1}};
        end
        else begin
            if (m_hready) begin
                master_address_d <= master_address;
                data_selected_slave <= address_selected_slave;
            end
        end
    end

    assign m_hready = data_selected_slave < slave_number ? s_hready[data_selected_slave] : 1;

    //wire selected_slave_valid = address_selected_slave < slave_number; //bug 3
    wire selected_slave_valid = data_selected_slave < slave_number;
    assign m_hrdata = selected_slave_valid ? s_hrdata >> 32*data_selected_slave : 0;
    assign m_hresp  = selected_slave_valid ? s_hresp >> 2*data_selected_slave : 0;

    function logic[size_out_s-1:0] decode_slave (input [31:0] address);
        int s;
        decode_slave = {size_out_s{1'b1}};
        for (s = 0; s < slave_number;s++)
            if (address >= slave_low_address[s] && address <= slave_high_address[s])
                break;
        decode_slave = s;
    endfunction

endmodule
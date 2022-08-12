class slave_sequencer extends uvm_sequencer #(ahb_transaction);

  `uvm_component_utils(slave_sequencer)
  
  uvm_analysis_export #(ahb_transaction) m_request_export;
  uvm_tlm_analysis_fifo #(ahb_transaction) m_request_fifo;

  function new(string name = "slave_sequencer", uvm_component parent);
    super.new(name, parent);

    m_request_export = new("m_request_export",this);
    m_request_fifo = new("m_request_fifo",this);
    
  endfunction: new

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    m_request_export.connect(m_request_fifo.analysis_export);
  endfunction


endclass
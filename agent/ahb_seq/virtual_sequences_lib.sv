class virtual_simple_write_sequence extends virtual_base_sequence;
    `uvm_object_utils(virtual_simple_write_sequence)
    simple_write_sequence wr_seq_h;
    function new(string name="virtual_simple_write_sequence");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_info(get_type_name(), "Executing virtual_simple_write_sequence", UVM_MEDIUM)
        for(int i=0;i<master_number;i++)begin
         automatic int j=i;
        fork begin
            wr_seq_h = simple_write_sequence::type_id::create("simple_write_sequence");
            wr_seq_h.start(p_sequencer.master_seqr[j]);
         end
        join
      end
    endtask


endclass

class virtual_incr_write_4sequence extends virtual_base_sequence;
    `uvm_object_utils(virtual_incr_write_4sequence)
    incr_write_4sequence wr_seq_h;
    function new(string name="virtual_incr_write_4sequence");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_info(get_type_name(), "Executing virtual_incr_write_4sequence", UVM_MEDIUM)
        for(int i=0;i<master_number;i++)begin
         automatic int j=i;
        fork begin
            wr_seq_h = incr_write_4sequence::type_id::create("incr_write_4sequence");
            wr_seq_h.start(p_sequencer.master_seqr[j]);
         end
        join
      end
    endtask

endclass
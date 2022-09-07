class virtual_simple_write_sequence extends virtual_base_sequence;
    `uvm_object_utils(virtual_simple_write_sequence)
    function new(string name="virtual_simple_write_sequence");
        super.new(name);
    endfunction

        virtual task pre_body();
        if(starting_phase !=null)
            starting_phase.raise_objection(this, get_type_name());
    endtask

    virtual task post_body();
        if (starting_phase != null) begin
            starting_phase.drop_objection(this, get_type_name());
        end
    endtask


    virtual task body();
        `uvm_info(get_type_name(), "Executing virtual_simple_write_sequence", UVM_MEDIUM)
        for(int i=0;i<master_number;i++)begin
        automatic int j=i;
        fork begin
            simple_write_sequence wr_seq_h;
            wr_seq_h = simple_write_sequence::type_id::create("simple_write_sequence");
            wr_seq_h.start(p_sequencer.master_seqr[j]);
         end
        join
      end
    endtask


endclass

class virtual_incr_write_4sequence extends virtual_base_sequence;
    `uvm_object_utils(virtual_incr_write_4sequence)
    function new(string name="virtual_incr_write_4sequence");
        super.new(name);
    endfunction

    virtual task pre_body();
        if(starting_phase !=null)
            starting_phase.raise_objection(this, get_type_name());
    endtask

    virtual task post_body();
        if (starting_phase != null) begin
            starting_phase.drop_objection(this, get_type_name());
        end
    endtask


    virtual task body();
        `uvm_info(get_type_name(), "Executing virtual_incr_write_4sequence", UVM_MEDIUM)
        for(int i=0;i<master_number;i++)begin
        automatic int j=i;
        fork begin
            incr_write_4sequence wr_seq_h;
            wr_seq_h = incr_write_4sequence::type_id::create("incr_write_4sequence");
            wr_seq_h.starting_phase=starting_phase;
            wr_seq_h.start(p_sequencer.master_seqr[j]);
         end
        join_none
        
      end
      //wait fork;
    endtask

endclass
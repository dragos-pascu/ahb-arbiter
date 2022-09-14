class virtual_simple_write_sequence extends virtual_base_sequence;
    `uvm_object_utils(virtual_simple_write_sequence)
    function new(string name="virtual_simple_write_sequence");
        super.new(name);
    endfunction

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


class virtual_incr_write_sequence extends virtual_base_sequence;
    `uvm_object_utils(virtual_incr_write_sequence)
    function new(string name="virtual_incr_write_sequence");
        super.new(name);
    endfunction


    virtual task body();
        `uvm_info(get_type_name(), "Executing virtual_incr_write_sequence", UVM_MEDIUM)
   
        begin
            for(int i=0;i<master_number;i++)begin
                automatic int j=i;
                fork begin
                    incr_write_sequence wr_seq_h;
                    wr_seq_h = incr_write_sequence::type_id::create("incr_write_sequence");
                    //wr_seq_h.starting_phase=starting_phase;
                    wr_seq_h.start(p_sequencer.master_seqr[j]);
                end
                join_none
            end
            //wait fork;
        end
       

    
    endtask

endclass


class virtual_incr_write_4sequence extends virtual_base_sequence;
    `uvm_object_utils(virtual_incr_write_4sequence)
    function new(string name="virtual_incr_write_4sequence");
        super.new(name);
    endfunction


    virtual task body();
        `uvm_info(get_type_name(), "Executing virtual_incr_write_4sequence", UVM_MEDIUM)
   
        begin
            for(int i=0;i<master_number;i++)begin
                automatic int j=i;
                fork begin
                    incr_write_4sequence wr_seq_h;
                    wr_seq_h = incr_write_4sequence::type_id::create("incr_write_4sequence");
                    //wr_seq_h.starting_phase=starting_phase;
                    wr_seq_h.start(p_sequencer.master_seqr[j]);
                end
                join_none
            end
            //wait fork;
        end
       

    
    endtask

endclass

class virtual_incr_write_8sequence extends virtual_base_sequence;
    `uvm_object_utils(virtual_incr_write_8sequence)
    function new(string name="virtual_incr_write_8sequence");
        super.new(name);
    endfunction


    virtual task body();
        `uvm_info(get_type_name(), "Executing virtual_incr_write_8sequence", UVM_MEDIUM)
   
        begin
            for(int i=0;i<master_number;i++)begin
                automatic int j=i;
                fork begin
                    incr_write_8sequence wr_seq_h;
                    wr_seq_h = incr_write_8sequence::type_id::create("incr_write_8sequence");
                    //wr_seq_h.starting_phase=starting_phase;
                    wr_seq_h.start(p_sequencer.master_seqr[j]);
                end
                join_none
            end
            //wait fork;
        end
       

    
    endtask

endclass

class virtual_incr_write_16sequence extends virtual_base_sequence;
    `uvm_object_utils(virtual_incr_write_16sequence)
    function new(string name="virtual_incr_write_16sequence");
        super.new(name);
    endfunction


    virtual task body();
        `uvm_info(get_type_name(), "Executing virtual_incr_write_16sequence", UVM_MEDIUM)
   
        begin
            for(int i=0;i<master_number;i++)begin
                automatic int j=i;
                fork begin
                    incr_write_16sequence wr_seq_h;
                    wr_seq_h = incr_write_16sequence::type_id::create("incr_write_16sequence");
                    //wr_seq_h.starting_phase=starting_phase;
                    wr_seq_h.start(p_sequencer.master_seqr[j]);
                end
                join_none
            end
            //wait fork;
        end
       

    
    endtask

endclass



class virtual_incr_read_4sequence extends virtual_base_sequence;
    `uvm_object_utils(virtual_incr_read_4sequence)
    function new(string name="virtual_incr_read_4sequence");
        super.new(name);
    endfunction


    virtual task body();
        `uvm_info(get_type_name(), "Executing virtual_incr_read_4sequence", UVM_MEDIUM)
   
        begin
            for(int i=0;i<master_number;i++)begin
                automatic int j=i;
                fork begin
                    incr_write_4sequence wr_seq_h;
                    wr_seq_h = incr_write_4sequence::type_id::create("incr_write_4sequence");
                    //wr_seq_h.starting_phase=starting_phase;
                    wr_seq_h.start(p_sequencer.master_seqr[j]);
                end
                join_none
            end
            wait fork;
            for(int i=0;i<master_number;i++)begin
                automatic int j=i;
                fork begin
                    incr_read_4sequence read_seq_h;
                    read_seq_h = incr_read_4sequence::type_id::create("incr_read_4sequence");
                    //wr_seq_h.starting_phase=starting_phase;
                    read_seq_h.start(p_sequencer.master_seqr[j]);
                end
                join_none
            end
            //wait fork;
        end
       

    
    endtask

endclass



class virtual_wrap_write_4sequence extends virtual_base_sequence;
    `uvm_object_utils(virtual_wrap_write_4sequence)
    function new(string name="virtual_wrap_write_4sequence");
        super.new(name);
    endfunction


    virtual task body();
        `uvm_info(get_type_name(), "Executing virtual_wrap_write_4sequence", UVM_MEDIUM)
        for(int i=0;i<master_number;i++)begin
        automatic int j=i;
        fork begin
            wrap_write_4sequence wr_seq_h;
            wr_seq_h = wrap_write_4sequence::type_id::create("wrap_write_4sequence");
            //wr_seq_h.starting_phase=starting_phase;
            wr_seq_h.start(p_sequencer.master_seqr[j]);
         end
        join_none
        
      end
      //wait fork;
    endtask

endclass


class virtual_wrap_write_8sequence extends virtual_base_sequence;
    `uvm_object_utils(virtual_wrap_write_8sequence)
    function new(string name="virtual_wrap_write_8sequence");
        super.new(name);
    endfunction


    virtual task body();
        `uvm_info(get_type_name(), "Executing virtual_wrap_write_8sequence", UVM_MEDIUM)
        for(int i=0;i<master_number;i++)begin
        automatic int j=i;
        fork begin
            wrap_write_8sequence wr_seq_h;
            wr_seq_h = wrap_write_8sequence::type_id::create("wrap_write_8sequence");
            //wr_seq_h.starting_phase=starting_phase;
            wr_seq_h.start(p_sequencer.master_seqr[j]);
         end
        join_none
        
      end
      //wait fork;
    endtask

endclass

class virtual_wrap_write_16sequence extends virtual_base_sequence;
    `uvm_object_utils(virtual_wrap_write_16sequence)
    function new(string name="virtual_wrap_write_16sequence");
        super.new(name);
    endfunction


    virtual task body();
        `uvm_info(get_type_name(), "Executing virtual_wrap_write_16sequence", UVM_MEDIUM)
        for(int i=0;i<master_number;i++)begin
        automatic int j=i;
        fork begin
            wrap_write_16sequence wr_seq_h;
            wr_seq_h = wrap_write_16sequence::type_id::create("wrap_write_16sequence");
            //wr_seq_h.starting_phase=starting_phase;
            wr_seq_h.start(p_sequencer.master_seqr[j]);
         end
        join_none
        
      end
    //   wait fork;
    endtask

endclass

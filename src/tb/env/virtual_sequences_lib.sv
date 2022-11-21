

class virtual_base_sequence extends uvm_sequence;
    
    `uvm_object_utils(virtual_base_sequence)
    `uvm_declare_p_sequencer(ahb_vsequencer)	

    // sequences handles

    function new(string name="virtual_base_sequence");
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
        `uvm_info(get_type_name(),"Inside body of virtual base seq.",UVM_MEDIUM)

    endtask
    

endclass

class virtual_random_sequence extends virtual_base_sequence;
    `uvm_object_utils(virtual_random_sequence)
    function new(string name="virtual_random_sequence");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_info(get_type_name(), "Executing virtual_random_sequence", UVM_MEDIUM)
        for(int i=0;i<master_number;i++)begin
        automatic int j=i;
        fork begin
            
            randcase

            1: begin
                single_write_sequence wr_seq_h;
                wr_seq_h = single_write_sequence::type_id::create("single_write_sequence");
                wr_seq_h.start(p_sequencer.master_seqr[j]);
            end

            1: begin
                incr_write_sequence wr_seq_h;
                wr_seq_h = incr_write_sequence::type_id::create("incr_write_sequence");
                wr_seq_h.start(p_sequencer.master_seqr[j]);
            end

            1: begin
                incr_write_4sequence wr_seq_h;
                wr_seq_h = incr_write_4sequence::type_id::create("incr_write_4sequence");
                wr_seq_h.start(p_sequencer.master_seqr[j]);
            end

            1: begin
                incr_write_8sequence wr_seq_h;
                wr_seq_h = incr_write_8sequence::type_id::create("incr_write_8sequence");
                wr_seq_h.start(p_sequencer.master_seqr[j]);
            end

            1: begin
                incr_write_16sequence wr_seq_h;
                wr_seq_h = incr_write_16sequence::type_id::create("incr_write_16sequence");
                wr_seq_h.start(p_sequencer.master_seqr[j]);
            end

            1: begin
                wrap_write_4sequence wr_seq_h;
                wr_seq_h = wrap_write_4sequence::type_id::create("wrap_write_4sequence");
                wr_seq_h.start(p_sequencer.master_seqr[j]);
            end

            1: begin
                wrap_write_8sequence wr_seq_h;
                wr_seq_h = wrap_write_8sequence::type_id::create("wrap_write_8sequence");
                wr_seq_h.start(p_sequencer.master_seqr[j]);
            end

            1: begin
                wrap_write_16sequence wr_seq_h;
                wr_seq_h = wrap_write_16sequence::type_id::create("wrap_write_16sequence");
                wr_seq_h.start(p_sequencer.master_seqr[j]);
            end

            endcase

            
         end
        join
      end
    endtask


endclass

class virtual_single_write_sequence extends virtual_base_sequence;
    `uvm_object_utils(virtual_single_write_sequence)
    function new(string name="virtual_single_write_sequence");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_info(get_type_name(), "Executing virtual_single_write_sequence", UVM_MEDIUM)
        for(int i=0;i<master_number;i++)begin
        automatic int j=i;
        fork begin
            single_write_sequence wr_seq_h;
            wr_seq_h = single_write_sequence::type_id::create("single_write_sequence");
            wr_seq_h.start(p_sequencer.master_seqr[j]);
         end
        join
      end
    endtask


endclass

class virtual_single_read_sequence extends virtual_base_sequence;
    `uvm_object_utils(virtual_single_read_sequence)
    function new(string name="virtual_single_read_sequence");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_info(get_type_name(), "Executing virtual_single_read_sequence", UVM_MEDIUM)
        for(int i=0;i<master_number;i++)begin
        automatic int j=i;
        fork begin
            single_read_sequence wr_seq_h;
            wr_seq_h = single_read_sequence::type_id::create("single_read_sequence");
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
                    wr_seq_h.start(p_sequencer.master_seqr[j]);
                end
                join_none
            end
        end
       

    
    endtask

endclass

class virtual_incr_read_sequence extends virtual_base_sequence;
    `uvm_object_utils(virtual_incr_read_sequence)
    function new(string name="virtual_incr_read_sequence");
        super.new(name);
    endfunction


    virtual task body();
        `uvm_info(get_type_name(), "Executing virtual_incr_read_sequence", UVM_MEDIUM)
   
        begin
            for(int i=0;i<master_number;i++)begin
                automatic int j=i;
                fork begin
                    incr_read_sequence wr_seq_h;
                    wr_seq_h = incr_read_sequence::type_id::create("incr_read_sequence");
                    wr_seq_h.start(p_sequencer.master_seqr[j]);
                end
                join_none
            end
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
                    wr_seq_h.start(p_sequencer.master_seqr[j]);
                end
                join_none
            end
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
                    incr_read_4sequence wr_seq_h;
                    wr_seq_h = incr_read_4sequence::type_id::create("incr_read_4sequence");
                    wr_seq_h.start(p_sequencer.master_seqr[j]);
                end
                join_none
            end
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
                    wr_seq_h.start(p_sequencer.master_seqr[j]);
                end
                join_none
            end
        end
       

    
    endtask

endclass

class virtual_incr_read_8sequence extends virtual_base_sequence;
    `uvm_object_utils(virtual_incr_read_8sequence)
    function new(string name="virtual_incr_read_8sequence");
        super.new(name);
    endfunction


    virtual task body();
        `uvm_info(get_type_name(), "Executing virtual_incr_read_8sequence", UVM_MEDIUM)
   
        begin
            for(int i=0;i<master_number;i++)begin
                automatic int j=i;
                fork begin
                    incr_read_8sequence wr_seq_h;
                    wr_seq_h = incr_read_8sequence::type_id::create("incr_read_8sequence");
                    wr_seq_h.start(p_sequencer.master_seqr[j]);
                end
                join_none
            end
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

class virtual_incr_read_16sequence extends virtual_base_sequence;
    `uvm_object_utils(virtual_incr_read_16sequence)
    function new(string name="virtual_incr_read_16sequence");
        super.new(name);
    endfunction


    virtual task body();
        `uvm_info(get_type_name(), "Executing virtual_incr_read_16sequence", UVM_MEDIUM)
   
        begin
            for(int i=0;i<master_number;i++)begin
                automatic int j=i;
                fork begin
                    incr_read_16sequence wr_seq_h;
                    wr_seq_h = incr_read_16sequence::type_id::create("incr_read_16sequence");
                    wr_seq_h.start(p_sequencer.master_seqr[j]);
                end
                join_none
            end
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
            wr_seq_h.start(p_sequencer.master_seqr[j]);
         end
        join_none
        
      end
    endtask

endclass

class virtual_wrap_read_4sequence extends virtual_base_sequence;
    `uvm_object_utils(virtual_wrap_read_4sequence)
    function new(string name="virtual_wrap_read_4sequence");
        super.new(name);
    endfunction


    virtual task body();
        `uvm_info(get_type_name(), "Executing virtual_wrap_read_4sequence", UVM_MEDIUM)
        for(int i=0;i<master_number;i++)begin
        automatic int j=i;
        fork begin
            wrap_read_4sequence wr_seq_h;
            wr_seq_h = wrap_read_4sequence::type_id::create("wrap_read_4sequence");
            wr_seq_h.start(p_sequencer.master_seqr[j]);
         end
        join_none
        
      end
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
            wr_seq_h.start(p_sequencer.master_seqr[j]);
         end
        join_none
        
      end
    endtask

endclass

class virtual_wrap_read_8sequence extends virtual_base_sequence;
    `uvm_object_utils(virtual_wrap_read_8sequence)
    function new(string name="virtual_wrap_read_8sequence");
        super.new(name);
    endfunction


    virtual task body();
        `uvm_info(get_type_name(), "Executing virtual_wrap_read_8sequence", UVM_MEDIUM)
        for(int i=0;i<master_number;i++)begin
        automatic int j=i;
        fork begin
            wrap_read_8sequence wr_seq_h;
            wr_seq_h = wrap_read_8sequence::type_id::create("wrap_read_8sequence");
            wr_seq_h.start(p_sequencer.master_seqr[j]);
         end
        join_none
        
      end
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
            wr_seq_h.start(p_sequencer.master_seqr[j]);
         end
        join_none
        
      end
    endtask

endclass

class virtual_wrap_read_16sequence extends virtual_base_sequence;
    `uvm_object_utils(virtual_wrap_read_16sequence)
    function new(string name="virtual_wrap_read_16sequence");
        super.new(name);
    endfunction


    virtual task body();
        `uvm_info(get_type_name(), "Executing virtual_wrap_read_16sequence", UVM_MEDIUM)
        for(int i=0;i<master_number;i++)begin
        automatic int j=i;
        fork begin
            wrap_read_16sequence wr_seq_h;
            wr_seq_h = wrap_read_16sequence::type_id::create("wrap_read_16sequence");
            wr_seq_h.start(p_sequencer.master_seqr[j]);
         end
        join_none
        
      end
    endtask

endclass

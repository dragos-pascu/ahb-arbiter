class error_test extends base_test;
    `uvm_component_utils(error_test)

    function new(string name="error_test", uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
      virtual_base_sequence::type_id::set_type_override(virtual_error_sequence::get_type());
      super.build_phase(phase);
      
    endfunction

    task run_phase(uvm_phase phase);
      super.run_phase(phase);
    endtask
endclass
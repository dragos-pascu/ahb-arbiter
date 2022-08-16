class memory extends uvm_component;
    `uvm_component_utils(memory)
    int mem[int];

    function new(string name="memory",uvm_component parent=null);
   
        super.new(name,parent);
        
    endfunction 

    function void write(int addr, int value);
        mem[addr] = value;
    endfunction

    function int read(int addr);
        return mem[addr];
    endfunction

    function void print();
        $display("Inside memory");
        foreach (mem[key]) begin
            $display("key: %d value: %d", key, mem[key]); 
        end
    endfunction


endclass
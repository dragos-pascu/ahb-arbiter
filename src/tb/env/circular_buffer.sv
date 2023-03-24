class CircularBuffer;

    int capacity = 100; 
    ahb_transaction buffer[100]; // default capacity
    int head = 0;
    int tail = 0;
    int size = 0;

    
    function void add_transaction(ahb_transaction transaction);
        buffer[head] = transaction;
        head = (head + 1) % capacity;
        if (size < capacity) size++;
        else tail = (tail + 1) % capacity;
    endfunction
    
    function int get_size();
        return size;
    endfunction
    
    function ahb_transaction get_transaction(int index);
        if (index >= 0 && index < size)
            return buffer[(tail + index) % capacity];
        else begin
            ahb_transaction item = new;
            return item; // return a default-initialized transaction
        end
            
    endfunction
endclass

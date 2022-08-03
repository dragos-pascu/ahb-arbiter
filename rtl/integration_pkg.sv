  package integration_pkg;

  parameter[31:0] low_addr[] = {'d0,'d32,'d63,'d94,'d126,'d158,'d190,'d222,'d254,'d286,'d318};
  parameter[31:0] high_addr[] = {'d31,'d62,'d93,'d125,'d157,'d189,'d221,'d253,'d285,'d317,'d349};

  parameter master_number = 9;
  parameter slave_number = 11;
	parameter size_out	= 4;

  

typedef enum bit[1:0] {IDLE, BUSY, NONSEQ, SEQ} transfer_t;
typedef enum bit {READ, WRITE} rw_t;
typedef enum bit [2:0] {SINGLE, INCR, WRAP4, INCR4, WRAP8, INCR8, WRAP16, INCR16} burst_t;
typedef enum bit [2:0] {BYTE, HALFWORD, WORD, WORDx2, WORDx4, WORDx8, WORDx16, WORDx32} size_t;
typedef enum bit [1:0] {OKAY, ERROR, RETRY, SPLIT} resp_t;

endpackage
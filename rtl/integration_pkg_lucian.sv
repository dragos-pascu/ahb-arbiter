package integration_pkg;
timeunit 1ns/1ns;

//import uvm_pkg::*;

parameter master_number=9;
parameter slave_number=4;
parameter size_out=3;
parameter size_out_s=3;
parameter number_trans = 4; //numarul de secvente pentru un master
                                     //   0    1    2    3      4     5     6    7     8      9    10
parameter [31:0] slave_low_address[] = {'d0, 'd32,'d64,'d96, 'd128,'d160,'d192,'d224,'d256,'d288,'d320};
parameter [31:0] slave_high_address[] ={'d31,'d63,'d95,'d126,'d159,'d191,'d223,'d255,'d287,'d319,'d351};

typedef enum bit[1:0] {IDLE, BUSY, NONSEQ, SEQ} transfer_t;
typedef enum bit {READ, WRITE} rw_t;
typedef enum bit [2:0] {SINGLE, INCR, WRAP4, INCR4, WRAP8, INCR8, WRAP16, INCR16} burst_t;
typedef enum bit [2:0] {BYTE, HALFWORD, WORD, WORDx2, WORDx4, WORDx8, WORDx16, WORDx32} size_t;
typedef enum bit [1:0] {OKAY, ERROR, RETRY, SPLIT} resp_t;

parameter ARBITRATION = 0;
parameter ADDRESS =    1;
parameter DATA    =    2;

parameter MAX_SLAVE =  10;

//parameter IDLE      =  0;
    
endpackage: integration_pkg

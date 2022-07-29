package integration_pkg;

  parameter[31:0] low_addr[] = {'d0,'d32,'d63,'d94,'d126,'d158,'d190,'d222,'d254,'d286,'d318};
  parameter[31:0] high_addr[] = {'d31,'d62,'d93,'d125,'d157,'d189,'d221,'d253,'d285,'d317,'d349};

  parameter master_number = 9;
  parameter slave_number = 11;
	parameter size_out	= 4;

endpackage
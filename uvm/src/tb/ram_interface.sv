interface ram_interface(
	input clock,
	input reset);

//declaring variables for testbench
logic [`width-1:0]data_in;
logic read_enable;
logic write_enable;
logic [$clog2(`depth)-1:0] address;
logic [`width-1:0] data_out;

//defining Clocking block for driver
clocking cb_driver @(posedge clock, negedge reset);

	default input #1step  output #1step;
	output address;
	output write_enable;
	output read_enable;
	output data_in;
	inout reset;

endclocking

//defining Clocking block for Input monitor
clocking cb_in_monitor @(posedge clock, negedge reset);

	default input #1step  output #1step;
	input address;
	input write_enable;
	input read_enable;
	input data_in;
	input reset;

endclocking

//defining Clocking block for Output Monitor
clocking cb_out_monitor @(posedge clock, negedge reset);

	default input #1step output #1step;
	input data_out;
	input address;

endclocking

//defining Clocking block for driver
modport mp_driver (clocking cb_driver);

//defining clocking block for input monitor
modport mp_in_monitor (clocking cb_in_monitor);

//defining clocking block for output monitor
modport mp_out_monitor (clocking cb_out_monitor);

endinterface


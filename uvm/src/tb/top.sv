//importing UVM package
import uvm_pkg::*;

//including required files
`include "uvm_macros.svh"
`include "macros.sv"

`include "package.sv"

module top;

	//declaring clock and reset
	bit clock;
	bit reset;
	
	//defining clock generation
	initial
	begin
		clock <= 0;
		forever #5 clock = ~clock;
	end

	//driving reset
	initial
	begin
		reset = 0;
		#10;
		reset = 1;
	end

	//Instantiating DUT
	ram_design dut(
	.clock(clock),
	.reset(reset),
	.read_enable(intf_inst.read_enable),
	.write_enable(intf_inst.write_enable),
	.data_in(intf_inst.data_in),
	.data_out(intf_inst.data_out),
	.address(intf_inst.address));

	//Instantiating Interface
	intf intf_inst(
	.clock(clock),
	.reset(reset));

	//defining config db to access variables inside testbench components
	initial
	begin
		uvm_config_db#(virtual intf.mp_driver)::set(null, "", "vif", intf_inst.mp_driver);
		uvm_config_db#(virtual intf.mp_in_monitor)::set(null, "", "vif", intf_inst.mp_in_monitor);
		uvm_config_db#(virtual intf.mp_out_monitor)::set(null, "", "vif", intf_inst.mp_out_monitor);

		//initiating the simulation
		run_test("test");
	end

	//defining waveform file
	initial
	begin
		$dumpfile("dump.vcd");
		$dumpvars();
	end

endmodule

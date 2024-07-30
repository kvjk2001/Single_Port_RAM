import uvm_pkg::*;

`include "uvm_macros.svh"

class active_agent extends uvm_agent;

	`uvm_component_utils(active_agent)

	sequencer seq;
	driver drv;
	in_monitor in_mon;

	extern function new(string name = "active_agent", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);

endclass

	function active_agent::new(string name = "active_agent", uvm_component parent);
		super.new(name, parent);
	endfunction

	function void active_agent::build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq = sequencer::type_id::create("seq", this);
		drv = driver::type_id::create("drv", this);
		in_mon = in_monitor::type_id::create("in_mon", this);
	endfunction

	function void active_agent::connect_phase(uvm_phase phase);
		drv.seq_item_port.connect(seq.seq_item_export);
	endfunction



import uvm_pkg::*;

`include "uvm_macros.svh"

class ram_passive_agent extends uvm_agent;

	`uvm_component_utils(ram_passive_agent)

	ram_out_monitor out_mon;

	extern function new(string name = "passive_agent", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
endclass

	function ram_passive_agent::new(string name = "passive_agent", uvm_component parent);
		super.new(name, parent);
	endfunction

	function void ram_passive_agent::build_phase(uvm_phase phase);
		super.build_phase(phase);
	
		out_mon = ram_out_monitor::type_id::create("out_mon", this);
	endfunction


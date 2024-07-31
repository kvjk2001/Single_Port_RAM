import uvm_pkg::*;

`include "uvm_macros.svh"

class reference extends uvm_component;

	`uvm_component_utils(reference);

	uvm_analysis_imp #(sequence_item, reference) ref2in_mon;
	uvm_nonblocking_put_port #(sequence_item) ref2sb;

	sequence_item in_mon_packet; 

	virtual intf.mp_in_monitor vif;

	reg [7:0] mem [255:0];

	function new(string name = "reference", uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		in_mon_packet = sequence_item::type_id::create("in_mon_packet", this);
		ref2in_mon = new("ref2in_mon", this);
		ref2sb = new("ref2sb", this);
		uvm_config_db #(virtual intf.mp_in_monitor)::get(this, "", "vif", vif);
	endfunction

	function write(sequence_item packet);
		int ack;
		in_mon_packet = packet;
	
		if(!vif.cb_in_monitor.reset)
			in_mon_packet.data_out = 'z;
		else
		begin
			if(in_mon_packet.write_enable && !in_mon_packet.read_enable)
				mem[in_mon_packet.address] = in_mon_packet.data_in;
			else if(!in_mon_packet.write_enable && in_mon_packet.read_enable)
				in_mon_packet.data_out = mem[in_mon_packet.address];
			else
				in_mon_packet.data_out = 'z;
		end
		
		`uvm_info("REF", $sformatf("------------------------------NEW PACKET AT REF------------------------------------"), UVM_LOW);	
		`uvm_info("REF", $sformatf("Reset = %0h", vif.cb_in_monitor.reset), UVM_LOW);
		`uvm_info("REF", $sformatf("Read Enable = %0h", in_mon_packet.read_enable), UVM_LOW);
		`uvm_info("REF", $sformatf("Write Enable = %0h", in_mon_packet.write_enable), UVM_LOW);
		`uvm_info("REF", $sformatf("Data In = %0h", in_mon_packet.data_in), UVM_LOW);
		`uvm_info("REF", $sformatf("Address = %0h", in_mon_packet.address), UVM_LOW);
		`uvm_info("REF", $sformatf("Data Out = %0h", in_mon_packet.data_out), UVM_LOW);
		`uvm_info("REF", $sformatf("-----------------------------------------------------------------------------------"), UVM_LOW);


		ref2sb.try_put(in_mon_packet);			
	endfunction
endclass

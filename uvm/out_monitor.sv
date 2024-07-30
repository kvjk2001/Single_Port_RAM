class out_monitor extends uvm_monitor;

	//Registering output monitor of passive agent to factory
	`uvm_component_utils(out_monitor)

	//declaring virtual interface
	virtual intf.mp_out_monitor vif;

	//declaring analysis port for output monitor to coverage/scoreboard connection
	uvm_analysis_port #(sequence_item) out_mon2cov_sb;

	//declaring handle for sequence item
	sequence_item packet;

	extern function new(string name = "out_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

	//defining class constructor
	function out_monitor::new(string name = "out_monitor", uvm_component parent);
		super.new(name, parent);
	endfunction

	//defining build phase
	function void out_monitor::build_phase(uvm_phase phase);
		super.build_phase(phase);

		if(!uvm_config_db #(virtual intf.mp_out_monitor) :: get(this, "", "vif", vif))
			`uvm_fatal("monitor", "Unable to get virtual interface")

		out_mon2cov_sb = new("out_mon2cov_sb", this);

		packet = sequence_item::type_id::create("packet", this);
	endfunction

	//defining run phase
	task out_monitor::run_phase(uvm_phase phase);
		repeat(2) @(vif.cb_out_monitor);
	
		forever
		begin
			@(vif.cb_out_monitor)
			begin	
				packet.data_out = vif.cb_out_monitor.data_out;
				packet.address = vif.cb_out_monitor.address;
				`uvm_info("OUTPUT_MONITOR", $sformatf("data sampled = %0h",packet.data_out), UVM_LOW);
				`uvm_info("OUTPUT_MONITOR", $sformatf("Address = %0h", packet.address), UVM_LOW);
				out_mon2cov_sb.write(packet);
			end	
		end
	endtask


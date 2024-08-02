class ram_in_monitor extends uvm_monitor;

	//Registering input monitor of active agent to factory
	`uvm_component_utils(ram_in_monitor)

	//declaring virtual interface 
	virtual ram_interface.mp_in_monitor vif;

	//declaring analysis port for input monitor to coverage/reference 
	uvm_analysis_port #(ram_sequence_item) in_mon2cov_ref;

	//declaring handle for sequence item
	ram_sequence_item packet;

	extern function new(string name = "in_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass	

	//defining class constructor
	function ram_in_monitor::new(string name = "in_monitor", uvm_component parent);
		super.new(name, parent);
	endfunction

	//defining build phase
	function void ram_in_monitor::build_phase(uvm_phase phase);
		super.build_phase(phase);

		if(!uvm_config_db #(virtual ram_interface.mp_in_monitor) :: get(this, "", "vif", vif))
			`uvm_fatal("Input_Monitor", "Unable to get virtual interface")

		in_mon2cov_ref = new("in_mon2cov_ref", this);

		packet = ram_sequence_item::type_id::create("packet", this);
	endfunction

	//defining run task
	task ram_in_monitor::run_phase(uvm_phase phase);
		repeat(2) @(vif.cb_in_monitor);

		forever
		begin
			@(vif.cb_in_monitor)
			begin
				packet.data_in = vif.cb_in_monitor.data_in;
				packet.read_enable = vif.cb_in_monitor.read_enable;
				packet.write_enable = vif.cb_in_monitor.write_enable;
				packet.address = vif.cb_in_monitor.address;

/*
				`uvm_info("in_monitor", $sformatf("Reset = %0h", vif.cb_in_monitor.reset), UVM_LOW);
				`uvm_info("in_monitor", $sformatf("Read Enable = %0h", packet.read_enable), UVM_LOW);
				`uvm_info("in_monitor", $sformatf("Write Enable = %0h", packet.write_enable), UVM_LOW);
				`uvm_info("in_monitor", $sformatf("Data In = %0h", packet.data_in), UVM_LOW);
				`uvm_info("in_monitor", $sformatf("Address = %0h", packet.address), UVM_LOW);

*/
				in_mon2cov_ref.write(packet);
			end	
		end
	endtask


class driver extends uvm_driver #(sequence_item);

	//Registering driver class in factory
	`uvm_component_utils(driver)

	//declaring a virtual interface for driver
	virtual intf.mp_driver vif;

	//declaring a handle for sequence item
	sequence_item packet;	

	extern function new(string name = "driver", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task drive();

endclass

	//defining class constructor
	function driver::new(string name = "driver", uvm_component parent);
		super.new(name, parent);
	endfunction

	//defining build phase
	function void driver::build_phase(uvm_phase phase);
		super.build_phase(phase);
	
		if(!uvm_config_db #(virtual intf.mp_driver) :: get (this, "", "vif", vif))
		begin
			`uvm_fatal("driver", "Unable to get the virtual interface");
		end

		packet = sequence_item::type_id::create("packet", this);
	endfunction

	//defining run phase 
	task driver::run_phase(uvm_phase phase);
		repeat(1) @(vif.cb_driver);

		forever
		begin
			seq_item_port.get_next_item(packet);
			drive();


			`uvm_info("DRIVER", "---------------------------Driving Data----------------------------------", UVM_LOW);
			`uvm_info("DRIVER", $sformatf("Reset = %0h", vif.cb_driver.reset), UVM_LOW);
			`uvm_info("DRIVER", $sformatf("Read Enable = %0h", packet.read_enable), UVM_LOW);
			`uvm_info("DRIVER", $sformatf("Write Enable = %0h", packet.write_enable), UVM_LOW);
			`uvm_info("DRIVER", $sformatf("Data In = %0h", packet.data_in), UVM_LOW);
			`uvm_info("DRIVER", $sformatf("Address = %0h", packet.address), UVM_LOW);
			`uvm_info("DRIVER", "------------------------------------------------------------------------------", UVM_LOW);


			seq_item_port.item_done();		
		end
	endtask

	//driving inputs to DUT
	task driver::drive();
		@(vif.cb_driver)
		begin
			vif.cb_driver.data_in <= packet.data_in;
			vif.cb_driver.write_enable <= packet.write_enable;
			vif.cb_driver.read_enable <= packet.read_enable;
			vif.cb_driver.address <= packet.address;
		end
	endtask


